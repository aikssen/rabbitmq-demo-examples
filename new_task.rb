#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# -------------------------------
# Task Queue
# -------------------------------

# this is multitask - it can be opened many worker.rb consoles and each one will
# take a task from the queue. For example, if there are two worker.rb consoles opened
# and 6 tasks, the wroker[1] will take the tasks 1/3/5 and the worker[2] the tasks 2/4/6
# in a parallism fashion. 
# In this scenary once RabbitMQ delivers a message to the consumer it immediately removes it from memory.
# So, if a worker die we will lose the message it was just processing, also lose all the messages that were
# dispatched to this particular worker, but were not yet handled.

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