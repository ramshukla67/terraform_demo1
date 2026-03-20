## [91696c7] - 2024-03-05
### 6th Itter Checkov fixes
Code cleanup and infrastructure configuration adjustments in Terraform files: reorganized default security group resource from security_groups.tf to network.tf, renamed KMS key resource and added explicit KMS policy, fixed S3 replication bucket reference and lifecycle rule indentation, and adjusted S3 expiration retention from 10 to 90 days.

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
