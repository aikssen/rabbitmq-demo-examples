#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# -------------------------------
# Fair dispatch
# -------------------------------

# The prefetch method with the value of 1. 
# This tells RabbitMQ not to give more than one message to a worker at a time. 
# Or, in other words, don't dispatch a new message to a worker until it has processed 
# and acknowledged the previous one. Instead, it will dispatch it to the next worker that is not still busy.





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

sleep 1.0
conn.close