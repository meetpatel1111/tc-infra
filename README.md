# Full Terraform (Generated)

Generated from `template.json` and `Azureresources.csv`.

## Usage
```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Notes:
- Update VM admin passwords.
- Storage account names must be globally unique.
- Public IP address values cannot be pinned; Azure assigns them even when allocation is Static.
