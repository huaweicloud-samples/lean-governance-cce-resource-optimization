# 部署指南：CCE 资源优化

## 概述

本文档说明如何在华为云 CCE 上实施资源优化策略。

---

## 前置条件

1. 华为云账号（已开通 CCE、LTS 服务）
- CCE 集群（K8s 1.23+）
- kubectl 配置完成
- Helm 3.x

---

## 部署步骤

### 步骤 1: 创建 CCE 集群

```bash
# 使用 terraform 或控制台创建
terraform init
terraform apply
```

### 步骤 2: 配置 HPA（水平自动扩缩容）

```bash
# 部署 HPA
kubectl apply -f hpa.yaml

# 查看 HPA 状态
kubectl get hpa
```

### 步骤 3: 配置 VPA（垂直自动扩缩容）

```bash
# 部署 VPA（推荐模式）
kubectl apply -f vpa-recommendation.yaml

# 获取推荐值
kubectl get vpa my-app-vpa -o yaml
```

### 步骤 4: 配置弹性伸缩

```bash
# 创建节点池
kubectl apply -f nodepool.yaml

# 查看节点池状态
kubectl get nodepool
```

### 步骤 5: 配置 LTS 日志收集

```bash
# 安装 LTS 采集器
helm install lts-collector lts-chart/

# 配置日志采集规则
kubectl apply -f lts-config.yaml
```

---

## 优化模块说明

### 01. 闲置集群清理

```bash
# 检测闲置命名空间
./scripts/detect-idle-namespaces.sh

# 清理过期资源
./scripts/cleanup-stale-resources.sh
```

### 02. 应用清理

```bash
# 查找未使用的 Service
./scripts/find-unused-services.sh

# 查找过期镜像
./scripts/cleanup-old-images.sh
```

### 03. 集群升级

```bash
# 升级 CCE 集群版本
# 在控制台操作或使用 API
```

### 04. 弹性伸缩配置

```yaml
# HPA 示例
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### 05. 集群自动扩缩容

CCE 自动管理节点数量，无需额外配置。

### 06. CPU/内存规格优化

```yaml
# VPA 推荐模式
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Recommendation"
```

### 07. 鲲鹏实例换代

```yaml
# 鲲鹏节点池
apiVersion: v1
kind: NodePool
metadata:
  name: kunpeng-nodepool
spec:
  type: on-demand
  flavor: kunpeng920.2xlarge.4
  autoscaling:
    enable: true
    minNodes: 1
    maxNodes: 5
```

### 08. 指标用量优化

```yaml
# LTS 日志采集优化
apiVersion: lts.k8s.io/v1
kind: LogConfig
metadata:
  name: app-logs
spec:
  collect:
    container: true
    hostPath: /var/log
  sampling:
    rate: 0.5  # 采样 50%
```

### 09. Spark 作业优化

```yaml
# Spark 节点池
apiVersion: v1
kind: NodePool
metadata:
  name: spark-nodepool
spec:
  type: spot
  flavor: s6.large.2
  autoscaling:
    enable: true
    minNodes: 1
    maxNodes: 10
```

### 10. 其他策略

- 设置命名空间资源配额
- 配置定时扩缩容规则
- 使用 OBS 存储冷数据

---

## 验证部署

```bash
# 查看 HPA 状态
kubectl get hpa

# 查看 VPA 推荐
kubectl get vpa

# 查看节点池
kubectl get nodepool

# 查看 LTS 日志
lts query ...
```

---

## 清理资源

```bash
# 删除 HPA
kubectl delete hpa my-app-hpa

# 删除 VPA
kubectl delete vpa my-app-vpa

# 删除节点池
kubectl delete nodepool my-nodepool
```

---

## 费用监控

### 设置告警

1. 登录 CCE 控制台
2. 选择"费用中心"
3. 设置预算告警

### 查看费用

```bash
# CCE 控制台 -> 费用中心
# 查看 CCE 资源费用
```

---

## 常见问题

### Q: 如何选择实例类型？

A: 
- 无状态工作负载：使用 Spot 实例
- 有状态工作负载：使用按量付费
- ARM 兼容：使用鲲鹏实例

### Q: VPA 影响服务吗？

A: 
- `updateMode: "Recommendation"` 只推荐，不实际修改
- `updateMode: "Auto"` 会重启 Pod，建议在维护窗口执行

### Q: 如何降低日志费用？

A: 
- 设置日志采样率
- 定期清理过期日志
- 使用 LTS 存储生命周期策略
