#!/bin/bash

# ArgoCD and NGINX Ingress Setup for GKE
# Run this script after your GKE cluster is deployed

echo "Setting up NGINX Ingress Controller and ArgoCD..."

# 1. Install NGINX Ingress Controller using Helm
echo "Installing NGINX Ingress Controller..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer \
  --set controller.service.annotations."cloud\.google\.com/load-balancer-type"="External"

# 1.5. Install cert-manager for automatic SSL certificates
echo "Installing cert-manager..."
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

# Wait for the LoadBalancer to get an external IP
echo "Waiting for LoadBalancer to get external IP..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Get the external IP
EXTERNAL_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "NGINX Ingress Controller External IP: $EXTERNAL_IP"

# 2. Install ArgoCD
echo "Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# 2.5. Create Let's Encrypt ClusterIssuer
echo "Creating Let's Encrypt ClusterIssuer..."
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: chris.jam.mcgee@gmail.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

# Wait for cert-manager to be ready
echo "Waiting for cert-manager to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/cert-manager -n cert-manager
kubectl wait --for=condition=available --timeout=120s deployment/cert-manager-webhook -n cert-manager

# 3. Create ArgoCD Ingress
echo "Creating ArgoCD Ingress..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS
    nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "300"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  name: argocd-server-ingress
  namespace: argocd
spec:
  rules:
  - host: argocd.${EXTERNAL_IP}.nip.io
    http:
      paths:
      - backend:
          service:
            name: argocd-server
            port:
              number: 443
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - argocd.${EXTERNAL_IP}.nip.io
    secretName: argocd-server-tls
EOF

# 4. Get ArgoCD initial admin password
echo "Getting ArgoCD initial admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo "ArgoCD URL: https://argocd.${EXTERNAL_IP}.nip.io"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"
echo ""
echo "SSL Certificate: Let's Encrypt will automatically provision"
echo "Certificate status: kubectl get certificate -n argocd"
echo ""
echo "IMPORTANT: Update the email in the ClusterIssuer before running!"
echo "Edit the script and replace 'chris.jam.mcgee@gmail.com' with your actual email."
echo ""
echo "Note: If you want to use a custom domain instead of nip.io,"
echo "update the Ingress host and configure your DNS to point to: $EXTERNAL_IP"
echo "=================================="