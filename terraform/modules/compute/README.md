# Compute Module
Creates the Instance Template, Auto Scaling Group and Security Group required for compute
### Input Variables 

| Key        | Description                              |
| ---------- | ---------------------------------------- |
| app_name   | For resources name prefix                |
| vpc_id     | Id of the VPC to use                     |
| vpc_cidr   | IP/CIDR of VPC                           |
| subnets    | Subnets used                             |
| ingress_sg | Ingress security group id for an sg rule |
| image_url  | The url to the Docker image to use       |

### Output Variables

| Key      | Description                                                  |
| -------- | ------------------------------------------------------------ |
| asg_id   | Auto Scaling Group Id                                        |

### Security Group

| Direction | Protocol | Ports | Cidr      | Description                                          |
| --------- | -------- | ----- | --------- | ---------------------------------------------------- |
| Ingress   | TCP | 8000  | VPC       | Allow traffic from ALB to app                        |
| Egress    | TCP | 443   | 0.0.0.0/0 | Allow accessing the internet for API, yum and Docker |
