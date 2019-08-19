set -e -u

PG_MASTER_IP=${1}
VM_NAME=${2}
PG_REPLICATION_USER=${3}
PG_REPLICATION_PASSWORD=${4}

echo "Installing repo..."
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

echo "Installing postgres..."
yum install -y postgresql11-contrib postgresql11-server

echo "Basebackuping..."
export  PGPASSWORD=${PG_REPLICATION_PASSWORD}
pg_basebackup -h $PG_MASTER_IP -D /var/lib/pgsql/11/data -U ${PG_REPLICATION_USER} -v -P --wal-method=stream -R -C --slot $VM_NAME

sed -i "s/primary_conninfo = '/primary_conninfo = 'application_name=${VM_NAME} /g" /var/lib/pgsql/11/data/recovery.conf

chown postgres:postgres -R /var/lib/pgsql/11/data

sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart sshd

systemctl enable postgresql-11
systemctl start postgresql-11
