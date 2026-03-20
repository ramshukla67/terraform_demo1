# AWS Infrastructure as Code with Terraform

A comprehensive Terraform configuration for provisioning and managing AWS cloud infrastructure resources.

## Tech Stack

- Terraform (Infrastructure as Code)
- AWS (Amazon Web Services)
- AWS EC2, VPC, Security Groups, S3

## Prerequisites

- Terraform 1.0+ installed
- AWS CLI configured with appropriate credentials
- AWS Account with necessary permissions for EC2, VPC, S3, and IAM resources
- SSH key pair for EC2 instance access

## Installation and Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned infrastructure changes:
   ```bash
   terraform plan
   ```

4. Apply the infrastructure configuration:
   ```bash
   terraform apply
   ```

5. Confirm the changes by typing `yes` when prompted.

## Project Structure

The infrastructure is organized into modular Terraform files:

- **provider.tf** - Configures the AWS provider and authentication settings
- **backend.tf** - Manages Terraform state storage (typically in S3 with DynamoDB locking)
- **network.tf** - Defines VPC, subnets, internet gateways, route tables, and networking components
- **security_groups.tf** - Configures security group rules for inbound and outbound traffic control
- **ec2_instances.tf** - Provisions EC2 compute instances with appropriate configurations
- **s3.tf** - Creates S3 buckets for object storage with versioning and access policies

## Architecture Overview

This Terraform configuration creates a complete AWS infrastructure with:

- **Networking Layer** (network.tf): VPC infrastructure with public/private subnets, internet gateway, and route tables for traffic routing
- **Security Layer** (security_groups.tf): Network access control policies defining ingress and egress rules
- **Compute Layer** (ec2_instances.tf): EC2 instances for running applications and services
- **Storage Layer** (s3.tf): S3 buckets for data persistence and backup storage
- **State Management** (backend.tf): Remote state storage configuration for team collaboration
- **Provider Configuration** (provider.tf): AWS account and region settings

## Usage

Initialize and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

### Deploy Infrastructure

```bash
terraform apply
```

### View Current Infrastructure

```bash
terraform show
```

### Destroy Infrastructure

```bash
terraform destroy
```

### Validate Configuration

```bash
terraform validate
```

## Configuration Variables

Edit `.tfvars` files or use `-var` flags to customize:
- AWS region
- Instance types and counts
- VPC CIDR blocks
- Subnet configurations
- Security group rules
- S3 bucket names and policies

## State Management

The backend.tf file configures remote state storage, ensuring state is safely stored and shared across team members. Ensure proper access controls and versioning are enabled.

## Best Practices

- Always run `terraform plan` before applying changes
- Keep sensitive information in `.tfvars` files (not in version control)
- Use descriptive naming conventions for resources
- Enable versioning and encryption for S3 backend
- Regularly audit security group rules
- Test infrastructure changes in non-production environments first

# Terraform Infrastructure - Security Hardening

## Overview

The configuration defines a secure AWS environment with EC2 instances, S3 storage, networking (VPCs, subnets), and security groups.

## Security Improvements

### Network Security

- **Restricted SSH Access**: SSH (port 22) access is restricted to specific IP addresses (10.0.0.1/32) instead of allowing public access (0.0.0.0/0)
- **Public IP Assignment**: Automatic public IP assignment on subnets is disabled (map_public_ip_on_launch = false) to enforce explicit IP allocation policies
- **VPC Flow Logs**: Enabled VPC Flow Logs to monitor and log all network traffic for audit and troubleshooting purposes

### Compute Security

- **IAM Instance Profiles**: EC2 instances are configured with IAM instance profiles to enable role-based access control and eliminate the need for hardcoded credentials

### Storage Security

- **S3 Public Access Block**: S3 buckets are protected with public access blocks that prevent accidental public exposure of sensitive data
- **Server-Side Encryption**: S3 buckets use AWS KMS encryption for server-side encryption, ensuring data is encrypted at rest
- **S3 Bucket Notifications**: SNS topic integration enables real-time notifications for S3 object creation events

## Infrastructure Components

### Core Resources

- **EC2 Instances** (`ec2_instances.tf`): Two EC2 instances with IAM instance profiles
- **Networking** (`network.tf`): VPC with public subnets, route tables, and VPC Flow Logs
- **Storage** (`s3.tf`): S3 bucket with encryption, public access controls, and event notifications
- **Security Groups** (`security_groups.tf`): Restrictive ingress rules for EC2 instances

## Compliance

This infrastructure configuration passes Checkov security scanning and implements AWS Well-Architected Framework security best practices.

# Terraform AWS Infrastructure

This repository contains Terraform configurations for deploying AWS infrastructure including EC2 instances, S3 buckets with replication and encryption, and security groups.

## Architecture

```mermaid
graph TD
    A[VPC: 10.0.0.0/16]
    B[Public Subnet 1: 10.0.1.0/24]
    C[Public Subnet 2: 10.0.2.0/24]
    D[EC2 Instance 1]
    E[EC2 Instance 2]
    F[Internet Gateway]
    G[Route Table]
    H[Security Group]
    
    A --> B
    A --> C
    B --> D
    C --> E
    A --> F
    A --> G
    G --> B
    G --> C
    H --> D
    H --> E
    F --> G
```

## Files

### vpc.tf

Defines the custom VPC and public subnets for the infrastructure.

### ec2_instances.tf

Provisioned two t2.micro EC2 instances with Ubuntu AMI, basic system updates, and security group associations for SSH and HTTP access.

### network.tf

Contains Internet Gateway, route table, and route table associations to enable public routing for both subnets.

### security_groups.tf

Defines security group rules:
- **SSH (Port 22):** Allows inbound traffic from anywhere (0.0.0.0/0) for remote access
- **HTTP (Port 80):** Allows inbound traffic from the internal subnets (10.0.1.0/24 and 10.0.2.0/24)
- **All Egress:** Allows all outbound traffic

## Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned infrastructure:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Security Considerations

- SSH access is open to the entire internet (0.0.0.0/0). For production use, restrict this to specific IP ranges.
- Ensure EC2 key pairs are properly secured and managed.
- Monitor security group rules regularly for unnecessary open access.

## Security Features

The infrastructure implements the following security hardening measures:

- **EC2 Encryption**: Root block devices are encrypted by default on all instances
- **IMDSv2 Enforcement**: Metadata service token-based access (http_tokens = "required") prevents SSRF attacks
- **Instance Monitoring**: CloudWatch monitoring enabled on all EC2 instances
- **EBS Optimization**: EBS-optimized instances for improved performance and security
- **S3 Public Access Block**: S3 buckets are protected from public access via bucket policies and ACLs
- **S3 Versioning**: Version control enabled on state buckets for audit trail and recovery
- **S3 Lifecycle Policies**: Automatic archival to cheaper storage classes and expiration of old logs
- **S3 Logging**: Server-side logging configured to track access and changes
- **Security Group Descriptions**: All ingress rules include descriptive labels for audit and compliance
- **Least Privilege Networking**: Security groups restrict traffic to required ports and protocols

## File Structure

- `ec2_instances.tf` - EC2 instance configuration with hardened defaults
- `s3.tf` - S3 bucket definitions with lifecycle and access control policies
- `security_groups.tf` - VPC security group rules with descriptions
- Additional supporting files for VPC, subnets, and networking

## System Architecture

```mermaid
graph TD
    EC2_1["EC2 Instance 1<br/>t2.micro<br/>Encrypted Root"]
    EC2_2["EC2 Instance 2<br/>t2.micro<br/>Encrypted Root"]
    SG["Security Group<br/>HTTP/SSH/Self"]
    S3_State["S3 Bucket<br/>Terraform State<br/>Versioned"]
    S3_Logs["S3 Bucket<br/>Access Logs"]
    PubSubnet1["Public Subnet 1"]
    PubSubnet2["Public Subnet 2"]
    VPC["VPC"]
    
    VPC --> PubSubnet1
    VPC --> PubSubnet2
    PubSubnet1 --> EC2_1
    PubSubnet2 --> EC2_2
    EC2_1 --> SG
    EC2_2 --> SG
    S3_State --> S3_Logs
```

### S3 Storage with Encryption and Replication

- **Primary Bucket**: `terraform_state` - Main S3 bucket for state management with server-side encryption using KMS
- **Replica Bucket**: `replica-terraform-s3-versioning` - Replication destination for disaster recovery
- **KMS Key**: `mykey` - Customer-managed KMS key for S3 encryption
- **Replication Role**: IAM role with S3 permissions for cross-bucket replication

### Security Groups

- **EC2 Security Group**: `ec2_sg` - Manages ingress rules for EC2 instances
  - HTTP (port 80) access restricted to CIDR blocks 10.0.1.0/24 and 10.0.2.0/24
  - TCP protocol correctly configured per security best practices

## Terraform Resources

### KMS

- `aws_kms_key.mykey` - Encryption key for S3 server-side encryption

### S3

- `aws_s3_bucket.terraform_state` - Primary state bucket
- `aws_s3_bucket.replica` - Replication destination
- `aws_s3_bucket_server_side_encription_configuration.sse_good` - SSE configuration using KMS
- `aws_s3_bucket_notification.bucket-notification` - Event notifications

### IAM

- `aws_iam_role.replication` - Service role for S3 replication
- `aws_iam_role_policy_attachment.replication` - Attaches S3 full access policy to replication role

### Security

- `aws_security_group.ec2_sg` - EC2 instance security group

## Security Notes

- S3 buckets are encrypted using customer-managed KMS keys
- S3 replication is configured with source encryption selection criteria
- Security groups use TCP protocol as specified by Checkov security standards
- IAM replication role follows the principle of least privilege for S3 operations
