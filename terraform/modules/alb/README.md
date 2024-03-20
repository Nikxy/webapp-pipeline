# ALB - Application Load Balancer Module
Creates and attaches the ALB to the auto scaling group.
### Input Variables

| Key      | Description                           |
| -------- | ------------------------------------- |
| app_name | For resources name prefix             |
| vpc_id   | Id of the VPC to use                  |
| vpc_cidr | IP/CIDR of VPC                        |
| asg_id   | Id of the autoscaling group           |
| subnets  | Public subnets to deploy the ALB into |
| cert_arn | The ARN of the TLS certificate        |

### Output Variables

| Key      | Description                                                  |
| -------- | ------------------------------------------------------------ |
| lb_arn   | Arn of the created load balancer                             |
| lb_sg    | The security group created for and used by the load balancer |
| dns_name | The DNS name of the created load balancer                    |

### Security Group

| Direction | Ports      | Cidr      | Description                           |
| --------- | ---------- | --------- | ------------------------------------- |
| Ingress   | 443        | 0.0.0.0/0 | Allow HTTPS traffic                   |
| Egress    | 8000       | VPC       | Allow accessing the app               |
