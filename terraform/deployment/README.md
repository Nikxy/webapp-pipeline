# Terraform Deployment
The main Terraform configuration which uses the modules:
* [Network](../modules/network/README.md)
* [ACM](../modules/acm-certificate/README.md)
* [ALB](../modules/alb/README.md)
* [WAF](../modules/waf/README.md)
* [Compute](../modules/compute/README.md)

Backand is configured and created in [Backend](../backend/README.md)
### Input Variables

| Key                    | Description                                    |
| ---------------------- | ---------------------------------------------- |
| app_name               | App name for tagging and resource names prefix |
| app_domain             | Domain to use in certficate                    |
| aws_region             | AWS Region to use                              |
| aws_availability_zones | Availability Zones to use **\* At least 2 AZs required**|
| vpc_cidr               | The Cidr to use in VPC                         |
| app_image              | The name of the image to use in deployment     |

### Output Variables

| Key               | Description                                    |
| ----------------- | ---------------------------------------------- |
| domain_validation | DNS data for validating the domain             |
| alb_dns_name      | DNS name of the ALB to configure the domain to |
