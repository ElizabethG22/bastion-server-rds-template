# Foobar

This is an EC2 bastion server and a RDS instance setup for the Sainsburys data academy final project's teams.

## Requirements

- docker
- docker-compose 

## Installation

- Create an environment file `deploy/.sainsburys.env` and put your fresh `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` in it. (you can find these credential with command  `cat ~/.aws/credentials`)
```sh
AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
AWS_SESSION_TOKEN=<your-aws-session-token>
```
- Create a file `deploy/terraform.tfvars` and put your desired values in it: 
```py
db_username = "<your-db-root-user-name>"
db_password = "<your-db-root-password>"
db_name     = "<your-db-name>"
```
- run:
```bash
make tf-init
```

## Usage

```python
# after every change make sure the syntax of the Terraform commands are right
make tf-validate

# read the plan to see what are going to be created
make tf-plan

# read the plan again and if this is what you want, confirm it
make tf-apply

# destroy your created infra
make tf-destroy
```