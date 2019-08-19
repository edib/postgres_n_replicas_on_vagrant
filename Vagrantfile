
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

PG_MASTER_IP = "192.168.4.10"
PG_REPLICA_RANGE = "192.168.4.1"
PG_NUMBER_OF_REPLICA = 3
PG_REPLICATION_USER="replicator"
PG_REPLICATION_PASSWORD = "some_password"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"

  config.vm.define "master", primary: true do |server|
    server.vm.hostname = "master"
    server.vm.network "private_network", ip: PG_MASTER_IP

    server.vm.provision "shell", path: "scripts/master.sh", args: "#{PG_MASTER_IP} #{PG_REPLICATION_USER} #{PG_REPLICATION_PASSWORD}"
  end

  (1..PG_NUMBER_OF_REPLICA).each do |i|
        vm_name = "replica#{i}"
        config.vm.define vm_name do |server|
          server.vm.hostname = vm_name
          server.vm.network "private_network", ip: "#{PG_REPLICA_RANGE}#{i}"
          server.vm.provision "shell", path: "scripts/slave.sh", args: "#{PG_MASTER_IP} #{vm_name} #{PG_REPLICATION_USER} #{PG_REPLICATION_PASSWORD}"
        end
      end
=begin
  config.vm.define "slave" do |server|
    server.vm.hostname = "slave.pg"
    server.vm.network "private_network", ip: "192.168.4.3"

    server.vm.provision "shell", path: "scripts/slave.sh", args: PG_DATABASE_NAME
  end
*/
=end
end
