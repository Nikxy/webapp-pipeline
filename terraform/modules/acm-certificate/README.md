# ACM - Amazon Certificate Manager Module
Creates the certificate for use in the ALB
### Input Variables

| Key    | Description                                   |
| ------ | --------------------------------------------- |
| domain | The domain which will be used for the web app |

### Output Variables 

| Key               | Description                                                             |
| ----------------- | ----------------------------------------------------------------------- |
| domain_validation | Domain validation information to be displayed for validating the domain |
| cert_arn          | The arn of the created certificate                                      |
