#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# init a new connection to RabbitMQ by using Bunny
conn = Bunny.new
conn.start

# open a channel
ch   = conn.create_channel
# open/create a queue (mailbox)
q    = ch.queue("task_queue", :durable => true)

# Using message acknowledgments and prefetch you can set up a work queue. 
# The durability options let the tasks survive even if RabbitMQ is restarted.
ch.prefetch(1);



puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"


begin
  q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
    puts " [x] Received '#{body}'"
    # imitate some work
    sleep 1.0
    puts " [x] Done"
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  conn.close
end