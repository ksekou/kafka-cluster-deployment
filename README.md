
## Part I: Installation
========================

# Step 1: Install Java
----------------------
```bash
sudo apt-get update && sudo apt-get install default-jre
```

# ----------------------------------------------------------------------------------
# => Step 2: Download Kafka
# Download kafka from http://kafka.apache.org/downloads.html::
# ----------------------------------------------------------------------------------

cd ~/
wget http://apache.claz.org/kafka/2.0.0/kafka_2.11-2.0.0.tgz

# ----------------------------------------------------------------------------------
# => Step 3: Untar and move binaries to /usr/local/kafka
# ----------------------------------------------------------------------------------

tar xvf kafka_2.11-2.0.0.tgz && sudo mv kafka_2.11-2.0.0 /usr/local/kafka

echo 'export KAFKA_PATH="/usr/local/kafka"' >> ~/.bashrc
echo 'export PATH="$KAFKA_PATH/bin/:$PATH"' >> ~/.bashrc

# ----------------------------------------------------------------------------------
# Part 2: Setup zookeeper
# ----------------------------------------------------------------------------------
# Step 1: Create the data directories for Zookeeper
# on all menbers of the cluster
# ----------------------------------------------------------------------------------

sudo mkdir -p /var/zookeeper/data
sudo chown ${USER}:${USER} -R /var/zookeeper

# On each node of the cluster set a unique zookeeper ID
echo "1" > /var/zookeeper/data/myid

# See config file for details
ls -lrt ./config/cluster/srv{1,2}/zookeeper.properties

# ----------------------------------------------------------------------------------
# Part 3: Setup Kafka
# ----------------------------------------------------------------------------------
# Step 1: Create the data directories for Kafka
# on all menbers of the cluster
# ----------------------------------------------------------------------------------

sudo mkdir -p /var/kafka/kafka-logs
sudo chown ${USER}:${USER} -R /var/kafka

# See config file for details
ls -lrt ./config/cluster/srv{1,2}/server.properties

# ----------------------------------------------------------------------------------
# Part 4: Bootstrap the cluster
# ----------------------------------------------------------------------------------
# Step 1: Start zookeeper on each menber of the node
# ----------------------------------------------------------------------------------
zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties
zookeeper-server-start.sh -daemon /usr/local/kafka/config/zookeeper.properties

# ----------------------------------------------------------------------------------
# Step 1: Start kafka broker on each menber of the node
# ----------------------------------------------------------------------------------
kafka-server-start.sh /usr/local/kafka/config/server.properties
kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties
