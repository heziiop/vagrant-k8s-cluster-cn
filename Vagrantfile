Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update -y
    echo "10.0.0.80  master" >> /etc/hosts
    echo "10.0.0.81  worker1" >> /etc/hosts
    echo "10.0.0.82  worker2" >> /etc/hosts
  SHELL
    
  config.vm.define "master" do |master|
    master.vm.box = "generic/ubuntu1804"
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "10.0.0.80"
    master.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 4096
      libvirt.cpus = 2
    end
    master.vm.provision "shell", path: "scripts/common.sh"
    master.vm.provision "shell", path: "scripts/master.sh"
  end

  (1..2).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "generic/ubuntu1804"
      worker.vm.hostname = "worker#{i}"
      worker.vm.network "private_network", ip: "10.0.0.8#{i}"
      worker.vm.provider "libvirt" do |libvirt|
        libvirt.memory = 2048
        libvirt.cpus = 1
      end
      worker.vm.provision "shell", path: "scripts/common.sh"
      worker.vm.provision "shell", path: "scripts/worker.sh"
    end
  end
end