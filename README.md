# Terraform Workspace — Civo

A hands-on Terraform project for provisioning infrastructure on **Civo Cloud** using reusable Terraform modules and Terraform Workspaces.

## Architecture

The root module composes three reusable modules:

```text
Terraform Root Module
│
├── Network Module
│   └── Creates Civo network
│
├── Firewall Module
│   └── Creates firewall attached to the network
│
└── Instance Module × 3
    ├── cloudops-<workspace>-1
    ├── cloudops-<workspace>-2
    └── cloudops-<workspace>-3
```

The network ID is passed from the network module to the firewall module, and both the network and firewall IDs are passed to the instance modules.

## Project Structure

```text
terraform-workspace/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
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

The project requires Terraform `>= 1.15.0` and uses the Civo provider with the `~> 1.1` constraint. The provider is configured using the selected Civo region. citeturn34file0turn31file0

Root variables:

- `region` — Civo region; defaults to `nyc1`.
- `ssh_key_id` — Civo SSH key ID.
- `disk_image` — Civo disk image UUID.

`network_id` and `firewall_id` are **not** root variables. They are produced by the network and firewall modules and passed directly to the instance module.

## Terraform Workspaces

This project uses Terraform Workspaces to keep infrastructure state separate between environments.

The initial environments are:

```text
 dev  → 3 instances
 prod → 3 instances
```

Because the instance hostname includes `terraform.workspace`, each environment gets different instance names:

```text
cloudops-dev-1
cloudops-dev-2
cloudops-dev-3

cloudops-prod-1
cloudops-prod-2
cloudops-prod-3
```

The root module uses `count = 3` for the instance module, while `terraform.workspace` is used to identify the environment.

## Getting Started

### 1. Configure Civo credentials

Configure your Civo API credentials using the Civo CLI/environment according to your local setup. Do not commit credentials to the repository.

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Format the configuration

```bash
terraform fmt -recursive
```

### 4. Validate the configuration

```bash
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

### 6. Plan the development environment

```bash
terraform plan
```

### 7. Apply the development environment

```bash
terraform apply
```

This creates one network, one firewall, and three Civo instances for the `dev` workspace.

### 8. Create the production workspace

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

This creates a separate set of resources tracked by the `prod` workspace state.

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

## Outputs

The root module exposes:

- `network_id`
- `firewall_id`
- `instance_ids`
- `instance_public_ips`

The instance outputs use `module.instance[*]` because the instance module is created three times with `count`.

## Security

`terraform.tfvars` is ignored by Git in this project, along with Terraform state files, the `.terraform` directory, and private key files. Keep credentials and sensitive infrastructure values out of Git history. fileciteturn27file0L2-L2

A local `terraform.tfvars` can contain the required values, for example:

```hcl
region     = "nyc1"
ssh_key_id = "YOUR_SSH_KEY_ID"
disk_image = "YOUR_DISK_IMAGE_UUID"
```

## Current Status

The current root configuration creates the network and firewall modules and calls the instance module three times. Instance names are derived from the active Terraform workspace. fileciteturn62file0L1-L10

## Learning Goals

This project is intended to practice:

- Terraform modules
- Module inputs and outputs
- Terraform `count`
- Terraform Workspaces
- State isolation between environments
- Resource dependencies between modules
- Civo infrastructure provisioning
