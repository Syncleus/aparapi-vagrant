#!/usr/bin/env bash

export HOST_IP=$1

#--------------------
# install packages 
#--------------------
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install java-common openjdk-8-jdk openjdk-8-jre maven mesa-opencl-icd libtool autoconf automake build-essential opencl-headers gcc-multilib g++-multilib -y

#--------------------
# Install AMD APP SDK
#--------------------

AMDAPPSDKROOT=/opt/AMDAPPSDK-3.0
URL="http://developer.amd.com/amd-accelerated-parallel-processing-app-sdk/"
URLDOWN="http://developer.amd.com/amd-license-agreement-appsdk/"

NONCE1_STRING='name="amd_developer_central_downloads_page_nonce"'
FILE_STRING='name="f"'
POSTID_STRING='name="post_id"'
NONCE2_STRING='name="amd_developer_central_nonce"'

echo "AMD APP SDK v3.0"
FORM=`wget -qO - $URL | sed -n '/download-2/,/64-bit/p'`

# Get nonce from form
NONCE1=`echo $FORM | awk -F ${NONCE1_STRING} '{print $2}'`
NONCE1=`echo $NONCE1 | awk -F'"' '{print $2}'`
echo $NONCE1

# get the postid
POSTID=`echo $FORM | awk -F ${POSTID_STRING} '{print $2}'`
POSTID=`echo $POSTID | awk -F'"' '{print $2}'`
echo $POSTID

# get file name
FILE=`echo $FORM | awk -F ${FILE_STRING} '{print $2}'`
FILE=`echo $FILE | awk -F'"' '{print $2}'`
echo $FILE

FORM=`wget -qO - $URLDOWN --post-data "amd_developer_central_downloads_page_nonce=${NONCE1}&f=${FILE}&post_id=${POSTID}"`

NONCE2=`echo $FORM | awk -F ${NONCE2_STRING} '{print $2}'`
NONCE2=`echo $NONCE2 | awk -F'"' '{print $2}'`
echo $NONCE2

wget --content-disposition --trust-server-names $URLDOWN --post-data "amd_developer_central_nonce=${NONCE2}&f=${FILE}" -O AMD-SDK.tar.bz2;

sudo mkdir -p ${AMDAPPSDKROOT} 
sudo chown ${USER} ${AMDAPPSDKROOT}
tar -xjf AMD-SDK.tar.bz2
export OPENCL_VENDOR_PATH=${AMDAPPSDKROOT}/etc/OpenCL/vendors
mkdir -p ${OPENCL_VENDOR_PATH}
sh AMD-APP-SDK*.sh --tar -xf -C ${AMDAPPSDKROOT}
echo libamdocl64.so > ${OPENCL_VENDOR_PATH}/amdocl64.icd
export LD_LIBRARY_PATH=${AMDAPPSDKROOT}/lib/x86_64/sdk:${LD_LIBRARY_PATH}
export LIBRARY_PATH=${AMDAPPSDKROOT}/lib/x86_64/sdk:${LIBRARY_PATH}
export CMAKE_LIBRARY_PATH=${AMDAPPSDKROOT}/lib/x86_64/sdk
cp ${AMDAPPSDKROOT}/lib/x86_64/libamdocl12cl64.so ${AMDAPPSDKROOT}/lib/x86_64/sdk/libamdocl12cl64.so
chmod +x ${AMDAPPSDKROOT}/bin/x86_64/clinfo
${AMDAPPSDKROOT}/bin/x86_64/clinfo

sudo ln -s /opt/AMDAPPSDK-3.0/lib/x86_64/sdk/libOpenCL.so.1 /usr/lib/x86_64-linux-gnu/libOpenCL.so
sudo ln -s /opt/AMDAPPSDK-3.0/lib/x86/libOpenCL.so.1 /usr/lib/libOpenCL.so

#sudo mkdir -p /usr/lib64/OpenCL/vendors/amd/
#sudo cp rr /opt/AMDAPPSDK-3.0/lib/x86_64/* /usr/lib64/OpenCL/vendors/amd/
#sudo sh -c 'echo "/usr/lib64/OpenCL/vendors/amd" > /etc/ld.so.conf.d/opencl-vendor-amd.conf'
#sudo mkdir -p /usr/lib/OpenCL/vendors/amd/
#sudo cp -r /opt/AMDAPPSDK-3.0/lib/x86/* /usr/lib/OpenCL/vendors/amd/
#sudo sh -c 'echo "/usr/lib/OpenCL/vendors/amd" > /etc/ld.so.conf.d/opencl-vendor-amd.conf'
#sudo ldconfig

#--------------------
# clone aparapi
#--------------------
git clone https://github.com/Syncleus/aparapi.git
git clone https://github.com/Syncleus/aparapi-examples.git
git clone https://github.com/Syncleus/aparapi-jni.git
git clone https://github.com/Syncleus/aparapi-native.git
sudo chown -R ubuntu:ubuntu aparapi*
