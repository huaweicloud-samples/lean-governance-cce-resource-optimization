# CCE 资源优化指南：缩容与降配

![License](https://img.shields.io/badge/license-MIT--0-blue.svg)

[English](./README.md)
![Huawei Cloud](https://img.shields.io/badge/华为云-最佳实践-ff4d00.svg)

> 华为云最佳实践（同构架构，非代码平移）

---

## 简介

基于华为云 CCE 实现的 Kubernetes 资源优化最佳实践。通过多种技术手段提升云原生工作负载的资源利用率、降低运行费用，包括节点优化、资源调优、弹性伸缩和智能监控。

---

## 目录

- [架构图](#架构图)
- [方案亮点](#方案亮点)
- [涉及云服务](#涉及云服务)
- [前置条件](#前置条件)
- [快速开始](#快速开始)
- [分步部署](#分步部署)
- [使用方法](#使用方法)
- [清理资源](#清理资源)
- [详细说明](#详细说明)
- [参考实现](#参考实现)
- [FAQ](#faq)
- [许可证](#许可证)
- [联系方式](#联系方式)

---

## 架构图

```
CCE 资源优化架构
│
├─ 集群层
│   ├─ CCE 集群
│   ├─ 节点池 (按量/Spot)
│   └─ 鲲鹏节点 (ARM)
│
├─ 弹性伸缩层
│   ├─ HPA (水平)
│   ├─ VPA (垂直)
│   └─ 弹性伸缩 (节点)
│
├─ 监控层
│   └─ LTS 日志收集
│
└─ 优化策略
    ├─ 闲置清理
    ├─ 定时扩缩
    └─ 用量分析
```

---

## 方案亮点

- **节点优化**: 竞价实例价格更低
- **资源调优**: VPA 智能推荐资源规格
- **弹性伸缩**: HPA + 节点自动扩缩
- **ARM 换代**: 鲲鹏实例性价比更高
- **智能监控**: LTS 统一日志分析

---

## 涉及云服务

| 参照服务 | 华为云 | 状态 |
|---------|--------|------|
| EKS | CCE (云容器引擎) | 🟢 |
| Karpenter | CCE 弹性伸缩 | 🟢 |
| CloudWatch | LTS (日志服务) | 🟢 |
| VPA/HPA | CCE VPA/HPA | 🟢 |
| Graviton | 鲲鹏实例 | 🟢 |

---

## 前置条件

- 华为云账号（已开通 CCE、LTS 服务）
- kubectl 配置完成
- Helm 3.x

---

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/huaweicloud-samples/lean-governance-cce-resource-optimization.git
cd lean-governance-cce-resource-optimization

# 部署 HPA
kubectl apply -f hpa.yaml

# 部署 VPA
kubectl apply -f vpa.yaml
```

---

## 分步部署

### 1. 配置凭证

```bash
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"
```

### 2. 创建 CCE 集群

```bash
# 使用 terraform 或控制台
terraform init
terraform apply
```

### 3. 部署优化组件

```bash
# HPA
kubectl apply -f 06-cpu-memory-right-sizing/hpa-efficient-scaling.yaml

# VPA
kubectl apply -f 06-cpu-memory-right-sizing/vpa-recommendation.yaml
```

---

## 使用方法

### 查看 HPA 状态

```bash
kubectl get hpa
```

### 获取 VPA 推荐

```bash
kubectl get vpa my-app-vpa -o yaml
```

### 用量分析

```bash
# 查看 LTS 日志
lts query ...
```

---

## 清理资源

```bash
kubectl delete hpa my-app-hpa
kubectl delete vpa my-app-vpa
```

---

## 详细说明

详见 [架构说明](./docs/architecture.md) 和 [部署指南](./docs/deployment-guide.md)

---

## 参考实现

- [huaweicloud terraform-provider](https://registry.terraform.io/providers/huaweicloud/huaweicloud)
- 华为云 CCE, LTS 服务

---

## FAQ

### Q: 如何选择实例类型？

A: 无状态用 Spot，有状态用按量，ARM 兼容用鲲鹏。

### Q: VPA 会影响服务吗？

A: 推荐模式只显示建议，不实际修改。自动模式会重启 Pod。

### Q: 如何降低日志费用？

A: 设置采样率，配置日志生命周期策略。

---

## 许可证

MIT License

---

## 联系方式

如有问题，请在仓库中提交 Issue。
