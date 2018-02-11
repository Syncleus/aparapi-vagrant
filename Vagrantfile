VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/artful64"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.synced_folder "./shared", "/mnt/shared"

  config.vm.provider "virtualbox" do |vb|
	    vb.memory = 2048
		  vb.cpus = 2
  end
 end
