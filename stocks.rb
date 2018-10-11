#!/usr/bin/env ruby
require 'sinatra'
require 'net/http'
require 'json'
require 'csv'
require 'stock_quote'

set :bind, '0.0.0.0'
set :port, 80

# The URI to do the stock symbol lookup.
# Returns a JSON document with stock name and price.
get '/stock/:name' do
  "Stock: #{params['name']}"
  result = lookup_stock(params['name'])
  puts result
  convert_to_JSON(params['name'], result) if !result.nil?
end

# The URI for the health check
get '/health' do
  "OK"
end

# Function to do the stock price lookup.
# Makes a call to the Yahoo Finance API and returns result
def lookup_stock(name)
  return StockQuote::Stock.quote(name)
end

# Converts CSV output from API call into a JSON document
def convert_to_JSON(name, response)
  output = CSV.parse(response).flatten
  result = {  :symbol => name,
              :name => output[0],
              :price => output[1] }
  result.to_json
end
