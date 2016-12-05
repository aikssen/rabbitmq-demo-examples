#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"


# init a new connection to RabbitMQ by using Bunny
conn = Bunny.new
# conn = Bunny.new(:hostname => "rabbit.local")
conn.start


# create a channel
ch   = conn.create_channel

# create a queue (mailbox)
q    = ch.queue("hello")

# capture the message
message = ARGV.empty? ? "Default message" : ARGV.join(" ")

# send/publish a message
ch.default_exchange.publish(message, :routing_key => q.name)

# print messaged sent (only for testing)
puts "[x] Sent '#{message.strip}'"

conn.close