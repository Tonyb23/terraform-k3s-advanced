locals {
    # Use a larger instance in prod, smaller in dev
    # terraform.workspace is a built-in variable that holds the
    # current workspace name (e.g. "dev" or "prod")
    instance_type = terraform.workspace == "prod" ? "c7i-flex.large" : "t3.small"

    # Similarly, we can set the volume size based on the environment
    # Use a larger disk in prod
    volume_size = terraform.workspace == "prod" ? 30 : 20

    # Common tags applied to every resource via the modules
    common_tags = {
        Project     = var.project_name
        Environment = terraform.workspace
        ManagedBy   = "Terraform"
        UpdatedBy   = "GitHubActions"
    }
}