#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# -------------------------------
# Publish/Subscribe
# -------------------------------

# deliver a message to multiple consumers. This pattern is known as "publish/subscribe".

# A producer is a user application that sends messages.
# A queue is a buffer that stores messages.
# A consumer is a user application that receives messages

# The core idea in the messaging model in RabbitMQ is that the producer never sends any messages directly to a queue. 
# Actually, quite often the producer doesn't even know if a message will be delivered to any queue at all.

# Instead, the producer can only send messages to an exchange.
# On one side it receives messages from producers and the other side it pushes them to queues.

# The exchange must know exactly what to do with a message it receives. 
# Should it be appended to a particular queue? Should it be appended to many queues? Or should it get discarded.
# exchange types available: direct, topic, headers and fanout.
# list exchanges:  $ rabbitmqctl list_exchanges

#  save logs to a file
# $ ./receive_logs.rb > logs_from_rabbit.log

# see the logs on your screen
# $ ./receive_logs.rb


# to emit logs
# $ emit_log.rb

# list bindings
# $ rabbitmqctl list_bindings


# ///////////////////////////////////////////////////////////


# init a new connection to RabbitMQ by using Bunny
conn = Bunny.new
# conn = Bunny.new(:hostname => "rabbit.local")
conn.start


# create a channel
ch   = conn.create_channel
x    = ch.fanout("logs")

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg)
puts "[x] Sent #{msg}"

conn.close