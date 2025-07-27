module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37"

  cluster_name    = "example-eks"
  cluster_version = "1.33"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  cluster_addons = {
    external-dns = {
      pod_identity_association = [
        {
          role_arn        = module.external_dns_pod_identity.iam_role_arn
          service_account = "external-dns"
        }
      ]
    }
  }
}

module "external_dns_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "1.12.1"

  name = "example-eks-external-dns"

  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]

  # associations は指定しない
  # EKS アドオン (eks.cluster_addons.external-dns) 側で指定するため
}
