terraform {
  backend "s3" {
    endpoint = "https://spitfire.235.tdude.co:9002/"
    bucket   = "k8s-235-unifi-controller"
    key      = "terraform.tfstate"
    region   = "main"
    # We are using minio
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}