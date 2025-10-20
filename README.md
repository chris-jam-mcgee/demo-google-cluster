# Terraform GCP GKE Project Structure

This project uses a modular Terraform structure to manage Google Kubernetes Engine (GKE) clusters across multiple environments.

## Project Structure

```
├── modules/
│   └── cluster/
│       ├── main.tf            # GKE cluster and node pool resources
│       ├── variables.tf       # Module input variables
│       └── outputs.tf         # Module outputs
├── environments/
│   ├── prod/
│   │   ├── main.tf           # Production environment configuration
│   │   ├── variables.tf      # Production variables
│   │   ├── outputs.tf        # Production outputs
│   │   └── terraform.tfvars  # Production variable values
│   └── nonprod/
│       ├── main.tf           # Non-production environment configuration
│       ├── variables.tf      # Non-production variables
│       ├── outputs.tf        # Non-production outputs
│       └── terraform.tfvars  # Non-production variable values
```

## Usage

### Production Environment
```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

### Non-Production Environment
```bash
cd environments/nonprod
terraform init
terraform plan
terraform apply
```