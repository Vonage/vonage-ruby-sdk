Nexmo Client Library for Ruby
=============================

[![Gem Version](https://badge.fury.io/rb/nexmo.svg)](https://badge.fury.io/rb/nexmo) [![Build Status](https://api.travis-ci.org/Nexmo/nexmo-ruby.svg?branch=master)](https://travis-ci.org/Nexmo/nexmo-ruby)

This is the Ruby client library for Nexmo's API. To use it you'll
need a Nexmo account. Sign up [for free at nexmo.com][signup].

* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [License](#license)


Installation
------------

To install the Ruby client library using Rubygems:

    gem install nexmo

Alternatively you can clone the repository:

    git clone git@github.com:Nexmo/nexmo-ruby.git


Usage
-----

Specify your credentials using the `NEXMO_API_KEY` and `NEXMO_API_SECRET`
environment variables; require the nexmo library; and construct a client object.
For example:

```ruby
require 'nexmo'

nexmo = Nexmo::Client.new
```

Alternatively you can specify your credentials directly using the `key`
and `secret` options:

```ruby
require 'nexmo'

nexmo = Nexmo::Client.new(key: 'YOUR-API-KEY', secret: 'YOUR-API-SECRET')
```


Examples
--------

### Sending A Message

To use [Nexmo's SMS API][doc_sms] to send an SMS message, call the Nexmo::Client#send_message
method with a hash containing the API parameters. For example:

```ruby
response = nexmo.send_message(from: 'Ruby', to: 'YOUR NUMBER', text: 'Hello world')

response = response['messages'].first

if response['status'] == '0'
  puts "Sent message #{response['message-id']}"

  puts "Remaining balance is #{response['remaining-balance']}"
else
  puts "Error: #{response['error-text']}"
end
```

### Fetching A Message

You can retrieve a message log from the API using the ID of the message:

```ruby
message = nexmo.get_message('02000000DA7C52E7')

puts "The body of the message was: #{message['body']}"
```


License
-------

This library is released under the [MIT License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[doc_sms]: https://docs.nexmo.com/messaging/sms-api?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt
