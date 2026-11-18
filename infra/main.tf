# =============================================
# 华为云实践：CCE 资源优化集群
# 基于容器资源优化参考实践适配
# IaC: Terraform + huaweicloud Provider
# =============================================

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.60"
    }
  }
}

# =====================
# 1. VPC Network
# =====================
resource "huaweicloud_vpc" "main" {
  name = var.cluster_name
  cidr = "10.0.0.0/16"
}

resource "huaweicloud_vpc_subnet" "private" {
  name          = "${var.cluster_name}-private"
  vpc_id        = huaweicloud_vpc.main.id
  cidr          = "10.0.1.0/24"
  gateway_ip    = "10.0.1.1"
  primary_dns   = "100.125.1.250"
  secondary_dns = "100.125.129.250"
}

# =====================
# 2. Security Group
# =====================
resource "huaweicloud_networking_secgroup" "main" {
  name        = "${var.cluster_name}-sg"
  description = "Resource Optimization CCE Security Group"
}

resource "huaweicloud_networking_secgroup_rule" "allow_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = huaweicloud_networking_secgroup.main.id
  ports             = "80"
  protocol          = "tcp"
}

resource "huaweicloud_networking_secgroup_rule" "allow_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = huaweicloud_networking_secgroup.main.id
  ports             = "443"
  protocol          = "tcp"
}

# =====================
# 3. LTS (日志服务)
# =====================
resource "huaweicloud_lts_group" "main" {
  group_name  = "${var.cluster_name}-lts"
  ttl_in_days = 7
}

resource "huaweicloud_lts_stream" "app" {
  group_id    = huaweicloud_lts_group.main.id
  stream_name = "${var.cluster_name}-app"
}

# =====================
# Outputs
# =====================
output "vpc_id" {
  description = "VPC ID"
  value       = huaweicloud_vpc.main.id
}

output "cluster_name" {
  description = "CCE Cluster Name"
  value       = var.cluster_name
}

output "lts_group_id" {
  description = "LTS Group ID"
  value       = huaweicloud_lts_group.main.id
}
