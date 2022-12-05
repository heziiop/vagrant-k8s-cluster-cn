# Vagrant Kubernetes Cluster (CN)

本项目仅在[Vagrant Kubernetes Cluster (CN)](https://gitee.com/bambrow/vagrant-k8s-cluster-cn)的基础上做了一些小修改

本项目演示如何使用Vagrant搭建Kubernetes集群，并针对国内的网络环境做了优化。请在使用前先安装qemu、libvirt与[Vagrant](https://www.vagrantup.com/docs/installation)。

## 版本说明

本项目搭建的集群版本：
```
kubernetes v1.25.4
```

## 使用方法

### 搭建集群
```bash
git clone https://github.com/heziiop/vagrant-k8s-cluster-cn.git
cd vagrant-k8s-cluster-cn
vagrant up
```

### 连接节点
```bash
vagrant ssh master
vagrant ssh worker1
vagrant ssh worker2
```

### 暂停与启动集群
```bash
vagrant halt
vagrant up
```

### 销毁集群
```bash
vagrant destroy -f
```
