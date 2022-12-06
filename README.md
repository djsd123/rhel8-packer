# RHEL8 Packer
Example Packer Template to build a RHEL8\CentOS8 (Based) AMI in AWS

- Provisions Rhel8 AMI in AWS
- Includes Podman/Docker
- SSM Agent, awscli etc...


[packer]: https://developer.hashicorp.com/packer/downloads

## Requirements

| Name     | Version |
|----------|---------|
| [packer] | ~> 1.0  |


## Usage

Run a test build (No resulting AMI)
```shell
packer build -var "run_test_build=true" .
```

Run build to create an AMI
```shell
packer build .
```

Debug
```shell
PACKER_LOG=TRACE packer build -var "run_test_build=false" .
```

## TODO

 - Configure to use SSM session instead of ssh for provisioning
 - Encrypt with KMS
