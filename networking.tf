
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "primary" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"

  tags = {
    "karpenter.sh/discovery" = "${var.kube.cluster_name}"
  }
}


resource "aws_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"

  tags = {
    "karpenter.sh/discovery" = "${var.kube.cluster_name}"
  }
}
