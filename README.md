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
                |  Kubernetes Ingress    |
                |        |               |
                |        v               |
                |  ClusterIP Service     |
                |        |               |
                |        v               |
                |  API Pods (2+)         |
                +-----------+------------+
                            |
                            v
                +------------------------+
                | Azure Database for      |
                | PostgreSQL Flexible     |
                | Server (Private)        |
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

Terraform uses AzureRM provider version `5.7.0`.

Validation performed for both environments:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

Terraform validation is configured in GitHub Actions for both Dev and Prod.

The current Prod Terraform plan has been validated successfully with:

```text
Plan: 12 to add, 0 to change, 0 to destroy.
```

No infrastructure is automatically applied by the repository workflow.

## Application

The application is a Node.js/Express hotel booking API.

### Endpoints

Health check:

```text
GET /health
```

Bookings:

```text
GET /api/bookings
```

Booking summary:

```text
GET /api/bookings/summary
```

The health endpoint checks PostgreSQL connectivity.

## Database

PostgreSQL 16 is used.

Schema:

```text
hotel_bookings
booking_events
```

The `hotel_bookings` table contains:

- Booking ID
- Organization ID
- Hotel ID
- City
- Check-in date
- Check-out date
- Amount
- Status
- Created timestamp

The `booking_events` table stores booking-related events using JSONB payloads.

### Data

The seed script creates:

- At least 100 hotel bookings
- Multiple organizations
- Multiple cities
- Multiple booking statuses
- Booking events

## Query Optimization

The assessment query is:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

An index is created for the filtering columns:

```sql
CREATE INDEX idx_hotel_bookings_city_created_at
    ON hotel_bookings (city, created_at);
```

This supports filtering by city and recent creation time before the grouping operation.

## Local Docker Compose

The repository includes Docker Compose for local PostgreSQL and API setup.

```bash
docker compose up --build
```

PostgreSQL:

```text
localhost:5432
```

API:

```text
http://localhost:8080
```

The PostgreSQL initialization scripts are mounted from:

```text
database/migrations/
database/seed/
```

The Docker Compose database credentials are intended only for local development and assessment testing.

## Database Backup

Backup script:

```text
scripts/backup.sh
```

Run:

```bash
./scripts/backup.sh
```

The script creates a timestamped PostgreSQL custom-format dump under:

```text
backups/
```

Example:

```text
backups/booking_db_20261007_153000.dump
```

## Database Restore

Restore script:

```text
scripts/restore.sh
```

Run:

```bash
./scripts/restore.sh backups/booking_db_20261007_153000.dump
```

The script:

1. Validates the backup file.
2. Drops the existing database.
3. Creates a fresh database.
4. Restores the PostgreSQL dump.
5. Verifies the number of restored hotel bookings.
6. Verifies the number of restored booking events.

## Kubernetes

Kubernetes manifests are located under:

```text
k8s/
├── namespace.yaml
├── deployment.yaml
├── service.yaml
└── ingress.yaml
```

### Deployment

The application runs with multiple replicas:

```yaml
replicas: 2
```

The deployment includes:

- CPU and memory requests
- CPU and memory limits
- Readiness probe
- Liveness probe

Health endpoint:

```text
/health
```

### Service

The application is exposed internally using a Kubernetes `ClusterIP` service.

```text
Application Gateway
        |
        v
Kubernetes Ingress
        |
        v
ClusterIP Service
        |
        v
Application Pods
```

### Ingress

The Kubernetes Ingress uses the Azure Application Gateway ingress class:

```yaml
ingressClassName: azure-application-gateway
```

The AKS Terraform configuration integrates the existing Application Gateway with AKS using the Application Gateway ingress integration.

## Container Image
