#!/bin/bash

sudo raspi-config nonint do_expand_rootfs

sudo apt update
sudo apt dist-upgrade -y
sudo apt install jq -y

sudo apt install python3-full -y
sudo apt install python3-pip -y


sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana


sudo apt install git -y
sudo apt install openjdk-17-jdk -y


sudo apt autoremove -y
sudo rpi-update


sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo usermod -a -G ouija grafana

python -m venv venv

source "venv/bin/activate"

pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip install -U
pip install lgpio
pip install gpiozero
pip install psutil
pip install -U questdb
pip install pyModbusTCP

deactivate


echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64' >> ~/.bashrc
source ~/.bashrc
echo $JAVA_HOME

echo "vm.max_map_count=1048576" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo cat /proc/sys/vm/max_map_count



