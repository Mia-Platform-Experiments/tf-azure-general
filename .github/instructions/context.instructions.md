---
applyTo: '**'
---
---
agent: agent
---
# Project Context: Mia-Platform to HCP Terraform Automation

## 1. Project Goal
To automate the provisioning of Azure resources (specifically Web Apps) using a self-service workflow triggered from the **Mia-Platform Console**, orchestrated by **GitHub Actions**, and executed by **HCP Terraform (HashiCorp Cloud Platform)**.

## 2. Architecture & Workflow

### The Pipeline Flow
1.  **Input (Mia-Platform):**
    * A user defines a **Custom Resource** (CR) in the Mia-Platform Console (e.g., providing `app_name`, `sku`).
    * Mia-Platform commits this configuration (typically as a JSON or YAML file) to the connected GitHub repository.
2.  **Trigger (Mia-Platform -> GitHub):**
    * The user clicks the **Deploy** button in Mia-Platform.
    * This sends a **Deployment Event** webhook to GitHub.
3.  **Orchestrator (GitHub Actions):**
    * A GitHub Action workflow listens for `on: [deployment]`.
    * The workflow parses the Custom Resource file to extract variables (e.g., `APP_NAME`).
    * It sets these as environment variables (`TF_VAR_app_name`).
    * It triggers HCP Terraform.
4.  **Executor (HCP Terraform):**
    * Receives the trigger via the Terraform CLI running in GitHub Actions.
    * Executes the `plan` and `apply` remotely on HashiCorp infrastructure.
    * Streams logs back to GitHub Actions (and visible in Mia-Platform).
5.  **Output (Azure):**
    * Resources are provisioned/updated in Azure.