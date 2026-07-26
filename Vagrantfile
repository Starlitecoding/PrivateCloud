# Определение операционной системы
is_mac = RbConfig::CONFIG['host_os'] =~ /darwin/

Vagrant.configure("2") do |config|
  if is_mac
    config.vm.box = "generic/ubuntu2204"
  else
    config.vm.box = "ubuntu/jammy64"
  end

  # --- GATEWAY ---
  config.vm.define "gateway" do |gw|
    gw.vm.hostname = "gateway"
    gw.vm.network "private_network", ip: "10.10.10.1"
    
    gw.vm.provider "qemu" do |qe|
      qe.memory = "1024"
      qe.cpus = 1
      qe.advanced_network = true
      # Задаем порт напрямую в QEMU аргументы
      qe.extra_qemu_args = ["-netdev", "user,id=net0,hostfwd=tcp::2201-:22"]
    end

    gw.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end

  # --- COMPUTE ---
  config.vm.define "compute" do |c|
    c.vm.hostname = "compute"
    c.vm.network "private_network", ip: "10.10.10.11"
    
    c.vm.provider "qemu" do |qe|
      qe.memory = "1024"
      qe.cpus = 1
      qe.advanced_network = true
      qe.extra_qemu_args = ["-netdev", "user,id=net0,hostfwd=tcp::2202-:22"]
    end

    c.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end

  # --- STORAGE ---
  config.vm.define "storage" do |s|
    s.vm.hostname = "storage"
    s.vm.network "private_network", ip: "10.10.10.12"
    
    s.vm.provider "qemu" do |qe|
      qe.memory = "1024"
      qe.cpus = 1
      qe.advanced_network = true
      qe.extra_qemu_args = ["-netdev", "user,id=net0,hostfwd=tcp::2203-:22"]
    end

    s.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end
end
