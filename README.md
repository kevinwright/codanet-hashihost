# codanet-hashihost
Provisioning a cleanly installed debian host with the hashicorp stack

_Note: All steps must be run as `root`_

## Preparation

Run `prepare.sh` in the `prepare` directory

## Enable services

In `enable_services`

- If this is the first machine, run `keygen.sh`
- Otherwise, copy `keys.gitignore.auto.tfvars` from the first machine
- `terraform init`
- `terraform apply`

## Enable ACL