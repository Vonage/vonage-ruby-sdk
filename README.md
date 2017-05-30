# Nexmo Client Library for Ruby

[![Gem Version](https://badge.fury.io/rb/nexmo.svg)](https://badge.fury.io/rb/nexmo) [![Build Status](https://api.travis-ci.org/Nexmo/nexmo-ruby.svg?branch=master)](https://travis-ci.org/Nexmo/nexmo-ruby)

This is the Ruby client library for Nexmo's API. To use it you'll
need a Nexmo account. Sign up [for free at nexmo.com][signup].

* [Installation](#installation)
* [Usage](#usage)
* [SMS API](#sms-api)
* [Voice API](#voice-api)
* [Verify API](#verify-api)
* [Number Insight API](#number-insight-api)
* [Application API](#application-api)
* [Coverage](#api-coverage)
* [License](#license)


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
client = Nexmo::Client.new(key: 'YOUR-API-KEY', secret: 'YOUR-API-SECRET')
```

For production you can specify the `NEXMO_API_KEY` and `NEXMO_API_SECRET`
environment variables instead of specifying the key and secret explicitly.

For newer endpoints that support JWT authentication such as the Voice API,
you can also specify the `application_id` and `private_key` arguments:

```ruby
client = Nexmo::Client.new(application_id: application_id, private_key: private_key)
```

In order to check signatures for incoming webhook requests, you'll also need
to specify the `signature_secret` argument (or the `NEXMO_SIGNATURE_SECRET`
environment variable).


## SMS API

### Send a text message

```ruby
response = client.send_message(from: 'Ruby', to: 'YOUR NUMBER', text: 'Hello world')

if response['messages'][0]['status'] == '0'
  puts "Sent message #{response['messages'][0]['message-id']}"
else
  puts "Error: #{response['messages'][0]['error-text']}"
end
```

Docs: [https://docs.nexmo.com/messaging/sms-api/api-reference#request](https://docs.nexmo.com/messaging/sms-api/api-reference#request?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)


## Voice API

### Make a call

```ruby
response = client.create_call({
  to: [{type: 'phone', number: '14843331234'}],
  from: {type: 'phone', number: '14843335555'},
  answer_url: ['https://example.com/answer']
})
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#call_create](https://docs.nexmo.com/voice/voice-api/api-reference#call_create?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Retrieve a list of calls

```ruby
response = client.get_calls
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#call_retrieve](https://docs.nexmo.com/voice/voice-api/api-reference#call_retrieve?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Retrieve a single call

```ruby
response = client.get_call(uuid)
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#call_retrieve_single](https://docs.nexmo.com/voice/voice-api/api-reference#call_retrieve_single?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Update a call

```ruby
response = client.update_call(uuid, action: 'hangup')
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#call_modify_single](https://docs.nexmo.com/voice/voice-api/api-reference#call_modify_single?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Stream audio to a call

```ruby
stream_url = 'https://nexmo-community.github.io/ncco-examples/assets/voice_api_audio_streaming.mp3'

response = client.send_audio(uuid, stream_url: stream_url)
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#stream_put](https://docs.nexmo.com/voice/voice-api/api-reference#stream_put?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Stop streaming audio to a call

```ruby
response = client.stop_audio(uuid)
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#stream_delete](https://docs.nexmo.com/voice/voice-api/api-reference#stream_delete?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Send a synthesized speech message to a call

```ruby
response = client.send_speech(uuid, text: 'Hello')
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#talk_put](https://docs.nexmo.com/voice/voice-api/api-reference#talk_put?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Stop sending a synthesized speech message to a call

```ruby
response = client.stop_speech(uuid)
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#talk_delete](https://docs.nexmo.com/voice/voice-api/api-reference#talk_delete?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Send DTMF tones to a call

```ruby
response = client.send_dtmf(uuid, digits: '1234')
```

Docs: [https://docs.nexmo.com/voice/voice-api/api-reference#dtmf_put](https://docs.nexmo.com/voice/voice-api/api-reference#dtmf_put?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)


## Verify API

### Start a verification

```ruby
response = client.start_verification(number: '441632960960', brand: 'MyApp')

if response['status'] == '0'
  puts "Started verification request_id=#{response['request_id']}"
else
  puts "Error: #{response['error_text']}"
end
```

Docs: [https://docs.nexmo.com/verify/api-reference/api-reference#vrequest](https://docs.nexmo.com/verify/api-reference/api-reference#vrequest?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

The response contains a verification request id which you will need to store temporarily.

### Check a verification

```ruby
response = client.check_verification('00e6c3377e5348cdaf567e1417c707a5', code: '1234')

if response['status'] == '0'
  puts "Verification complete, event_id=#{response['event_id']}"
else
  puts "Error: #{response['error_text']}"
end
```

Docs: [https://docs.nexmo.com/verify/api-reference/api-reference#check](https://docs.nexmo.com/verify/api-reference/api-reference#check?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

The verification request id comes from the call to the start_verification method.

The PIN code is entered into your application by the user.

### Cancel a verification

```ruby
client.cancel_verification('00e6c3377e5348cdaf567e1417c707a5')
```

Docs: [https://docs.nexmo.com/verify/api-reference/api-reference#control](https://docs.nexmo.com/verify/api-reference/api-reference#control?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Trigger next verification step

```ruby
client.trigger_next_verification_event('00e6c3377e5348cdaf567e1417c707a5')
```

Docs: [https://docs.nexmo.com/verify/api-reference/api-reference#control](https://docs.nexmo.com/verify/api-reference/api-reference#control?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

## Number Insight API

### Basic Number Insight

```ruby
client.get_basic_number_insight(number: '447700900000')
```

Docs: [https://docs.nexmo.com/number-insight/basic](https://docs.nexmo.com/number-insight/basic?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Standard Number Insight

```ruby
client.get_standard_number_insight(number: '447700900000')
```

Docs: [https://docs.nexmo.com/number-insight/standard](https://docs.nexmo.com/number-insight/standard?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Advanced Number Insight

```ruby
client.get_advanced_number_insight(number: '447700900000')
```

Docs: [https://docs.nexmo.com/number-insight/advanced](https://docs.nexmo.com/number-insight/advanced?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Advanced Number Insight Async

```ruby
client.get_advanced_number_insight(number: '447700900000', callback: webhook_url)
```

The results of the API call will be sent via HTTP POST to the webhook URL specified in the callback parameter.

Docs: [https://docs.nexmo.com/number-insight/advanced-async](https://docs.nexmo.com/number-insight/advanced-async?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)


## Application API

### Create an application

```ruby
response = client.create_application(name: 'Example App', type: 'voice', answer_url: answer_url)
```

Docs: [https://docs.nexmo.com/tools/application-api/api-reference#create](https://docs.nexmo.com/tools/application-api/api-reference#create?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Retrieve a list of applications

```ruby
response = client.get_applications
```

Docs: [https://docs.nexmo.com/tools/application-api/api-reference#list](https://docs.nexmo.com/tools/application-api/api-reference#list?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Retrieve a single application

```ruby
response = client.get_application(uuid)
```

Docs: [https://docs.nexmo.com/tools/application-api/api-reference#retrieve](https://docs.nexmo.com/tools/application-api/api-reference#retrieve?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Update an application

```ruby
response = client.update_application(uuid, answer_method: 'POST')
```

Docs: [https://docs.nexmo.com/tools/application-api/api-reference#update](https://docs.nexmo.com/tools/application-api/api-reference#update?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

### Delete an application

```ruby
response = client.delete_application(uuid)
```

Docs: [https://docs.nexmo.com/tools/application-api/api-reference#delete](https://docs.nexmo.com/tools/application-api/api-reference#delete?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)


## JWT authentication

By default the library generates a short lived JWT per request.

To generate a long lived JWT for multiple requests or to specify JWT claims
directly call Nexmo::JWT.auth_token to generate a token, and set the auth_token
attribute on the client object. For example:

```ruby
claims = {
  application_id: application_id,
  nbf: 1483315200,
  exp: 1514764800,
  iat: 1483228800
}

private_key = File.read('path/to/private.key')

auth_token = Nexmo::JWT.auth_token(claims, private_key)

client.auth_token = auth_token
````


## Validate webhook signatures

```ruby
client = Nexmo::Client.new(signature_secret: 'secret')

if client.check_signature(request.GET)
  # valid signature
else
  # invalid signature
end
```

Docs: [https://docs.nexmo.com/messaging/signing-messages](https://docs.nexmo.com/messaging/signing-messages?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library)

Note: you'll need to contact support@nexmo.com to enable message signing on
your account before you can validate webhook signatures.


## API Coverage

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
