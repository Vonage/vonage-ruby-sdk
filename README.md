Nexmo Client Library for Ruby
=============================

[![Gem Version](https://badge.fury.io/rb/nexmo.svg)](https://badge.fury.io/rb/nexmo) [![Build Status](https://api.travis-ci.org/Nexmo/nexmo-ruby.svg?branch=master)](https://travis-ci.org/Nexmo/nexmo-ruby)

This is the Ruby client library for Nexmo's API. To use it you'll
need a Nexmo account. Sign up [for free at nexmo.com][signup].

* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [Coverage](#api-coverage)
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

client = Nexmo::Client.new
```

Alternatively you can specify your credentials directly using the `key`
and `secret` options:

```ruby
require 'nexmo'

client = Nexmo::Client.new(key: 'YOUR-API-KEY', secret: 'YOUR-API-SECRET')
```


Examples
--------

### Sending a message

To use [Nexmo's SMS API][doc_sms] to send an SMS message, call the Nexmo::Client#send_message
method with a hash containing the API parameters. For example:

```ruby
response = client.send_message(from: 'Ruby', to: 'YOUR NUMBER', text: 'Hello world')

response = response['messages'].first

if response['status'] == '0'
  puts "Sent message #{response['message-id']}"

  puts "Remaining balance is #{response['remaining-balance']}"
else
  puts "Error: #{response['error-text']}"
end
```

### Fetching a message

You can retrieve a message log from the API using the ID of the message:

```ruby
message = client.get_message('02000000DA7C52E7')

puts "The body of the message was: #{message['body']}"
```

### Starting a verification

Nexmo's [Verify API][doc_verify] makes it easy to prove that a user has provided their
own phone number during signup, or implement second factor authentication during signin.

You can start the verification process by calling the start_verification method:

```ruby
response = client.start_verification(number: '441632960960', brand: 'MyApp')

if response['status'] == '0'
  puts "Started verification request_id=#{response['request_id']}"
else
  puts "Error: #{response['error_text']}"
end
```

The response contains a verification request id which you will need to
store temporarily (in the session, database, url etc).

### Controlling a verification

Call the cancel_verification method with the verification request id
to cancel an in-progress verification:

```ruby
client.cancel_verification('00e6c3377e5348cdaf567e1417c707a5')
```

Call the trigger_next_verification_event method with the verification
request id to trigger the next attempt to send the confirmation code:

```ruby
client.trigger_next_verification_event('00e6c3377e5348cdaf567e1417c707a5')
```

The verification request id comes from the call to the start_verification method.

### Checking a verification

Call the check_verification method with the verification request id and the
PIN code to complete the verification process:

```ruby
response = client.check_verification('00e6c3377e5348cdaf567e1417c707a5', code: '1234')

if response['status'] == '0'
  puts "Verification complete, event_id=#{response['event_id']}"
else
  puts "Error: #{response['error_text']}"
end
```

The verification request id comes from the call to the start_verification method.
The PIN code is entered into your application by the user.


API Coverage
------------

* Account
    * [X] Balance
    * [X] Pricing
    * [X] Settings
    * [X] Top Up
    * [X] Numbers
        * [X] Search
        * [X] Buy
        * [X] Cancel
        * [X] Update
* Number Insight
    * [X] Basic
    * [X] Standard
    * [X] Advanced
    * [ ] Webhook Notification
* Verify
    * [X] Verify
    * [X] Check
    * [X] Search
    * [X] Control
* Messaging 
    * [X] Send
    * [ ] Delivery Receipt
    * [ ] Inbound Messages
    * [X] Search
        * [X] Message
        * [X] Messages
        * [X] Rejections
    * [X] US Short Codes
        * [X] Two-Factor Authentication
        * [X] Event Based Alerts
            * [X] Sending Alerts
            * [X] Campaign Subscription Management
* Voice
    * [X] Outbound Calls
    * [ ] Inbound Call
    * [X] Text-To-Speech Call
    * [X] Text-To-Speech Prompt


License
-------

This library is released under the [MIT License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[doc_sms]: https://docs.nexmo.com/messaging/sms-api?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[doc_verify]: https://docs.nexmo.com/verify/api-reference?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt
