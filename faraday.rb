# frozen_string_literal: true

require 'faraday'
require 'faraday/gzip'
require 'faraday/retry'
require 'pry-byebug'

# API Responses: https://designer.mocky.io/
# Faraday: https://github.com/lostisland/faraday-retry
RETRY_OPTIONS = {
  max: 1,
  interval: 1,
  max_interval: 8,
  interval_randomness: 2,
  backoff_factor: 2,
  retry_statuses: [429, 503]
}.freeze

HEADERS = {
  'Accept' => 'application/json',
  'Content-Type' => 'application/json',
  'User-Agent' => 'ruby'
}.freeze

BASE_URL = 'https://run.mocky.io/'

conn = Faraday.new(url: BASE_URL, ssl: {}) do |faraday|
  faraday.headers = HEADERS
  faraday.request :json
  faraday.response :json, parser_options: { symbolize_names: true }
  faraday.request :gzip
  faraday.request :instrumentation if Object.const_defined?(:ActiveSupport)
  faraday.adapter :net_http
  faraday.response :logger
  faraday.request :retry, RETRY_OPTIONS
end

begin
  (1..8).each do |times|
    puts "\n[\033[1;34m#{times}\033[0m] \033[1;31m#{"—" * (160 - (times.size + 7))}\033[0m"
    start_time = Time.now.utc
    response = case times
               when 3 then conn.get('v3/450f5901-fc23-4bee-b36a-d117a17e58c9') # This response return 429 status
               when 5 then conn.get('v3/f6713d28-4a02-4168-8b9e-fab6a0e1484c') # This response return 401 status
               else conn.get('v3/a7da6dc2-1923-437e-8bd9-3930506c3052') # This response return 200 status
               end

    if response.success?
      puts "(#{times}) Success: #{response.status} - #{response.body}"
    else
      puts "(#{times}) Error: #{response.status} - #{response.body}"
    end
    total_time = Time.now.utc - start_time
    puts "\n[\033;Total Elapsed Time:#{total_time}\033[0m] \033[1;31m#{"—" * (135 - (times.size + 7))}\033[0m"
  end
rescue StandardError => e
  puts e.message
end

# @return [void]
def headline(msg)
  line_length = 70 - (msg.size + 3)
  puts "\n[\033[1;34m#{msg}\033[0m] \033[1;31m#{"—" * line_length}\033[0m"
end
