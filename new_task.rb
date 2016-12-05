#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# -------------------------------
# Message durability
# -------------------------------

# When RabbitMQ quits or crashes it will forget the queues and messages unless you tell it not to. 
# Two things are required to make sure that messages aren't lost: 
# we need to mark both the queue and messages as durable.





# init a new connection to RabbitMQ by using Bunny
conn = Bunny.new
# conn = Bunny.new(:hostname => "rabbit.local")
conn.start


# create a channel
ch   = conn.create_channel

# create a queue (mailbox)
q    = ch.queue("task_queue", :durable => true)

# capture the message
# receive the message from the command line, example:  $ ./new_task.rb some...
# each dot means an amount of time to wait.
message = ARGV.empty? ? "Default message" : ARGV.join(" ")
q.publish(message, :persistent => true)

# print messaged sent (only for testing)
puts "[x] Sent '#{message.strip}'"

conn.close