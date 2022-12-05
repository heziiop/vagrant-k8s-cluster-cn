#! /bin/bash

KUBERNETES_VERSION="1.25.4-00"

# disable swap 
sudo swapoff -a
sudo sed -ri 's/.*swap.*/#&/' /etc/fstab 

echo "Swap diasbled..."

# disable firewall
sudo ufw disable

# install dependencies
sudo sed -i 's/^DNS=.*/DNS=223.5.5.5\ 223.6.6.6\ 114.114.114.114/g' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl wget software-properties-common
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce

# wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.6/cri-dockerd_0.2.6.3-0.ubuntu-bionic_amd64.deb
sudo dpkg -i /vagrant/cri-dockerd_0.2.6.3-0.ubuntu-bionic_amd64.deb

echo "Dependencies installed..."

# configure docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://okako4t8.mirror.aliyuncs.com",
                      "https://docker.mirrors.ustc.edu.cn"
  ],
  "exec-opts":["native.cgroupdriver=systemd"]
}
EOF

# start docker
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/cri-dockerd --container-runtime-endpoint fd:\/\/ --network-plugin=cni --cni-bin-dir=\/opt\/cni\/bin --cni-cache-dir=\/var\/lib\/cni\/cache --cni-conf-dir=\/etc\/cni\/net.d/g' /lib/systemd/system/cri-docker.service


sudo systemctl daemon-reload
sudo systemctl restart cri-docker.service
sudo systemctl enable cri-docker

echo "Docker installed and configured..."

# install kubelet, kubectl, kubeadm
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubenetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

sudo apt-get update -y
sudo apt-get install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION

sudo systemctl start kubelet  
sudo systemctl enable kubelet   

echo "Installation done..."
