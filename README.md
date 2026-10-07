# Azure DevOps Assessment

Azure-based DevOps assessment project implementing a containerized hotel booking API, PostgreSQL database, Kubernetes deployment, and Terraform-managed Azure infrastructure.

## Architecture

```text
                        Internet
                           |
                           v
                +------------------------+
                | Azure Application      |
                | Gateway (Public)       |
                +-----------+------------+
                            |
                            v
                +------------------------+
                | Azure Kubernetes       |
                | Service (AKS)          |
                |                        |
                | Kubernetes Ingress     |
                |        |               |
                |        v               |
                | ClusterIP Service      |
                |        |               |
                |        v               |
                | API Pods (2+)          |
                +-----------+------------+
                            |
                            v
                +------------------------+
                | Azure Database for     |
                | PostgreSQL Flexible    |
                | Server (Private)       |
                +------------------------+

                +------------------------+
                | Azure Container        |
                | Registry (ACR)         |
                +------------------------+
                            |
                            v
                           AKS
```

## Azure Infrastructure

Infrastructure is managed using Terraform with separate Dev and Prod environments.

### Terraform Modules

```text
infra/
├── envs/
│   ├── dev/
│   └── prod/
└── modules/
    ├── acr/
    ├── aks/
    ├── appgateway/
    ├── network/
    └── postgres/
```

### Azure Components

- Azure Virtual Network
- Dedicated AKS subnet
- Dedicated Application Gateway subnet
- Dedicated PostgreSQL delegated subnet
- Azure Kubernetes Service
- Azure Application Gateway
- Azure Container Registry
- Azure Database for PostgreSQL Flexible Server
- Azure Private DNS Zone
- Private DNS VNet link
- PostgreSQL deletion protection for Prod

### Environment Separation

Dev and Prod use separate Terraform configurations and variable files.

| Component | Dev | Prod |
|---|---|---|
| VNet | `10.10.0.0/16` | `10.20.0.0/16` |
| AKS nodes | 1 | 2 |
| AKS VM | `Standard_D2s_v5` | `Standard_D4s_v5` |
| ACR SKU | Basic | Premium |
| PostgreSQL | `B_Standard_B1ms` | `GP_Standard_D2ds_v5` |
| PostgreSQL storage | 32 GB | 64 GB |
| Backup retention | 7 days | 35 days |
| Geo-redundant backup | Disabled | Enabled |
| PostgreSQL public access | Disabled | Disabled |
| Delete protection | Disabled | Enabled |

## Terraform Validation

Terraform uses the AzureRM provider.

Validation is performed for both Dev and Prod.

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

GitHub Actions performs the following checks for both environments:

```text
Terraform Format Check
        |
        v
Terraform Init
        |