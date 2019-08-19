set -e -u

PG_SUBNET=${1%.*}
PG_REPLICATION_USER=${2}
PG_REPLICATION_PASSWORD=${3}

echo "Installing utils..."

yum install -y -q atool wget ping telnet

yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

yum install -y postgresql11-contrib postgresql11-server

/usr/pgsql-11/bin/postgresql-11-setup initdb
systemctl enable postgresql-11
systemctl start postgresql-11

sudo -u postgres -H sh -c "psql -c \"CREATE USER ${PG_REPLICATION_USER} REPLICATION PASSWORD '${PG_REPLICATION_PASSWORD}';\""

echo "host  all all ${PG_SUBNET}.0/24  md5" >> /var/lib/pgsql/11/data/pg_hba.conf
echo "host  replication ${PG_REPLICATION_USER} ${PG_SUBNET}.0/24  md5" >> /var/lib/pgsql/11/data/pg_hba.conf
cp /vagrant/master/postgresql.auto.conf /var/lib/pgsql/11/data/postgresql.auto.conf

chown postgres:postgres /var/lib/pgsql/11/data/postgresql.auto.conf

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart sshd

systemctl restart postgresql-11
