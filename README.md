# Terraform Workspace — Civo

A hands-on Terraform project for provisioning infrastructure on **Civo Cloud** using reusable Terraform modules and Terraform Workspaces.

## Architecture

The root module composes three reusable modules:

```text
Terraform Root Module
│
├── Network Module
│   └── Creates a workspace-specific Civo network
│
├── Firewall Module
│   └── Creates a workspace-specific firewall attached to the network
│
└── Instance Module × 3
    ├── cloudops-<workspace>-1
    ├── cloudops-<workspace>-2
    └── cloudops-<workspace>-3
```

The active Terraform workspace is included in the network, firewall, and instance names. This prevents `dev` and `prod` from trying to create resources with the same names.

The network ID is passed from the network module to the firewall module, and both the network and firewall IDs are passed to the instance modules.

## Project Structure

```text
terraform-workspace/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── backend.tf
├── .gitignore
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── output.tf
    │   ├── varibles.tf
    │   └── versions.tf
    ├── firewall/
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── variables.tf
    │   └── versions.tf
    └── instance/
        ├── main.tf
        ├── outputs.tf
        ├── variables.tf
        └── versions.tf
```

## Terraform Configuration

The project requires Terraform `>= 1.15.0` and uses the Civo provider with the `~> 1.1` constraint. The provider is configured using the selected Civo region.

Root variables:

- `region` — Civo region; defaults to `nyc1`.
- `ssh_key_id` — Civo SSH key ID.
- `disk_image` — Civo disk image UUID.

`network_id` and `firewall_id` are **not** root variables. They are produced by the network and firewall modules and passed directly to the instance module.

## Terraform Workspaces

This project uses Terraform Workspaces to keep infrastructure state separate between environments.

The environments are:

```text
 dev  → 3 instances
 prod → 3 instances
```

Each workspace creates its own network and firewall as well as its three instances.

For example:

```text
dev
├── devops-dev-network
├── devops-dev-firewall
├── cloudops-dev-1
├── cloudops-dev-2
└── cloudops-dev-3

prod
├── devops-prod-network
├── devops-prod-firewall
├── cloudops-prod-1
├── cloudops-prod-2
└── cloudops-prod-3
```

The root module uses `count = 3` for the instance module, while `terraform.workspace` is used to identify the environment.

## Remote Terraform State

The project is configured to use **Civo Object Store** as an S3-compatible remote backend.

The Object Store endpoint used by this project is:

```text
https://objectstore.nyc1.civo.com
```

The backend is defined in `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"

    endpoints = {
      s3 = "https://objectstore.nyc1.civo.com"
    }

    region = "nyc1"

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    use_path_style              = true

    skip_s3_checksum = true
  }
}
```

The backend uses the S3 protocol, but the storage itself is **Civo Object Store**, not AWS S3.

### Backend credentials

Do not commit Object Store credentials to Git. Configure them through environment variables:

```bash
export AWS_ACCESS_KEY_ID="YOUR_CIVO_OBJECT_STORE_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_CIVO_OBJECT_STORE_SECRET_KEY"
```

These variable names are used because the Civo Object Store is S3-compatible.

### Initialize or migrate the backend

For a new checkout:

```bash
terraform init
```

When moving an existing local state to the remote backend:

```bash
terraform state pull > terraform-state-backup.json
terraform init -migrate-state
```

Always keep a backup of the local state before migration.

> **Note:** Civo Object Store currently requires Object Stores to be created with a minimum size of 500 GB in the Civo CLI used for this project.

## Getting Started

### 1. Configure Civo credentials

Configure your Civo API credentials using the Civo CLI/environment according to your local setup. Do not commit credentials to the repository.

### 2. Configure local Terraform variables

Create a local `terraform.tfvars` file with your environment-specific values:

```hcl
region     = "nyc1"
ssh_key_id = "YOUR_SSH_KEY_ID"
disk_image = "YOUR_DISK_IMAGE_UUID"
```

`terraform.tfvars` is intentionally ignored by Git because it contains environment-specific infrastructure values.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Format and validate

```bash
terraform fmt -recursive
terraform validate
```

### 5. Create the development workspace

```bash
terraform workspace new dev
```

If it already exists:

```bash
terraform workspace select dev
```

### 6. Plan and apply development

```bash
terraform plan
terraform apply
```

This creates one development network, one development firewall, and three Civo instances.

### 7. Create the production workspace

```bash
terraform workspace new prod
```

Or, if it already exists:

```bash
terraform workspace select prod
```

Then:

```bash
terraform plan
terraform apply
```

This creates a separate production network, firewall, and three instances tracked by the `prod` workspace state.

## Workspace Commands

List workspaces:

```bash
terraform workspace list
```

Show the current workspace:

```bash
terraform workspace show
```

Switch environments:

```bash
terraform workspace select dev
terraform workspace select prod
```

Destroy only the current workspace:

```bash
terraform destroy
```

> Always run `terraform workspace show` before `terraform destroy` to confirm that you are operating on the intended environment.

## Outputs

The root module exposes:

- `network_id`
- `firewall_id`
- `instance_ids`
- `instance_public_ips`

The instance outputs use `module.instance[*]` because the instance module is created three times with `count`.

## Security

`terraform.tfvars` is ignored by Git in this project, along with Terraform state files, the `.terraform` directory, and private key files. Keep Civo API credentials, Object Store credentials, and other sensitive infrastructure values out of Git history.

Never commit:

```text
terraform.tfvars
terraform.tfstate
terraform.tfstate.*
*.pem
```

## Current Status

The current root configuration:

- Creates a separate network for each Terraform workspace.
- Creates a separate firewall for each Terraform workspace.
- Creates three Civo instances per workspace.
- Uses workspace-aware resource names.
- Supports Civo Object Store as an S3-compatible Terraform backend.
- Uses Terraform Workspaces to isolate `dev` and `prod` state.

## Learning Goals

This project is intended to practice:

- Terraform modules
- Module inputs and outputs
- Terraform `count`
- Terraform Workspaces
- Workspace-specific resource naming
- State isolation between environments
- Remote Terraform state
- S3-compatible backends
- Resource dependencies between modules
- Civo infrastructure provisioning
