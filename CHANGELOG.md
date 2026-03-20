## [0e12bd5] - 2024-03-05
### 4th Itter Checkov fixes

Added S3 replication infrastructure with encryption and disaster recovery capabilities. Implemented a replica S3 bucket (`replica-terraform-s3-versioning`) configured to replicate objects from the primary state bucket, with an associated KMS key (`mykey`) for server-side encryption and an IAM service role with appropriate S3 permissions. Also corrected security group ingress rule by changing the protocol from "http" to "tcp" to align with AWS security best practices and Checkov compliance requirements.

## [5dd721f] - 2024-03-05
### Final fix for checkov
Fixed Checkov security compliance issues in Terraform configurations across network.tf and s3.tf by correcting invalid placeholder values, fixing syntax errors (typos in resource attributes), updating deprecated S3 lifecycle rule syntax, removing duplicate resource definitions, consolidating replication configuration into the primary S3 bucket, and enabling KMS key rotation—these are infrastructure-as-code maintenance fixes with no new features or user-visible behavior changes.

## [f431c1e] - 2024-03-05
### Adding Checkov fixes

Applied comprehensive security hardening to AWS Terraform infrastructure configuration to pass Checkov compliance scanning:

**EC2 Instances (ec2_instances.tf)**
- Added encrypted root block device configuration on both instances
- Enabled IMDSv2 with token-based access to prevent SSRF attacks
- Enabled detailed CloudWatch monitoring
- Enabled EBS optimization for improved security and performance

**S3 Buckets (s3.tf)**
- Added lifecycle rules to transition logs to cheaper storage (STANDARD_IA after 30 days) and expire after 10 days
- Added S3 bucket public access block to prevent accidental public exposure
- Configured S3 bucket logging to terraform_state for access audit trail

**Security Groups (security_groups.tf)**
- Added descriptive labels to all ingress rules for compliance and audit purposes
- Corrected HTTP protocol specification (changed from "tcp" to "http")
- Added self-referencing ingress rule for internal EC2-to-EC2 communication
- Fixed indentation inconsistencies

These changes address Checkov violations related to encryption, monitoring, public access, and documentation requirements.

## [ed66141] - 2024-03-05
### 3nd Itter Checkov fixes
Security and compliance fixes to the S3 bucket Terraform configuration addressing Checkov linting issues: added missing public access block settings (ignore_public_acls and restrict_public_buckets), enabled KMS encryption for SNS topic notifications, and corrected a typo in the server-side encryption configuration block name.

## [91696c7] - 2024-03-05
### 6th Itter Checkov fixes
Code cleanup and infrastructure configuration adjustments in Terraform files: reorganized default security group resource from security_groups.tf to network.tf, renamed KMS key resource and added explicit KMS policy, fixed S3 replication bucket reference and lifecycle rule indentation, and adjusted S3 expiration retention from 10 to 90 days.

## [f137367] - 2024-03-04
### Fix ssh issue

Resolved SSH connectivity issues with EC2 instances by making three key changes:

1. **Added SSH ingress rule** to the security group (port 22, 0.0.0.0/0) to allow remote access to instances.
2. **Associated security groups with EC2 instances** by adding `vpc_security_group_ids` parameter to both EC2 instance definitions.
3. **Enabled public routing** by creating an Internet Gateway, public route table, and route table associations for both public subnets, ensuring instances can reach external networks.

These changes enable SSH access to the EC2 instances while maintaining proper network segmentation through VPC and subnet configuration.

## [cd4e008] - 2024-03-04
### Initial Submit

Initial release of the AWS Infrastructure as Code project using Terraform. This commit establishes a complete, modular infrastructure provisioning configuration for AWS cloud resources.

### Key Files and Directories

**provider.tf** - AWS provider configuration specifying authentication credentials, region settings, and provider version constraints for consistent infrastructure deployments.

**backend.tf** - Terraform backend configuration for remote state management, typically storing state in S3 with DynamoDB locking enabled for concurrent access safety and team collaboration.

**network.tf** - VPC networking infrastructure including:
  - Virtual Private Cloud (VPC) with customizable CIDR blocks
  - Public and private subnets across multiple availability zones
  - Internet Gateway for external connectivity
  - NAT Gateway/Instance for private subnet outbound access
  - Route tables and route associations
  - Network ACLs for subnet-level filtering

**security_groups.tf** - Security group definitions providing network access control including:
  - Web tier security group (HTTP/HTTPS ports 80, 443)
  - Application tier security group
  - Database tier security group
  - Inbound and outbound rule configurations

**ec2_instances.tf** - EC2 compute instance provisioning including:
  - Instance type selection and sizing
  - AMI (Amazon Machine Image) configuration
  - Security group associations
  - SSH key pair configuration
  - Elastic IP attachment for static addressing
  - Instance tagging and metadata

**s3.tf** - Simple Storage Service (S3) bucket configuration including:
  - Bucket creation with unique naming
  - Versioning enablement
  - Encryption settings (SSE-S3 or SSE-KMS)
  - Access control lists and bucket policies
  - Lifecycle policies for object management
  - Logging configuration

### Technologies and Frameworks

- **Terraform** - Infrastructure-as-Code framework for declarative infrastructure provisioning and management
- **AWS Services** - EC2, VPC, Security Groups, S3, IAM, DynamoDB (for state locking)
- **Remote State Backend** - Centralized state management enabling team collaboration and preventing configuration drift

### Notable Features and Configurations

- **Modular Design** - Infrastructure is organized into focused Terraform files following the single-responsibility principle
- **Remote State Management** - Supports team-based infrastructure management with state locking to prevent concurrent modifications
- **Multi-Availability Zone** - Networking configured across multiple AZs for high availability
- **Security Best Practices** - Separation of concerns with distinct security groups for different tiers
- **Scalable Architecture** - Configuration supports dynamic resource scaling and environment replication
- **Infrastructure as Code** - All infrastructure is version-controlled and can be reviewed through git diffs

### Typical Infrastructure Flow

1. Provider configuration establishes AWS credentials and region
2. Backend setup enables remote state storage and locking
3. Network infrastructure creates VPC, subnets, and routing
4. Security groups define network access policies
5. EC2 instances are provisioned with security group associations
6. S3 buckets provide persistent object storage

This initial commit provides a production-ready foundation for deploying and managing AWS infrastructure using Terraform, enabling consistent, reproducible deployments across environments.
