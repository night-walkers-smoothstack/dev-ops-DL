locals {
  name            = "aline-finacial"
  cluster_version = "0.0.1"
}

resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = local.name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  iam_role_arn    = aws_iam_role.db_connect.arn
  create_iam_role = false

  cluster_addons = {
    # Note: https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html#fargate-gs-coredns
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = flatten([module.vpc.private_subnets, module.vpc.public_subnets])

  # You require a node group to schedule coredns which is critical for running correctly internal DNS.
  # If you want to use only fargate you must follow docs `(Optional) Update CoreDNS`
  # available under https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html
  #   eks_managed_node_groups = {
  #     example = {
  #       desired_size = 1

  #       instance_types = ["t3.large"]
  #       labels = {
  #         Example    = "managed_node_groups"
  #         GithubRepo = "terraform-aws-eks"
  #         GithubOrg  = "terraform-aws-modules"
  #       }
  #       tags = {
  #         ExtraTag = "example"
  #       }
  #     }
  #   }

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "backend"
          labels = {
            Application = "backend"
          }
        },
        {
          namespace = "default"
          labels = {
            WorkerType = "fargate"
          }
        }
      ]

      tags = var.tags

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }

    secondary = {
      name = "secondary"
      selectors = [
        {
          namespace = "default"
          labels = {
            Environment = "test"
            GithubRepo  = "terraform-aws-eks"
            GithubOrg   = "terraform-aws-modules"
          }
        }
      ]

      # Using specific subnets instead of the subnets supplied for the cluster itself
      subnet_ids = [module.vpc.private_subnets[1]]

      tags = var.tags
    }

    coredns-fargate-profile = {
      name = "coredns"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
        }
      ]
      subnets = flatten([module.vpc.private_subnets])
    }
  }

  tags = var.tags
}

// coredns for Fargate
resource "aws_eks_addon" "coredns" {
  addon_name        = "coredns"
  addon_version     = "v1.8.4-eksbuild.1"
  cluster_name      = "eks-serve"
  resolve_conflicts = "OVERWRITE"
  depends_on        = [module.eks]
}

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = module.eks.cluster_certificate_authority_data # base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1alpha1"
#       args        = ["eks", "get-token", "--cluster-name", local.name]
#       command     = "aws"
#     }
#   }
# }

# resource "helm_release" "microservices" {
#   name = "microservices"
#   chart = "charts/"

# }