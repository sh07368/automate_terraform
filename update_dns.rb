#!/usr/bin/env ruby

#This script updates dns in DNSimple based on input hostname/IP

require 'dnsimple'
require 'json'

input = ARGV
action = input[0]
hostname = input[1]
ip = input[2]

creds_file = File.open(".dns_creds", "rb")
api_creds = JSON.parse(creds_file.read)
creds_file.close

client = Dnsimple::Client.new(access_token: api_creds['api_key'])

response = client.zones.records(
    api_creds['account_id'],
    api_creds['domain'],
    filter: {
      name: hostname
    })

if response.total_entries == 0 and action == "create" then

  puts "creating entry"
  client.zones.create_record(
    api_creds['account_id'],
    api_creds['domain'],
    name: hostname,
    ttl: "600",
    type: "A",
    content: ip
  )

elsif response.total_entries == 0 and action == "delete" then

  puts "no entry found to delete"

elsif response.total_entries == 1 and action == "create" then

  puts "updating entry"
  client.zones.update_record(
    api_creds['account_id'],
    api_creds['domain'],
    response.data[0].id,
    ttl: "600",
    type: "A",
    content: ip
  )

elsif response.total_entries == 1 and action == "delete" then
  puts "deleting entry"
  client.zones.delete_record(
    api_creds['account_id'],
    api_creds['domain'],
    response.data[0].id
  )

else
  puts "we should never get more than 1 result back"

end
