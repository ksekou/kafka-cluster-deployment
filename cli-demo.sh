
export ZOOKEEPER_HOSTS=kafka-stage01.intra.onna.internal:2181,kafka-stage02.intra.onna.internal:2181,kafka-stage03.intra.onna.internal:2181
export KAFKA_HOSTS=kafka-stage01.intra.onna.internal:9092,kafka-stage02.intra.onna.internal:9092,kafka-stage03.intra.onna.internal:9092

# Create a new topic
kafka-topics.sh --create --zookeeper ${ZOOKEEPER_HOSTS} --topic TEST-TOPIC --replication-factor 3 --partitions 3


# increase number of partitions
kafka-topics.sh --alter --zookeeper ${ZOOKEEPER_HOSTS} --topic es-5-topic --partitions 10

# Topic Deletion
kafka-topics.sh --zookeeper ${ZOOKEEPER_HOSTS} --delete --topic TEST-TOPIC


# get topics info
kafka-topics.sh --list --zookeeper ${ZOOKEEPER_HOSTS}
kafka-topics.sh --describe --topic TEST-TOPIC --zookeeper ${ZOOKEEPER_HOSTS}

# Produce to kafka
kafka-console-producer.sh --broker-list ${KAFKA_HOSTS} --topic TEST-TOPIC

# Consume from kafka
kafka-console-consumer.sh --bootstrap-server ${KAFKA_HOSTS} --topic TEST-TOPIC --from-beginning


kafka-producer-perf-test.sh --topic TEST-TOPIC \
    --num-records 100000 \
    --record-size 100 \
    --throughput 1000 \
    --producer-props \
    acks=1 bootstrap.servers=${KAFKA_HOSTS}