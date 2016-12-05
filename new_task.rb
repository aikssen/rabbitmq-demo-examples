#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# -------------------------------
# acknowledgments
# -------------------------------

# In order to make sure a message is never lost, RabbitMQ supports message acknowledgments. 
# An ack(nowledgement) is sent back from the consumer to tell RabbitMQ that a particular message has been received, 
# processed and that RabbitMQ is free to delete it.

# If a consumer dies (its channel is closed, connection is closed, or TCP connection is lost) 
# without sending an ack, RabbitMQ will understand that a message wasn't processed fully and will re-queue it. 
# If there are other consumers online at the same time, it will then quickly redeliver it to another consumer

# Message acknowledgments are turned off by default.





# init a new connection to RabbitMQ by using Bunny
conn = Bunny.new
# conn = Bunny.new(:hostname => "rabbit.local")
conn.start


# create a channel
ch   = conn.create_channel

# create a queue (mailbox)
q    = ch.queue("hello")

# capture the message
# receive the message from the command line, example:  $ ./new_task.rb some...
# each dot means an amount of time to wait.
message = ARGV.empty? ? "Default message" : ARGV.join(" ")
q.publish(message, :persistent => true)

# print messaged sent (only for testing)
puts "[x] Sent '#{message.strip}'"

conn.close