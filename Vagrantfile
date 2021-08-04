# -*- mode: ruby -*-
# vi: set ft=ruby :
[
  'vagrant-vbguest',
  'vagrant-cachier',
  'puppet',
  'vagrant-puppet-install'
].each do |plugin|
  abort "Install the  '#{plugin}' plugin with 'vagrant plugin install #{plugin}'" unless Vagrant.has_plugin?("#{plugin}")
end

Vagrant.configure("2") do |config|

  config.vm.define "centos", primary: true do |centos|
    centos.vm.box = 'geerlingguy/centos7'
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = 'ubuntu/focal64'
  end

  config.puppet_install.puppet_version = '6.24.0'
  config.vm.hostname = 'puppet-fourstore' 
  config.vm.synced_folder "modules", "/tmp/puppet-modules", type: "rsync", rsync__exclude: ".git/"
  config.vm.synced_folder ".", "/tmp/puppet-modules/fourstore", type: "rsync", rsync__exclude: [".git/","spec/"]
  config.vm.provision "puppet" do |puppet|
     puppet.options = [
       '--verbose',
       '-t',
       "--modulepath", "/tmp/puppet-modules"
     ]
    puppet.environment_path = "examples"
    puppet.environment = "vagrant"
  end
end
