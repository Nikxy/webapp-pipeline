# Network resources module

Creates the required network resources for the web application.
Total creating:
- VPC
- Internet Gateway
- Public and private subnets with NAT Gateways in the specified availability zones
### Input Variables

| Key                    | Description                |
| ---------------------- | -------------------------- |
| app_name               | For resources name prefix  |
| aws_availability_zones | Availability zones to use  |
| vpc_cidr               | IP/CIDR for the VPC to use |
### Output Variables

| Key             | Description             |
| --------------- | ----------------------- |
| vpc_id          | Id of the created vpc   |
| public_subnets  | Public subnets created  |
| private_subnets | Private subnets created |

### Network ACL

| Direction | Ports      | Cidr      | Description                                     |
| --------- | ---------- | --------- | ----------------------------------------------- |
| Egress    | 443        | 0.0.0.0/0 | Allow HTTPS traffic out for API, yum and Docker |
| Ingress   | 32768-6100 | 0.0.0.0/0 | Allow return traffic for above rule             |
|           |            |           |                                                 |
| Ingres    | 8000       | VPC       | Allow traffic from Load Balancer                |
| Egress    | 1024-65535 | VPC       | Allow return traffic to Load Balancer           |

The network ACL is set for the private subnets.

### Route Tables

| Cidr      | Gateway          |
| --------- | ---------------- |
| 0.0.0.0/0 | Internet gateway |
| VPC Cidr  | local            |

For public subnets.

| Cidr      | Gateway     |
| --------- | ----------- |
| 0.0.0.0/0 | Nat gateway |
| VPC Cidr  | local       |

For private subnets