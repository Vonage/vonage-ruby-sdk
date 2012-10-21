require 'net/http'
require 'net/https'
require 'multi_json'
require 'uri'
require 'nexmo/object'
require 'nexmo/response'
require 'nexmo/client'

module Nexmo
  class Error < StandardError
  end
end
