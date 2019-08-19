
# N Replica PostgreSQL Vagrant Installation
* Based on: https://github.com/philmcc/postgres_clusters.git
* Needs virtualbox and vagrant installed.

#### Run:

It uses Default CentOS 7 as a base image.

```shell
git clone https://github.com/edib/postgres_n_replicas_on_vagrant.git

cd postgres_n_replicas_on_vagrant/n-node-master-replica_11
# edit Vagrantfile if necessary.
vagrant up
# it can takes several minutes
```
