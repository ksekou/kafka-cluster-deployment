
# Part I: Installation


## Step 1: Install Java

```bash
sudo apt-get update && sudo apt-get install default-jre
```

## Step 2: Download Kafka

```bash
cd ~/
wget http://apache.claz.org/kafka/2.0.0/kafka_2.11-2.0.0.tgz
```

## Step 3: Untar and move binaries to /usr/local/kafka

```bash
tar xvf kafka_2.11-2.0.0.tgz && sudo mv kafka_2.11-2.0.0 /usr/local/kafka
echo 'export KAFKA_PATH="/usr/local/kafka"' >> ~/.bashrc
echo 'export PATH="$KAFKA_PATH/bin/:$PATH"' >> ~/.bashrc
```

# Part 2: Setup zookeeper

## Step 1: Create the data directories for Zookeeper on all menbers of the cluster

```bash
sudo mkdir -p /var/zookeeper/data
sudo chown ${USER}:${USER} -R /var/zookeeper
```

    On each node of the cluster set a unique zookeeper ID
    this ID must match with the **broker.id=1** in **server.properties**
    echo "1" > /var/zookeeper/data/myid

    See config file for details
    ls -lrt ./server{1,3}/zookeeper.properties


# Part 3: Setup Kafka

# Step 1: Create the data directories for Kafka on all menbers of the cluster

```bash
sudo mkdir -p /var/kafka/kafka-logs
sudo chown ${USER}:${USER} -R /var/kafka
```

    See config file for details
    ls -lrt ./server{1,3}/server.properties

## Part 4: Creating Systemd Unit Files and Starting the Kafka Server

    In this section, we will create systemd unit files for the Kafka service.
    This will help us perform common service actions such as starting, stopping,
    and restarting Kafka in a manner consistent with other Linux services.

    Zookeeper is a service that Kafka uses to manage its cluster state and configurations.
    It is commonly used in many distributed systems as an integral component.


## Step 1: Setup zookeeper service /etc/systemd/system/zookeeper.service

```
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/usr/local/kafka/bin/zookeeper-server-start.sh /usr/local/kafka/config/zookeeper.properties
ExecStop=/usr/local/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```


## Step 2: Setup kafka service /etc/systemd/system/zookeeper.service

```
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties > /usr/local/kafka/kafka.log 2>&1'
ExecStop=/usr/local/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
