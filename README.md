# JDeMire-Secure-Azure-Foundation

![Terraform CI](https://github.com/jdemire-sys/JDeMire-Secure-Azure-Foundation/actions/workflows/terraform.yml/badge.svg?branch=main)


This is my first cloud project to serve as proof of my skills.
This project demonstrates core Azure administration (AZ-104), security engineering (AZ-500), and Terraform Associate skills with a zero-cost footprint on an Azure for Students subscription.

## What I Built:

### Resource Groups (RGs):

- rg-platform – core/shared services

- rg-landing – workload landing zone



### Networking:

- Virtual Network (vnet-landing) with an App subnet (snet-app)

- Network Security Group (nsg-landing) applied to the subnet



### Policy-as-Code (Azure Policy + Terraform):

- Enforce required tags on every RG and resource

- Restrict deployments to East US

- Deny creation of Public IP addresses




### RBAC / Identity:

- Scoped CI/CD identity at RG level for least privilege

- Ready to integrate with GitHub OIDC




## Key Outcomes

- Automated a baseline secure Azure environment with Terraform

- Enforced governance guardrails via Azure Policy (tags, region, no public IPs)

- Applied least privilege RBAC at RG scope (no subscription-wide over-permissioning)

- Delivered cost-efficient demo using only free resources (no VMs, NAT, Firewalls, etc.)




## Skills Demonstrated

- Infrastructure as Code (Terraform)

- Policy as Code (Azure Policy + Terraform integration)

- Azure Governance (RBAC, tagging strategy, allowed locations, deny rules)

- Secure Cloud Networking (VNets, subnets, NSGs)

- Cost Awareness (student subscription guardrails)




## Repo Structure
```
.github/
   workflows/
      terraform.yml

docs/
  portal-budget.png                  # Screenshot of the created budget guardrails
  portal-nsg.png                     # Screenshot of the created NSG
  portal-policies.png                # Screenshot of the created policies
  portal-rgs.png                     # Screenshot of the created resource groups
  portal-vnet-subnet-nsg_assoc.png   # Screenshot of the Vnet, Subnet, and NSG Association

infra/
  backend.tf                 # Used Azure storage as a remote backend     
  main.tf                    # Resource groups, networking baseline
  outputs.tf                 # Key resource outputs
  policy-definitions.tf      # Policy definitions and assignments
  providers.tf               # Azure providers used for this project
  variables.tf               # Inputs (location, tags, etc.)

.gitignore

LICENSE
README.md
```




## Why It Matters

- This project shows that I can:

- Build Azure environments from scratch with code

- Apply security and governance best practices from day one

- Work within cost constraints (important for both students and enterprises)

- Set up a foundation that can be extended into enterprise-grade landing zones