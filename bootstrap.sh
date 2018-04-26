#!/usr/bin/env bash

#-----------------------------------------
# Resize partition if needed to full size
#-----------------------------------------
sudo resize2fs /dev/sda1

#--------------------
# install packages 
#--------------------
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y java-common openjdk-8-jdk openjdk-8-jre maven mesa-opencl-icd libtool autoconf automake build-essential opencl-headers gcc-multilib g++-multilib ocl-icd-opencl-dev ocl-icd-opencl-dev:i386

#--------------------
# clone aparapi
#--------------------
git clone https://github.com/Syncleus/aparapi.git
git clone https://github.com/Syncleus/aparapi-examples.git
git clone https://github.com/Syncleus/aparapi-jni.git
git clone --recursive https://github.com/Syncleus/aparapi-native.git
sudo chown -R vagrant:vagrant /home/vagrant/
