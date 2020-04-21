module "vpc" {
  source = "../modules/vpc"

  vpc_cidr       = var.vpc_cidr
  default_tags = {
    "Name": "terraform-eks", 
    "kubernetes.io/cluster/${var.cluster_name}": "shared"
  }
}

module "eks" {
  source = "../modules/eks"

  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_list = module.vpc.subnet_list
}
