#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# init a new connection to RabbitMQ by using Bunny
conn = Bunny.new
conn.start

# open a channel
ch   = conn.create_channel
# open/create a queue (mailbox)
q    = ch.queue("hello")



puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"


q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
  puts " [x] Received '#{body}'"
  # imitate some work
  sleep 1.0
  puts " [x] Done"
  ch.ack(delivery_info.delivery_tag)
end