#! /bin/bash

until [ -f /vagrant/configs/join.sh ]
do
    sleep 1
done

sudo /bin/bash /vagrant/configs/join.sh -v

# sudo -i -u vagrant bash << EOF
# mkdir -p /home/vagrant/.kube
# sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
# sudo chown 1000:1000 /home/vagrant/.kube/config
# EOF
