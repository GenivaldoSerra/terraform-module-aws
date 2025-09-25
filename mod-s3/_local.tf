locals {

  Managed_By = "Terraform"
  Project    = "S3_Pipeline"
  tags = {
    "Managed_By" = Managed_By
    "Project"    = Project
  }
}