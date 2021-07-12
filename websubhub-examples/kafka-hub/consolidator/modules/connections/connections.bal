// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerinax/kafka;
import consolidatorService.config;

// Producer which persist the current consolidated in-memory state of the system
kafka:ProducerConfiguration statePersistConfig = {
    clientId: "consolidated-state-persist",
    acks: "1",
    retryCount: 3
};
public final kafka:Producer statePersistProducer = check new (config:KAFKA_BOOTSTRAP_NODE, statePersistConfig);

// Consumer which reads the consolidated subscriber details
kafka:ConsumerConfiguration consolidatedSubscriberConsumerConfig = {
    groupId: string `consolidated-subscribers-group-${config:CONSTRUCTED_CONSUMER_ID}`,
    offsetReset: "earliest",
    topics: [ config:CONSOLIDATED_SUBSCRIBERS_TOPIC ]
};
public final kafka:Consumer consolidatedSubscriberConsumer = check new (config:KAFKA_BOOTSTRAP_NODE, consolidatedSubscriberConsumerConfig);

// Configurations for consumer which reads the persisted subscription/unsubscription events
public final kafka:ConsumerConfiguration subscribersConsumerConfig = {
    groupId: string `state-update-group-${config:CONSTRUCTED_CONSUMER_ID}`,
    offsetReset: "earliest",
    topics: [ config:REGISTERED_TOPICS_TOPIC, config:SUBSCRIBERS_TOPIC ],
    autoCommit: false
};
