Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.define "gateway" do |gw|
    gw.vm.hostname = "gateway"
    gw.vm.network "private_network", ip: "10.10.10.1"
  end

  config.vm.define "compute" do |c|
    c.vm.hostname = "compute"
    c.vm.network "private_network", ip: "10.10.10.11"
  end

  config.vm.define "storage" do |s|
    s.vm.hostname = "storage"
    s.vm.network "private_network", ip: "10.10.10.12"
  end
end
