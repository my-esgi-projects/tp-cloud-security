terraform {
  #   backend "s3" {
  #     bucket = "group-7-esgi-state-bucket"
  #     key    = "terraform/state"
  #   }

  backend "local" {
    path = "infra-group-7.tfstate"
  }
}
