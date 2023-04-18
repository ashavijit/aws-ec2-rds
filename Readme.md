# AWS RDS CONNECT TO WORDPRESS USING TERRAFORM

This is a simple example of how to connect to AWS RDS using Terraform.

## Requirements

- Terraform
- AWS Account
- AWS CLI

## Usage

- Clone this repository
- Run `terraform init`
- Run `terraform plan`
- Run `terraform apply`



## Author

- [Avijit Sen](https://github.com/ashavijit)

## License

MIT License

## Acknowledgments

- [Terraform](https://www.terraform.io/)

## References

- [Terraform AWS Provider](https://www.terraform.io/docs/providers/aws/index.html)

### For Setting up WordPress on AWS RDS using Terraform

- [AWS RDS Connect to WordPress using Terraform](https://ashavijit.com/2019/01/29/aws-rds-connect-to-wordpress-using-terraform/)

### Outputs

```

Apply complete! Resources: 2 added, 1 changed, 2 destroyed.

Outputs:

DBConnectionString = "terraform-20230418032448834000000002.cx2f0btf77u1.us-west-2.rds.amazonaws.com:3306"
DatabaseName = "wordpress"
DatabaseUserName = "admin"
WebServerIP = "44.236.230.123"

```
### Milestone Achieved

- Create an EC2 instance t4g.small and one RDS instance t4g.micro.
- The RDS instance should not be publicly accessible and should only be exposed to the EC2 instance.
- The script should also perform deployment and take the latest image of WordPress from Docker.
- The WordPress application should be exposed on port 80.
- Create an Elastic IP and attach it to the EC2 instance
- Add phpmyadmin in deployment on same instance, so that one can access Database.

### Working Now

- Add phpmyadmin in deployment on same instance, so that one can access Database.[Done]




