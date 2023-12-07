# tp-cloud-security
TP Cloud security: Terraform ELB with s3 logs access

&nbsp;

# Variables

| Variable Name | Type | Default Value | Description |
|---------------|------|---------------|-------------|
| region | string | "eu-west-1" | The AWS region to deploy resources |
| access_key | string | | The AWS access key ID |
| secret_key | string | | The AWS secret access key |
| ssh_public_key | string |  | Path to SSH public key for instances |
| network | object | See default value | The network configuration for the VPC and subnets |
| webserver_instance | object | See default value | Configuration for the EC2 instances |
| health_check | map | See default value | Configuration for the health check of the EC2 instances |


## Complex Variables Description 


### network Object Description
| Field | Type | Default Value | Description |
| --- | --- | --- | --- |
| cidr_block_vpc | string | "10.100.0.0/16" | The CIDR block for the VPC |
| subnets | list(map(any)) | See default value | The list of subnets details |

### webserver_instance Object Description
| Field | Type | Default Value | Description |
| --- | --- | --- | --- |
| names | list(string) | ["webserver-A", "webserver-B"] | The list of names for EC2 instances |
| ami | string | "ami-005e7be1c849abba7" | The AMI ID for the EC2 instances |
| type | string | "t2.micro" | The instance type for the EC2 instances |

### health_check Map Description
| Field | Type | Default Value | Description |
| --- | --- | --- | --- |
| timeout | number | 10 | The amount of time, in seconds, that the health check waits before it determines a request has failed |
| interval | number | 20 | The approximate amount of time, in seconds, between health checks of an individual target |
| path | string | "/" | The ping target for the health check |
| port | number | 80 | The port used for the health check |
| unhealthy_threshold | number | 2 | The number of consecutive failed health checks required before considering an EC2 instance unhealthy |
| healthy_threshold | number | 3 | The number of consecutive successful health checks required before considering an EC2 instance healthy |

&nbsp;
# Locals

## resource_prefix
A formatted string that combines `organization`, `class`, and `group` into a single value that can be used in resource names.

## sg_ports_allowed
A configuration for security group inbound and outbound ports and CIDR blocks.

Please note that the values in the `default` column are provided in `variables.tf` and `locals.tf` as the default value for variables and locals in the case that no value is provided in the `.tfvars` files. You can modify the values according to your needs using the `.tfvars` file.

&nbsp;

# Deploy infrastructure

* Set access_key and secret key in tfvars files

```console
delbechir@bngameni:~/tp-cloud-security  cat secrets-saba.tfvars
access_key     = "WWWXXXXXXXXXXX"
secret_key     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
ssh_public_key = "./ssh-keys/keyfile.pem.pub"

```

* Use terraform plan for show infra's preview

```console
delbechir@bngameni:~/tp-cloud-security terraform plan -var-file=secrets-saba.tfvars

```

* Apply preview

```console
delbechir@bngameni:~/tp-cloud-security terraform apply -var-file=secrets-saba.tfvars

```

# Contributors
Made with :love by:

* **Delibes Bechir BKWEDOU-NGAMENI  @bngameni**
* **Louis-Guilhem ROUSSEAU @luigilacastagne**
* **Alexis BAGAGE @Juanito2053**
* **Alexis BROYARD @B-Roy77**
* **Jérémy IROUDAYAME @JeremyIRO**
* **Sharon MALKA**
