# Terraform AWS Modules

Reusable, versioned Terraform modules for provisioning standardized AWS infrastructure across projects and environments.

This repository provides a centralized set of infrastructure modules that can be consumed by application and infrastructure repositories within the organization. The goal is to reduce duplication, enforce AWS best practices, and provide a consistent infrastructure foundation across environments.

---

## Core Problems This Project Solves

### 1. Infrastructure duplication

Without reusable modules, every project has to independently implement resources such as:

* VPCs and subnets
* Security groups
* EKS clusters
* IAM roles and policies
* ECR repositories
* S3 buckets
* VPC endpoints
* Load balancer components

This leads to duplicated Terraform code and makes infrastructure difficult to maintain.

**Solution:**
Provide reusable Terraform modules that can be consumed by multiple projects.

---

### 2. Inconsistent infrastructure

Different teams can implement the same AWS architecture in different ways, resulting in inconsistent:

* Naming conventions
* Network configurations
* Security policies
* IAM permissions
* Tags
* AWS service configurations

**Solution:**
Centralize common infrastructure patterns and provide a standard implementation that projects can reuse.

---

### 3. Difficult infrastructure upgrades

When infrastructure configuration is duplicated across multiple repositories, upgrading a common component can require modifying many projects individually.

**Solution:**
Version the modules so projects can explicitly choose when to adopt new versions.

For example:

```hcl
module "vpc" {
  source  = "github.com/my-org/terraform-modules//modules/vpc"
  version = "v1.2.0"
}
```

A project can remain on `v1.2.0` while another project tests `v1.3.0` before upgrading production.

---

### 4. Lack of organizational standards

AWS infrastructure should follow consistent organizational standards for security, availability, tagging, networking, and resource configuration.

**Solution:**
The repository acts as an internal infrastructure platform, providing approved and reusable AWS building blocks.

---

# Key Design Decisions

## 1. Reusable Terraform Modules

Infrastructure is organized into independent Terraform modules rather than putting all resources into a single configuration.

Example:

```text
terraform-modules/
├── modules/
│   ├── vpc/
│   ├── eks/
│   ├── iam/
│   ├── ecr/
│   ├── s3/
│   ├── security-group/
│   └── load-balancer-controller/
└── README.md
```

### Why?

This allows different projects to consume only the infrastructure they need.

For example:

```text
Project A
 ├── VPC
 ├── EKS
 └── ECR

Project B
 ├── VPC
 ├── EC2
 └── RDS

Project C
 ├── VPC
 ├── EKS
 ├── ECR
 └── S3
```

The underlying infrastructure logic remains centralized.

---

## 2. Versioned Modules

Modules are versioned so infrastructure consumers can control upgrades.

For example:

```hcl
module "vpc" {
  source = "git::https://github.com/my-org/terraform-modules.git//modules/vpc?ref=v1.2.0"

  ...
}
```

### Why?

Versioning prevents an update to the central repository from unexpectedly changing infrastructure in consuming projects.

Teams can:

1. Test a new version.
2. Review the changes.
3. Upgrade development environments.
4. Validate the infrastructure.
5. Upgrade production when ready.

---

## 3. Dynamic AWS Availability Zone Discovery

The modules avoid hardcoding availability zones where possible.

Example:

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

The module can then dynamically select the required number of AZs.

### Why?

This makes the modules reusable across AWS regions without requiring region-specific configuration.

For example, the same module can be used in:

```text
eu-west-2
us-east-1
eu-west-1
ap-southeast-1
```

without hardcoding:

```text
eu-west-2a
eu-west-2b
eu-west-2c
```

---

## 4. Root-Level Provider and Terraform Configuration

Terraform and provider versions are managed by consuming projects rather than being duplicated inside every reusable module.

Example:

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
```

### Why?

Reusable modules should remain provider-agnostic where practical.

The consuming infrastructure repository controls:

* Terraform version
* AWS provider version
* AWS region
* Backend configuration
* Authentication
* Environment-specific settings

This makes the modules easier to reuse across multiple projects.

---

# Technology & Tools

| Technology                   | Purpose                            |
| ---------------------------- | ---------------------------------- |
| Terraform                    | Infrastructure as Code             |
| AWS                          | Cloud infrastructure               |
| GitHub                       | Source control and collaboration   |
| GitHub Actions               | CI/CD and module validation        |
| AWS IAM                      | Identity and access management     |
| Amazon VPC                   | Networking                         |
| Amazon EKS                   | Kubernetes infrastructure          |
| Amazon ECR                   | Container image registry           |
| Amazon S3                    | Object storage                     |
| AWS Load Balancer Controller | Kubernetes AWS load balancing      |
| Terraform Registry / Git     | Module distribution and versioning |

---

# Available Modules

The repository is designed to provide reusable AWS infrastructure components.

Example modules include:

```text
modules/
├── vpc/
├── eks/
├── iam/
├── ecr/
├── s3/
├── security-group/
└── load-balancer-controller/
```

Additional modules can be added as common infrastructure requirements emerge across projects.

---

# How to Use the Modules

## 1. Add the module to your Terraform project

Example:

```hcl
module "vpc" {
  source = "git::https://github.com/my-org/terraform-modules.git//modules/vpc?ref=v1.0.0"

  name = "payments-prod"
  cidr = "10.0.0.0/16"

  ...
}
```

Replace:

```text
my-org
```

with your GitHub organization name.

---

## 2. Configure Terraform

The consuming project defines its Terraform and provider configuration.

Example:

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
```

---

## 3. Initialize Terraform

Run:

```bash
terraform init
```

Terraform will download the required module and providers.

---

## 4. Review the infrastructure

Run:

```bash
terraform plan
```

Always review the plan before applying infrastructure changes.

---

## 5. Deploy

Apply the configuration:

```bash
terraform apply
```

Terraform will provision the AWS infrastructure defined by the consuming project.

---

# Example Repository Structure

A typical infrastructure repository consuming these modules could look like:

```text
payments-infrastructure/
├── environments/
│   ├── dev/
│   │   └── main.tf
│   ├── staging/
│   │   └── main.tf
│   └── production/
│       └── main.tf
├── terraform.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── backend.tf
```

The project then consumes modules from this repository.

```text
                         ┌─────────────────────┐
                         │ terraform-modules   │
                         │                     │
                         │ VPC                 │
                         │ EKS                 │
                         │ IAM                 │
                         │ ECR                 │
                         │ S3                  │
                         │ Security Groups     │
                         └──────────┬──────────┘
                                    │
                 ┌──────────────────┼──────────────────┐
                 │                  │                  │
                 ▼                  ▼                  ▼
        ┌────────────────┐ ┌────────────────┐ ┌────────────────┐
        │ Project A      │ │ Project B      │ │ Project C      │
        │                │ │                │ │                │
        │ Dev/Prod       │ │ Dev/Prod       │ │ Dev/Prod       │
        └────────────────┘ └────────────────┘ └────────────────┘
```

---

# Module Versioning

Releases should use Git tags.

Example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Consumers can then reference a specific version:

```hcl
module "vpc" {
  source = "git::https://github.com/my-org/terraform-modules.git//modules/vpc?ref=v1.0.0"
}
```

## Versioning Strategy

Use semantic versioning:

```text
vMAJOR.MINOR.PATCH
```

Example:

```text
v1.0.0
v1.1.0
v1.1.1
v2.0.0
```

### MAJOR

Breaking changes.

```text
v1.0.0 → v2.0.0
```

### MINOR

Backward-compatible functionality.

```text
v1.0.0 → v1.1.0
```

### PATCH

Backward-compatible bug fixes.

```text
v1.1.0 → v1.1.1
```

---

# Development Workflow

Changes to modules should go through pull requests.

Recommended workflow:

```text
Developer
    │
    ▼
Create branch
    │
    ▼
Modify module
    │
    ▼
Terraform fmt
    │
    ▼
Terraform validate
    │
    ▼
Security checks
    │
    ▼
Pull Request
    │
    ▼
Code Review
    │
    ▼
Merge
    │
    ▼
Create version tag
    │
    ▼
Projects consume new version
```

Recommended validation commands:

```bash
terraform fmt -check -recursive
terraform validate
```

Security and IaC scanning can also be integrated into GitHub Actions using tools such as:

* Checkov
* Trivy
* Gitleaks

---

# Security Principles

The modules are designed with security as a core requirement.

Key principles include:

* Least-privilege IAM
* Private networking where appropriate
* Restricted security-group rules
* Encryption where supported
* Avoiding hardcoded credentials
* Using AWS IAM roles instead of long-lived access keys where possible
* Consistent resource tagging
* Infrastructure security scanning during CI

---

# Contributing

1. Create a feature branch.

```bash
git checkout -b feature/add-new-module
```

2. Make your changes.

3. Format Terraform.

```bash
terraform fmt -recursive
```

4. Validate the configuration.

```bash
terraform validate
```

5. Run security checks.

6. Commit and push your changes.

```bash
git add .
git commit -m "feat: add new AWS module"
git push origin feature/add-new-module
```

7. Open a Pull Request.

8. After review and approval, merge the change.

9. Create a new version tag when appropriate.

---

# Goals

The long-term goal of this repository is to provide a reliable internal AWS infrastructure platform that allows teams to provision infrastructure quickly while maintaining organizational standards.

Instead of every project reinventing AWS infrastructure:

```text
Build once
     ↓
Standardize
     ↓
Version
     ↓
Reuse across projects
```

This enables teams to focus on delivering applications while the infrastructure foundation remains consistent, secure, and maintainable.

---

## License

Internal use within the organization unless otherwise specified.
