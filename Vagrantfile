VAGRANTFILE_API_VERSION = "2"

VM_IP = "10.10.10.10"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/zesty64"
  config.vm.provision :shell, path: "bootstrap.sh", args: [VM_IP]
  config.vm.network "private_network", ip: VM_IP
  config.vm.synced_folder "./shared", "/mnt/shared"

  config.vm.provider "virtualbox" do |vb|
	    vb.memory = 2048
		  vb.cpus = 2
  end
 end
