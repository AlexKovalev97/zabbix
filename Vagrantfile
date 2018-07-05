Vagrant.configure("2") do |config|
	config.vm.box = "./sbeliakou-centos-7.3-x86_64-minimal.box"

	config.vm.define "zab_serv" do |zs|
		zs.vm.provider "virtualbox" do |vb|
			vb.name = "zabbix_server"
			vb.memory ="3072"
		end
		zs.vm.provision "shell", path: "inserver.sh"
		zs.vm.network "private_network", ip:"10.0.0.10"
	end

	config.vm.define "zab_cli" do |zc|
		zc.vm.provider "virtualbox" do |vb|
			vb.name = "zabbix_client"
			vb.memory ="2048"
		end
		zc.vm.provision "shell", path: "inclient.sh"
		zc.vm.network "private_network", ip:"10.0.0.50"
	end

end
