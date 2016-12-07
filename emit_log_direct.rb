#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# ------------------------
# Routing
# ------------------------

# To simplify things we will assume that 'severity' can be one of 'info', 'warning', 'error'.

# usage 
# $ ruby -rubygems receive_logs_direct.rb warning error > logs_from_rabbit.log  
# $ ruby -rubygems receive_logs_direct.rb info warning error
# $ ruby -rubygems emit_log_direct.rb error "Run. Run. Or it will explode."

conn = Bunny.new
conn.start

ch       = conn.create_channel
x        = ch.direct("direct_logs")
severity = ARGV.shift || "info"
msg      = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg, :routing_key => severity)
puts " [x] Sent '#{msg}'"

conn.close