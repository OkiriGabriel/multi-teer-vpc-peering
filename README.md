# Multi-Region VPC Peering

This repository contains Terraform scripts to set up VPC peering between two AWS regions. The VPC peering connection allows resources in the two regions to communicate with each other with low latency.

## Architecture

The architecture of the VPC peering setup is as follows:

- Primary Region: The region where you want to create the primary VPC.
- Secondary Region: The region where you want to create the secondary VPC.

The VPC peering connection is established between the primary and secondary VPCs, allowing communication between resources in both regions.

## Prerequisites

Before getting started, ensure that you have the following:

- AWS CLI configured with appropriate credentials.
- Terraform installed on your local machine.

## Deployment Steps

To deploy the VPC peering connection between two regions, follow these steps:

1. Clone this repository to your local machine.
2. Open the terminal and navigate to the directory containing the Terraform script.
3. Open the `main.tf` file and update the following variables:
   - `region`: Set the primary AWS region where you want to create the primary VPC.
   - `peer_region`: Set the secondary AWS region where you want to create the secondary VPC.
   - Update any other variables as needed (AMI, instance type, etc.).
4. Run `terraform init` to initialize the Terraform workspace.
5. Run `terraform apply` to create the VPC peering connection and configure routing tables.
6. After the deployment is complete, you can access the EC2 instances in each VPC for testing connectivity between the regions.

## Testing Connectivity

To test the connectivity between the two regions, follow these steps:

1. Connect to the EC2 instance created in the primary region.
2. Use SSH to access the instance.
3. Ping the IP address of the EC2 instance created in the secondary region.