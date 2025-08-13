# AWS Three-Tier Architecture Deployment with Terraform

## Table of Contents
- [Overview](#overview)
- [Architecture Diagram](#architecture-diagram)
- [Key Features](#key-features)
- [Technologies Used](#technologies-used)
- [Implementation Steps](#implementation-steps)
  - [Phase 1: Defining Variables and Dependencies](#phase-1-defining-variables-and-dependencies)
  - [Phase 2: Custom VPC Creation](#phase-2-custom-vpc-creation)
  - [Phase 3: Subnet Creation](#phase-3-subnet-creation)
  - [Phase 4: Internet Gateway and NAT Gateway](#phase-4-internet-gateway-and-nat-gateway)
  - [Phase 5: Route Table Creation](#phase-5-route-table-creation)
  - [Phase 6: Route Table Association](#phase-6-route-table-association)
  - [Phase 7: Security Groups](#phase-7-security-groups)
  - [Phase 8: IAM](#phase-8-iam)
  - [Phase 9: Key Pair Creation and Storing](#phase-9-key-pair-creation-and-storing)
  - [Phase 10: RDS Creation](#phase-10-rds-creation)
  - [Phase 11: Test Instance Creation](#phase-11-test-instance-creation)
  - [Phase 12: Application Load Balancer, Target Groups, Auto Scaling Group](#phase-12-application-load-balancer-target-groups-auto-scaling-group)
  - [Phase 13: S3 & SSM Implementation](#phase-13-s3--ssm-implementation)
  - [Phase 14: Outputs](#phase-14-outputs)
- [User Interface](#user-interface)
- [Future Improvements](#future-improvements)
- [Terraform Project Index](#terraform-project-index)

---

## Overview
This project implements a **secure, scalable, and highly available three-tier web application architecture** on AWS, fully provisioned using **Terraform**.

All resources were **built entirely from scratch** — without pre-made templates — to demonstrate full Infrastructure as Code (IaC) design and AWS architecture skills.

The three tiers:
- **Web Tier** – Public-facing, handles incoming HTTP/HTTPS requests via a Public ALB.
- **App Tier** – Internal application logic, accessible only via an Internal ALB from the Web tier.
- **Database Tier** – Private RDS MySQL for persistent storage.

---

## Architecture Diagram
*(Insert diagram image here if available)*

---

## Key Features
- Fully automated deployment with Terraform.
- Multi-AZ deployment for high availability.
- Auto Scaling Groups for web and app tiers.
- Secure VPC with public/private subnets.
- Security Groups enforcing least privilege access.
- S3 for centralized static hosting.
- AWS SSM Parameter Store for secure credentials.
- Private RDS MySQL instance.

---

## Technologies Used
- **AWS Services**: VPC, EC2, ALB, ASG, RDS, S3, IAM, Parameter Store, IGW, NAT Gateway, Route Tables, Security Groups.
- **Terraform**: v1.x, AWS Provider.
- **Languages**: HCL, Bash.
- **Version Control**: GitHub.

---

## Implementation Steps

### Phase 1: Defining Variables and Dependencies
Defined parameters in `variables.tf` for:
- AWS Region
- AMI IDs
- Instance types
- MySQL DB settings
- S3 bucket name

### Phase 2: Custom VPC Creation
Created a custom VPC with a `/16` CIDR block to host all resources, providing logical isolation and custom IP addressing.

### Phase 3: Subnet Creation
Provisioned six subnets:
- 2 Public (Web)
- 2 Private (App)
- 2 Private (DB)
Distributed across two AZs for fault tolerance.

### Phase 4: Internet Gateway and NAT Gateway
- IGW for public internet access.
- NAT Gateway in a public subnet for private subnet outbound traffic.

### Phase 5: Route Table Creation
- Public RT → IGW
- Private RT → NAT Gateway

### Phase 6: Route Table Association
Associated:
- Public subnets → Public RT
- App & DB subnets → Private RTs

### Phase 7: Security Groups
Created SGs for:
- Web Tier (HTTP/HTTPS from public)
- App Tier (HTTP from Web Tier SG)
- DB Tier (MySQL from App Tier SG)
- ALBs with scoped access

### Phase 8: IAM
Created IAM roles & instance profiles:
- EC2 → S3 & SSM access
- Custom and managed policies

### Phase 9: Key Pair Creation and Storing
Generated AWS Key Pair, stored `.pem` securely, and associated with EC2 instances.

### Phase 10: RDS Creation
Launched private RDS MySQL:
- Multi-AZ
- Encrypted storage
- Backups enabled
- Access restricted to App Tier

### Phase 11: Test Instance Creation
Deployed test EC2s in Web/App tiers to validate:
- Network routing
- Internet access
- DB connectivity

### Phase 12: Application Load Balancer, Target Groups, Auto Scaling Group
**App Tier**:
- Internal ALB
- Target Group & listener
- Launch Template with PHP & DB connectivity
- ASG for scaling

**Web Tier**:
- Public ALB
- Target Group & listener
- Launch Template with S3 sync & API proxy
- ASG for scaling

### Phase 13: S3 & SSM Implementation
- S3 bucket for static code & assets
- SSM Parameter Store for DB credentials & endpoints

### Phase 14: Outputs
Terraform outputs for:
- Public ALB DNS
- Internal ALB DNS
- RDS endpoint
- DB name

---

## User Interface
- **Homepage** – Landing page for Employee Management Portal.
- **Add Employee** – Form to add employee details.
- **Form Submission** – Web → App → DB data flow.
- **View Employees** – Retrieve employee data from RDS.

---

## Future Improvements
- Add HTTPS with ACM.
- CloudFront CDN for caching.
- WAF for application security.
- Terraform modules for reusability.
- CI/CD pipeline integration.

---
