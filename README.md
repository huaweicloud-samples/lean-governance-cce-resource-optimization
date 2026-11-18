# CCE Resource Optimization Guide: Scaling, Sizing, and Right-sizing

![License](https://img.shields.io/badge/license-MIT--0-blue.svg)

[中文版](./README.cn.md)
![Huawei Cloud](https://img.shields.io/badge/Huawei%20Cloud-Best%20Practice-ff4d00.svg)

> Huawei Cloud Best Practice (Same-Shaped Architecture, Not Code Translation)

---

## Introduction

Kubernetes resource optimization best practices on Huawei Cloud CCE. Improve resource utilization and reduce spend for cloud-native workloads through node optimization, resource tuning, elastic scaling, and intelligent monitoring.

---

## Table of Contents

- [Architecture](#architecture)
- [Key Features](#key-features)
- [Cloud Services](#cloud-services)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Step-by-Step Deployment](#step-by-step-deployment)
- [Usage](#usage)
- [Cleanup](#cleanup)
- [Detailed Explanation](#detailed-explanation)
- [Dependencies](#dependencies)
- [FAQ](#faq)
- [License](#license)
- [Contact](#contact)

---

## Architecture

```
CCE Resource Optimization Architecture
│
├─ Cluster Layer
│   ├─ CCE Cluster
│   ├─ Node Pool (On-demand/Spot)
│   └─ Kunpeng Nodes (ARM)
│
├─ Elastic Scaling Layer
│   ├─ HPA (Horizontal)
│   ├─ VPA (Vertical)
│   └─ Node Auto-scaling
│
├─ Monitoring Layer
│   └─ LTS Log Collection
│
└─ Optimization Strategies
    ├─ Idle Cleanup
    ├─ Scheduled Scaling
    └─ Usage Analysis
```

---

## Key Features

- **Node Optimization**: Spot instances at lower unit price
- **Resource Tuning**: VPA intelligent resource recommendations
- **Elastic Scaling**: HPA + automatic node scaling
- **ARM Migration**: Kunpeng instances with better price-performance
- **Smart Monitoring**: LTS unified log analysis

---

## Cloud Services

| Reference Service | Huawei Cloud | Status |
|-------------|--------------|--------|
| EKS | CCE (Cloud Container Engine) | 🟢 |
| Karpenter | CCE Elastic Scaling | 🟢 |
| CloudWatch | LTS (Log Tank Service) | 🟢 |
| VPA/HPA | CCE VPA/HPA | 🟢 |
| Graviton | Kunpeng Instances | 🟢 |

---

## Prerequisites

- Huawei Cloud account (CCE, LTS services enabled)
- kubectl configured
- Helm 3.x

---

## Quick Start

```bash
# Clone repository
git clone https://github.com/huaweicloud-samples/lean-governance-cce-resource-optimization.git
cd lean-governance-cce-resource-optimization

# Deploy HPA
kubectl apply -f hpa.yaml

# Deploy VPA
kubectl apply -f vpa.yaml
```

---

## Step-by-Step Deployment

### 1. Configure Credentials

```bash
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"
```

### 2. Create CCE Cluster

```bash
# Use terraform or console
terraform init
terraform apply
```

### 3. Deploy Optimization Components

```bash
# HPA
kubectl apply -f 06-cpu-memory-right-sizing/hpa-efficient-scaling.yaml

# VPA
kubectl apply -f 06-cpu-memory-right-sizing/vpa-recommendation.yaml
```

---

## Usage

### Check HPA Status

```bash
kubectl get hpa
```

### Get VPA Recommendations

```bash
kubectl get vpa my-app-vpa -o yaml
```

### Usage Analysis

```bash
# View LTS logs
lts query ...
```

---

## Cleanup

```bash
kubectl delete hpa my-app-hpa
kubectl delete vpa my-app-vpa
```

---

## Detailed Explanation

See [Architecture](./docs/architecture.md) and [Deployment Guide](./docs/deployment-guide.md)

---

## Dependencies

- [huaweicloud terraform-provider](https://registry.terraform.io/providers/huaweicloud/huaweicloud)
- Huawei Cloud CCE, LTS services

---

## FAQ

### Q: How to choose instance types?

A: Use Spot for stateless, on-demand for stateful, Kunpeng for ARM-compatible.

### Q: Does VPA affect services?

A: Recommendation mode only shows suggestions, doesn't modify. Auto mode restarts Pods.

### Q: How to reduce log spend?

A: Set sampling rate, configure log lifecycle policies.

---

## License

MIT License

---

## Contact

For issues, please submit an Issue in the repository.
