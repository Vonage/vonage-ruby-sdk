# Nexmo Client Library for Ruby

[![Gem Version](https://badge.fury.io/rb/nexmo.svg)](https://badge.fury.io/rb/nexmo) [![Build Status](https://api.travis-ci.org/Nexmo/nexmo-ruby.svg?branch=master)](https://travis-ci.org/Nexmo/nexmo-ruby)

This is the Ruby client library for Nexmo's API. To use it you'll
need a Nexmo account. Sign up [for free at nexmo.com][signup].

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [SMS API](#sms-api)
* [Voice API](#voice-api)
* [Verify API](#verify-api)
* [Number Insight API](#number-insight-api)
* [Application API](#application-api)
* [Numbers API](#numbers-api)
* [Secret Management API](#secret-management-api)
* [Redact API](#redact-api)
* [Logging](#logging)
* [JWT authentication](#jwt-authentication)
* [Webhook signatures](#webhook-signatures)
* [API coverage](#api-coverage)
* [License](#license)


## Requirements

Nexmo Ruby supports CRuby 2.1.0+ and JRuby 9k.


## Installation

To install the Ruby client library using Rubygems:

    gem install nexmo

Alternatively you can clone the repository:

    git clone git@github.com:Nexmo/nexmo-ruby.git


## Usage

Begin by requiring the nexmo library:

```ruby
require 'nexmo'
```

Then construct a client object with your key and secret:

```ruby
client = Nexmo::Client.new(api_key: 'YOUR-API-KEY', api_secret: 'YOUR-API-SECRET')
```

You can now use the client object to [send an SMS](#send-an-sms),
[start a verification](#start-a-verification), or [create an application](#create-an-application).

For production you can specify the `NEXMO_API_KEY` and `NEXMO_API_SECRET`
environment variables instead of specifying the key and secret explicitly,
keeping your credentials out of source control.


## Credentials

To check signatures for incoming webhook requests you'll also need to specify
the `signature_secret` argument:

```ruby
client = Nexmo::Client.new(signature_secret: 'secret')
```

Alternatively you can set the `NEXMO_SIGNATURE_SECRET` environment variable.

To call newer endpoints that support JWT authentication such as the Voice API you'll
also need to specify the `application_id` and `private_key` arguments. For example:

```ruby
client = Nexmo::Client.new(application_id: application_id, private_key: private_key)
```

Both arguments should have string values corresponding to the `id` and `private_key`
values returned in a ["create an application"](#create-an-application) response. These
credentials can be stored in a datastore, in environment variables, on disk outside
of source control, or in some kind of key management infrastructure.


## SMS API

### Send an SMS

```ruby
response = client.sms.send(from: 'Ruby', to: 'YOUR NUMBER', text: 'Hello world')

if response.messages.first.status == '0'
  puts "Sent message id=#{response.messages.first.message_id}"
else
  puts "Error: #{response.messages.first.error_text}"
end
```

Docs: [https://developer.nexmo.com/api/sms#send-an-sms](https://developer.nexmo.com/api/sms?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#send-an-sms)


## Voice API

### Create an outbound call

```ruby
response = client.calls.create({
  to: [{type: 'phone', number: '14843331234'}],
  from: {type: 'phone', number: '14843335555'},
  answer_url: ['https://example.com/answer']
})
```

Docs: [https://developer.nexmo.com/api/voice#createCall](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#createCall)

### Get details of your calls

```ruby
response = client.calls.list
```

Docs: [https://developer.nexmo.com/api/voice#getCalls](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#getCalls)

### Get detail of a specific call

```ruby
response = client.calls.get(uuid)
```

Docs: [https://developer.nexmo.com/api/voice#getCall](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#getCall)

### Modify an in progress call

```ruby
response = client.calls.hangup(uuid)
```

Docs: [https://developer.nexmo.com/api/voice#updateCall](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#updateCall)

### Play an audio file into a call

```ruby
stream_url = 'https://nexmo-community.github.io/ncco-examples/assets/voice_api_audio_streaming.mp3'

response = client.calls.stream.start(uuid, stream_url: [stream_url])
```

Docs: [https://developer.nexmo.com/api/voice#startStream](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#startStream)

### Stop playing an audio file into a call

```ruby
response = client.calls.stream.stop(uuid)
```

Docs: [https://developer.nexmo.com/api/voice#stopStream](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#stopStream)

### Play text to speech into a call

```ruby
response = client.calls.talk.start(uuid, text: 'Hello')
```

Docs: [https://developer.nexmo.com/api/voice#startTalk](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#startTalk)

### Stop text to speech in a call

```ruby
response = client.calls.talk.stop(uuid)
```

Docs: [https://developer.nexmo.com/api/voice#stopTalk](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#stopTalk)

### Play DTMF tones into a call

```ruby
response = client.calls.dtmf.send(uuid, digits: '1234')
```

Docs: [https://developer.nexmo.com/api/voice#startDTMF](https://developer.nexmo.com/api/voice?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#startDTMF)


## Verify API

### Start a verification

```ruby
response = client.verify.request(number: '441632960960', brand: 'MyApp')

if response.status == '0'
  puts "Started verification request_id=#{response.request_id}"
else
  puts "Error: #{response.error_text}"
end
```

Docs: [https://developer.nexmo.com/api/verify#verify-request](https://developer.nexmo.com/api/verify?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#verify-request)

The response contains a verification request id which you will need to store temporarily.

### Check a verification

```ruby
response = client.verify.check(request_id: '00e6c3377e5348cdaf567e1417c707a5', code: '1234')

if response.status == '0'
  puts "Verification complete, event_id=#{response.event_id}"
else
  puts "Error: #{response.error_text}"
end
```

Docs: [https://developer.nexmo.com/api/verify#verify-check](https://developer.nexmo.com/api/verify?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#verify-check)

The verification request id comes from the call to `client.verify.request`.

The PIN code is entered into your application by the user.

### Cancel a verification

```ruby
client.verify.cancel('00e6c3377e5348cdaf567e1417c707a5')
```

Docs: [https://developer.nexmo.com/api/verify#verify-control](https://developer.nexmo.com/api/verify?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#verify-control)

### Trigger next verification step

```ruby
client.verify.trigger_next_event('00e6c3377e5348cdaf567e1417c707a5')
```

Docs: [https://developer.nexmo.com/api/verify#verify-control](https://developer.nexmo.com/api/verify?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#verify-control)


## Number Insight API

### Basic Number Insight

```ruby
client.number_insight.basic(number: '447700900000')
```

Docs: [https://developer.nexmo.com/api/number-insight#request](https://developer.nexmo.com/api/number-insight?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#request)

### Standard Number Insight

```ruby
client.number_insight.standard(number: '447700900000')
```

Docs: [https://developer.nexmo.com/api/number-insight#request](https://developer.nexmo.com/api/number-insight?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#request)

### Advanced Number Insight

```ruby
client.number_insight.advanced(number: '447700900000')
```

Docs: [https://developer.nexmo.com/api/number-insight#request](https://developer.nexmo.com/api/number-insight?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#request)

### Advanced Number Insight Async

```ruby
client.number_insight.advanced_async(number: '447700900000', callback: webhook_url)
```

The results of the API call will be sent via HTTP POST to the webhook URL specified in the callback parameter.

Docs: [https://developer.nexmo.com/api/number-insight#request](https://developer.nexmo.com/api/number-insight?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#request)


## Application API

### Create an application

```ruby
response = client.applications.create(name: 'Example App', type: 'voice', answer_url: answer_url, event_url: event_url)
```

Docs: [https://developer.nexmo.com/api/application#create-an-application](https://developer.nexmo.com/api/application?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#create-an-application)

### Retrieve a list of applications

```ruby
response = client.applications.list
```

Docs: [https://developer.nexmo.com/api/application#retrieve-your-applications](https://developer.nexmo.com/api/application?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#retrieve-your-applications)

### Retrieve a single application

```ruby
response = client.applications.get(uuid)
```

Docs: [https://developer.nexmo.com/api/application#retrieve-an-application](https://developer.nexmo.com/api/application?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#retrieve-an-application)

### Update an application

```ruby
response = client.applications.update(uuid, answer_method: 'POST')
```

Docs: [https://developer.nexmo.com/api/application#update-an-application](https://developer.nexmo.com/api/application?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#update-an-application)

### Delete an application

```ruby
response = client.applications.delete(uuid)
```

Docs: [https://developer.nexmo.com/api/application#destroy-an-application](https://developer.nexmo.com/api/application?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#destroy-an-application)


## Numbers API

### List owned numbers

```ruby
client.numbers.list
```

Docs: [https://developer.nexmo.com/api/developer/numbers#list-owned-numbers](https://developer.nexmo.com/api/developer/numbers?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#list-owned-numbers)

### Search available numbers

```ruby
client.numbers.search(country: 'GB')
```

Docs: [https://developer.nexmo.com/api/developer/numbers#search-available-numbers](https://developer.nexmo.com/api/developer/numbers?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#search-available-numbers)

### Buy a number

```ruby
client.numbers.buy(country: 'GB', msisdn: '447700900000')
```

Docs: [https://developer.nexmo.com/api/developer/numbers#buy-a-number](https://developer.nexmo.com/api/developer/numbers?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#buy-a-number)

### Cancel a number

```ruby
client.numbers.cancel(country: 'GB', msisdn: '447700900000')
```

Docs: [https://developer.nexmo.com/api/developer/numbers#cancel-a-number](https://developer.nexmo.com/api/developer/numbers?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#cancel-a-number)

### Update a number

```ruby
client.numbers.update(country: 'GB', msisdn: '447700900000', voice_callback_type: 'app', voice_callback_value: application_id)
```

Docs: [https://developer.nexmo.com/api/developer/numbers#update-a-number](https://developer.nexmo.com/api/developer/numbers?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#update-a-number)


## Secret Management API

### Retrieve a list of secrets

```ruby
client.secrets.list
```

Docs: [https://developer.nexmo.com/api/account/secret-management#retrieveSecrets](https://developer.nexmo.com/api/account/secret-management?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#retrieveSecrets)

### Create a secret

```ruby
client.secrets.create(secret: 't0ps3cr3t')
```

Docs: [https://developer.nexmo.com/api/account/secret-management#createSecret](https://developer.nexmo.com/api/account/secret-management?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#createSecret)

### Retrieve a secret

```ruby
client.secrets.get(secret_id)
```

Docs: [https://developer.nexmo.com/api/account/secret-management#retrieveSecret](https://developer.nexmo.com/api/account/secret-management?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#retrieveSecret)

### Revoke a secret

```ruby
client.secrets.revoke(secret_id)
```

Docs: [https://developer.nexmo.com/api/account/secret-management#revokeSecret](https://developer.nexmo.com/api/account/secret-management?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#revokeSecret)


## Redact API

### Redact a specific message

```ruby
client.redact.transaction(id: '00A0B0C0', product: 'sms')
```

Docs: [https://developer.nexmo.com/api/redact#transaction](https://developer.nexmo.com/api/redact?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library#transaction)


## Logging

Use the logger option or attribute writer method to specify a logger. For example:

```ruby
require 'logger'

logger = Logger.new(STDOUT)

client = Nexmo::Client.new(logger: logger)
```

By default the library sets the logger to `Rails.logger` if it is defined.

To disable logging set the logger to `nil`.


## JWT authentication

By default the library generates a short lived JWT per request.

To generate a long lived JWT for multiple requests or to specify JWT claims
directly call `Nexmo::JWT.generate` to generate a token, and set the token
attribute on the client object. For example:

```ruby
claims = {
  application_id: application_id,
  nbf: 1483315200,
  exp: 1514764800,
  iat: 1483228800
}

private_key = File.read('path/to/private.key')

client.token = Nexmo::JWT.generate(claims, private_key)
````


## Webhook signatures

```ruby
client = Nexmo::Client.new(signature_secret: 'secret')

if client.signature.check(request.GET)
  # valid signature
else
  # invalid signature
end
```

Docs: [https://developer.nexmo.com/concepts/guides/signing-messages](https://developer.nexmo.com/concepts/guides/signing-messages?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

Note: you'll need to contact support@nexmo.com to enable message signing on your account.


## API coverage

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


## License

This library is released under the [MIT License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt
