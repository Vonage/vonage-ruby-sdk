# Vonage Server SDK for Ruby

[![Gem Version](https://badge.fury.io/rb/vonage.svg)](https://badge.fury.io/rb/vonage) ![Coverage Status](https://github.com/Vonage/vonage-ruby-sdk/workflows/CI/badge.svg) [![codecov](https://codecov.io/gh/Vonage/vonage-ruby-sdk/branch/7.x/graph/badge.svg?token=FKW6KL532P)](https://codecov.io/gh/Vonage/vonage-ruby-sdk)


<img src="https://developer.nexmo.com/assets/images/Vonage_Nexmo.svg" height="48px" alt="Nexmo is now known as Vonage" />

This is the Ruby Server SDK for Vonage APIs. To use it you'll
need a Vonage account. Sign up [for free at vonage.com][signup].

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
    * [Logging](#logging)
    * [Exceptions](#exceptions)
    * [Overriding the default hosts](#overriding-the-default-hosts)
    * [JWT authentication](#jwt-authentication)
    * [Webhook signatures](#webhook-signatures)
    * [Pagination](#pagination)
    * [Messages API](#messages-api)
    * [Verify API v2](#verify-api-v2)
    * [Voice API](#voice-api)
      * [NCCO Builder](#ncco-builder)
* [Documentation](#documentation)
* [Supported APIs](#supported-apis)
* [Other SDKs and Tools](#other-sdks-and-tools)
* [License](#license)
* [Contribute](#contribute)


## Requirements

Vonage Ruby supports MRI/CRuby (2.5 or newer), JRuby (9.2.x), and Truffleruby.


## Installation

To install the Ruby Server SDK using Rubygems:

    gem install vonage

Alternatively you can clone the repository:

    git clone git@github.com:Vonage/vonage-ruby-sdk.git


## Usage

Begin by requiring the Vonage library:

```ruby
require 'vonage'
```

Then construct a client object with your key and secret:

```ruby
client = Vonage::Client.new(api_key: 'YOUR-API-KEY', api_secret: 'YOUR-API-SECRET')
```

You can now use the client object to call Vonage APIs. For example, to send an SMS:

```ruby
client.sms.send(from: 'Ruby', to: '447700900000', text: 'Hello world')
```

For production you can specify the `VONAGE_API_KEY` and `VONAGE_API_SECRET`
environment variables instead of specifying the key and secret explicitly,
keeping your credentials out of source control.

For APIs which use a JWT for authentication you'll need to pass `application_id` and `private_key` arguments to the
`Client` constructor as well as or instead of `api_key` and `api_secret`. See [JWT Authentication](#jwt-authentication).

It is also possible to over-ride the default hosts at `Client` instantiation. See [Overriding the default hosts](overriding-the-default-hosts).

### JWT authentication

To call newer endpoints that support JWT authentication such as the Voice API and Messages API you'll
also need to specify the `application_id` and `private_key` options. For example:

```ruby
client = Vonage::Client.new(application_id: application_id, private_key: private_key)
```

Both arguments should have string values corresponding to the `id` and `private_key`
values returned in a ["create an application"](https://developer.nexmo.com/api/application.v2#createApplication)
response. These credentials can be stored in a datastore, in environment variables,
on disk outside of source control, or in some kind of key management infrastructure.

By default the library generates a short lived JWT per request. To generate a long lived
JWT for multiple requests or to specify JWT claims directly use `Vonage::JWT.generate` and
the token option. For example:

```ruby
claims = {
  application_id: application_id,
  private_key: 'path/to/private.key',
  nbf: 1483315200,
  ttl: 800
}

token = Vonage::JWT.generate(claims)

client = Vonage::Client.new(token: token)
```

Documentation for the Vonage Ruby JWT generator gem can be found at
[https://www.rubydoc.info/github/nexmo/nexmo-jwt-ruby](https://www.rubydoc.info/github/nexmo/nexmo-jwt-ruby).
The documentation outlines all the possible parameters you can use to customize and build a token with.

### Logging

Use the logger option to specify a logger. For example:

```ruby
require 'logger'

logger = Logger.new(STDOUT)

client = Vonage::Client.new(logger: logger)
```

By default the library sets the logger to `Rails.logger` if it is defined.

To disable logging set the logger to `nil`.

### Exceptions

Where exceptions result from an error response from the Vonage API (HTTP responses that aren't ion the range `2xx` or `3xx`), the `Net::HTTPResponse` object will be available as a property of the `Exception` object via a `http_response` getter method (where there is no `Net::HTTPResponse` object associated with the exception, the value of `http_response` will be `nil`).

You can rescue the the exception to access the `http_response`, as well as use other getters provided for specific parts of the response. For example:

```ruby
begin
  verification_request = client.verify2.start_verification(
    brand: 'Acme',
    workflow: [{channel: 'sms', to: '44700000000'}]
  )
rescue Vonage::APIError => error
  if error.http_response
    error.http_response # => #<Net::HTTPUnauthorized 401 Unauthorized readbody=true>
    error.http_response_code # => "401"
    error.http_response_headers # => {"date"=>["Sun, 24 Sep 2023 11:08:47 GMT"], ...rest of headers}
    error.http_response_body # => {"title"=>"Unauthorized", ...rest of body}
  end
end
```

For certain legacy API products, such as the [SMS API](https://developer.vonage.com/en/messaging/sms/overview), [Verify v1 API](https://developer.vonage.com/en/verify/verify-v1/overview) and [Number Insight v1 API](https://developer.vonage.com/en/number-insight/overview), a `200` response is received even in situations where there is an API-related error. For exceptions raised in these situation, rather than a `Net::HTTPResponse` object, a `Vonage::Response` object will be made available as a property of the exception via a `response` getter method. The properties on this object will depend on the response data provided by the API endpoint. For example:

```ruby
begin
  sms = client.sms.send(
    from: 'Vonage',
    to: '44700000000',
    text: 'Hello World!'
  )
rescue Vonage::Error => error
  if error.is_a? Vonage::ServiceError
    error.response # => #<Vonage::Response:0x0000555b2e49d4f8>
    error.response.messages.first.status # => "4"
    error.response.messages.first.error_text # => "Bad Credentials"
    error.response.http_response # => #<Net::HTTPOK 200 OK readbody=true>
  end
end
```

### Overriding the default hosts

To override the default hosts that the SDK uses for HTTP requests, you need to
specify the `api_host`, `rest_host` or both in the client configuration. For example:

```ruby
client = Vonage::Client.new(
  api_host: 'api-sg-1.nexmo.com',
  rest_host: 'rest-sg-1.nexmo.com'
)
```

By default the hosts are set to `api.nexmo.com` and `rest.nexmo.com`, respectively.




### Webhook signatures

Certain Vonage APIs provide signed [webhooks](https://developer.vonage.com/en/getting-started/concepts/webhooks) as a means of verifying the origin of the webhooks. The exact signing mechanism varies depending on the API.

#### Signature in Request Body

The [SMS API](https://developer.vonage.com/en/messaging/sms/overview) signs the webhook request using a hash digest. This is assigned to a `sig` parameter in the request body.

You can verify the webhook request using the `Vonage::SMS#verify_webhook_sig` method. As well as the **request params** from the received webhook, the method also needs access to the signature secret associated with the Vonage account (available from the [Vonage Dashboard](https://dashboard.nexmo.com/settings)), and the signature method used for signing (e.g. `sha512`), again this is based on thes setting in the Dashboard.

There are a few different ways of providing these values to the method:

1. Pass all values to the method invocation.

```ruby
client = Vonage::Client.new

client.sms.verify_webhook_sig(
  webhook_params: params,
  signature_secret: 'secret',
  signature_method: 'sha512'
) # => returns true if the signature is valid, false otherwise
```

2. Set `signature_secret` and `signature_method` at `Client` instantiation.

```ruby
client = Vonage::Client.new(
  signature_secret: 'secret',
  signature_method: 'sha512'
)

client.sms.verify_webhook_sig(webhook_params: params) # => returns true if the signature is valid, false otherwise
```

3. Set `signature_secret` and `signature_method` on the `Config` object.

```ruby
client = Vonage::Client.new
client.config.signature_secret = 'secret'
client.config.signature_method = 'sha512'

client.sms.verify_webhook_sig(webhook_params: params) # => returns true if the signature is valid, false otherwise
```

4. Set `signature_secret` and `signature_method` as environment variables named `VONAGE_SIGNATURE_SECRET` and `VONAGE_SIGNATURE_METHOD`

```ruby
client = Vonage::Client.new

client.sms.verify_webhook_sig(webhook_params: params) # => returns true if the signature is valid, false otherwise
```

**Note:** Webhook signing for the SMS API is not switched on by default. You'll need to contact support@vonage.com to enable message signing on your account.

#### Signed JWT in Header

The [Voice API](https://developer.vonage.com/en/voice/voice-api/overview) and [Messages API](https://developer.vonage.com/en/messages/overview) both include an `Authorization` header in their webhook requests. The value of this header includes a JSON Web Token (JWT) signed using the Signature Secret associated with your Vonage account.

The `Vonage::Voice` and `Vonage::Messaging` classes both define a `verify_webhook_token` method which can be used to verify the JWT received in the webhook `Authorization` header.

To verify the JWT, you'll first need to extract it from the `Authorization` header. The header value will look something like the following:

```ruby
"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE1OTUyN" # remainder of token omitted for brevity
```

Note: we are only interested in the token itself, which comes *after* the word `Bearer` and the space.

Once you have extrated the token, you can pass it to the `verify_webhook_token` method in order to verify it.

The method also needs access to the the method also needs access to the signature secret associated with the Vonage account (available from the [Vonage Dashboard](https://dashboard.nexmo.com/settings)). There are a few different ways of providing this value to the method:

1. Pass all values to the method invocation.

```ruby
client = Vonage::Client.new

client.voice.verify_webhook_token(
  token: extracted_token,
  signature_secret: 'secret'
) # => returns true if the token is valid, false otherwise
```

2. Set `signature_secret` at `Client` instantiation.

```ruby
client = Vonage::Client.new(
  signature_secret: 'secret'
)

client.voice.verify_webhook_token(token: extracted_token) # => returns true if the token is valid, false otherwise
```

3. Set `signature_secret` on the `Config` object.

```ruby
client = Vonage::Client.new
client.config.signature_secret = 'secret'
client.config.signature_method = 'sha512'

client.voice.verify_webhook_token(token: extracted_token) # => returns true if the token is valid, false otherwise
```

4. Set `signature_secret` as an environment variable named `VONAGE_SIGNATURE_SECRET`

```ruby
client = Vonage::Client.new

client.voice.verify_webhook_token(token: extracted_token) # => returns true if the token is valid, false otherwise
```

### Pagination

Vonage APIs paginate list requests. This means that if a collection is requested that is larger than the API default, the API will return the first page of items in the collection. The Ruby SDK provides an `auto_advance` parameter that will traverse through the pages and return all the results in one response object.

The `auto_advance` parameter is set to a default of `true` for the following APIs:

* [Account API](https://developer.nexmo.com/api/developer/account)
* [Application API](https://developer.nexmo.com/api/application.v2)
* [Conversation API](https://developer.nexmo.com/api/conversation)
* [Voice API](https://developer.nexmo.com/api/voice)

To modify the `auto_advance` behavior you can specify it in your method:

```ruby
client.applications.list(auto_advance: false)
```


## Messages API

The [Vonage Messages API](https://developer.vonage.com/messages/overview) allows you to send messages over a number of different channels, and various message types within each channel. See the Vonage Developer Documentation for a [complete API reference](https://developer.vonage.com/api/messages-olympus) listing all the channel and message type combinations.

The Ruby SDK allows you to construct message data for specific messaging channels. Other than SMS (which has only one type -- text), you need to pass the message `:type` as well as the `:message` itself as arguments to the appropriate messages method, along with any optional properties if needed.

```ruby
# creating an SMS message
message = Vonage::Messaging::Message.sms(message: 'Hello world!')

# creating a WhatsApp Text message
message = Vonage::Messaging::Message.whatsapp(type: 'text', message: 'Hello world!')

# creating a WhatsApp Image message
message = Vonage::Messaging::Message.whatsapp(type: 'image', message: { url: 'https://example.com/image.jpg' })

# creating an MMS audio message with optional properties
message = Vonage::Messaging::Message.mms(type: 'audio', message: { url: 'https://example.com/audio.mp3' }, opts: {client_ref: "abc123"})
```

Once the message data is created, you can then send the message.

```ruby
response = client.messaging.send(to: "447700900000", from: "447700900001", **message)
```

## Verify API v2

The [Vonage Verify API v2](https://developer.vonage.com/en/verify/verify-v2/overview) allows you to manage 2FA verification workflows over a number of different channels such as SMS, WhatsApp, WhatsApp Interactive, Voice, Email, and Silent Authentication, either individually or in combination with each other. See the Vonage Developer Documentation for a [complete API reference](https://developer.vonage.com/en/api/verify.v2) listing all the channels, verification options, and callback types.

The Ruby SDK provides two methods for interacting with the Verify v2 API:

- `Verify2#start_verification`: starts a new verification request. Here you can specify options for the request and the workflow to be used.
- `Verify2#check_code`: for channels where the end-user is sent a one-time code, this method is used to verify the code against the `request_id` of the verification request created by the `start_verification` method.

### Creating a Verify2 Object

```ruby
verify = client.verify2
```

### Making a verification request

For simple requests, you may prefer to manually set the value for `workflow` (an array of one or more hashes containing the settings for a particular channel) and any optional params.

Example with the required `:brand` and `:workflow` arguments:

```ruby
verification_request = verify.start_verification(
  brand: 'Acme',
  workflow: [{channel: 'sms', to: '447000000000'}]
)
```

Example with the required `:brand` and `:workflow` arguments, and an optional `code_length`:

```ruby
verification_request = verify.start_verification(
  brand: 'Acme',
  workflow: [{channel: 'sms', to: '447000000000'}],
  code_length: 6
)
```

For more complex requests (e.g. with mutliple workflow channels or addtional options), or to take advantage of built-in input validation, you can use the `StartVerificationOptions` object and the `Workflow` and various channel objects or the `WorkflowBuilder`:

#### Create options using StartVerificationOptions object

```ruby
opts = verify.start_verification_options(
  locale: 'fr-fr',
  code_length: 6,
  client_ref: 'abc-123'
).to_h

verification_request = verify.start_verification(
  brand: 'Acme',
  workflow: [{channel: 'email', to: 'alice.example.com'}],
  **opts
)
```

#### Create workflow using Workflow and Channel objects

```ruby
# Instantiate a Workflow object
workflow = verify.workflow

# Add channels to the workflow
workflow << workflow.sms(to: '447000000000')
workflow << workflow.email(to: 'alice.example.com')

# Channel data is encpsulated in channel objects stored in the Workflow list array
workflow.list
# => [ #<Vonage::Verify2::Channels::SMS:0x0000561474a74778 @channel="sms", @to="447000000000">,
  #<Vonage::Verify2::Channels::Email:0x0000561474c51a28 @channel="email", @to="alice.example.com">]

# To use the list as the value for `:workflow` in a `start_verification` request call,
# the objects must be hashified
workflow_list = workflow.hashified_list
# => [{:channel=>"sms", :to=>"447000000000"}, {:channel=>"email", :to=>"alice.example.com"}]

verification_request = verify.start_verification(brand: 'Acme', workflow: workflow_list)
```

#### Create a workflow using the WorkflowBuilder

```ruby
workflow = verify.workflow_builder.build do |builder|
  builder.add_voice(to: '447000000001')
  builder.add_whatsapp(to: '447000000000')
end

workflow_list = workflow.hashified_list
# => [{:channel=>"voice", :to=>"447000000001"}, {:channel=>"whatsapp", :to=>"447000000000"}]

verification_request = verify.start_verification(brand: 'Acme', workflow: workflow_list)
```

### Cancelling a request

You can cancel in in-progress verification request

```ruby
# Get the `request_id` from the Vonage#Response object returned by the `start_verification` method call
request_id = verification_request.request_id

verify.cancel_verification_request(request_id: request_id)
```

### Checking a code

```ruby
# Get the `request_id` from the Vonage#Response object returned by the `start_verification` method call
request_id = verification_request.request_id

# Get the one-time code via user input
# e.g. from params in a route handler or controller action for a form input
code = params[:code]

begin
  code_check = verify.check_code(request_id: request_id, code: code)
rescue => error
  # an invalid code will raise an exception of type Vonage::ClientError
end

if code_check.http_response.code == '200'
  # code is valid
end
```

## Voice API

The [Vonage Voice API](The [Vonage Verify API v2](https://developer.vonage.com/en/verify/verify-v2/overview) allows you to automate voice interactions by creating calls, streaming audio, playing text to speech, playing DTMF tones, and other actions. See the Vonage Developer Documentation for a [complete API reference](https://developer.vonage.com/en/api/voice) listing all the Voice API capabilities.

The Ruby SDK provides numerous methods for interacting with the Voice v2 API. Here's an example of using the `create` method to make an outbound text-to-speech call:

```ruby
response = client.voice.create(
  to: [{
    type: 'phone',
    number: '447700900000'
  }],
  from: {
    type: 'phone',
    number: '447700900001'
  },
  answer_url: [
    'https://raw.githubusercontent.com/nexmo-community/ncco-examples/gh-pages/text-to-speech.json'
  ]
)
```

### NCCO Builder

The Vonage Voice API accepts instructions via JSON objects called NCCOs. Each NCCO can be made up multiple actions that are executed in the order they are written. The Vonage API Developer Portal contains an [NCCO Reference](https://developer.vonage.com/voice/voice-api/ncco-reference) with instructions and information on all the parameters possible.

The SDK includes an NCCO builder that you can use to build NCCOs for your Voice API methods.

For example, to build `talk` and `input` NCCO actions and then combine them into a single NCCO you would do the following:

```ruby
talk = Vonage::Voice::Ncco.talk(text: 'Hello World!')
input = Vonage::Voice::Ncco.input(type: ['dtmf'], dtmf: { bargeIn: true })
ncco = Vonage::Voice::Ncco.build(talk, input)

# => [{:action=>"talk", :text=>"Hello World!"}, {:action=>"input", :type=>["dtmf"], :dtmf=>{:bargeIn=>true}}]
```

Once you have the constructed NCCO you can then use it in a Voice API request:

```ruby
response = client.voice.create({
  to: [{type: 'phone', number: '14843331234'}],
  from: {type: 'phone', number: '14843335555'},
  ncco: ncco
})
```

## Documentation

Vonage Ruby SDK documentation: https://www.rubydoc.info/github/Vonage/vonage-ruby-sdk

Vonage Ruby SDK code examples: https://github.com/Vonage/vonage-ruby-code-snippets

Vonage APIs API reference: https://developer.nexmo.com/api

## Supported APIs

The following is a list of Vonage APIs for which the Ruby SDK currently provides support:

* [Account API](https://developer.vonage.com/en/account/overview)
* [Application API](https://developer.vonage.com/en/application/overview)
* [Conversation API](https://developer.vonage.com/en/conversation/overview)
* [Meetings API](https://developer.vonage.com/en/meetings/overview)
* [Messages API](https://developer.vonage.com/en/messages/overview)
* [Number Insight API](https://developer.vonage.com/en/number-insight/overview)
* [Numbers API](https://developer.vonage.com/en/numbers/overview)
* [Proactive Connect API](https://developer.vonage.com/en/proactive-connect/overview) *
* [Redact API](https://developer.vonage.com/en/redact/overview)
* [SMS API](https://developer.vonage.com/en/messaging/sms/overview)
* [Subaccounts API](https://developer.vonage.com/en/account/subaccounts/overview)
* [Verify API](https://developer.vonage.com/en/verify/overview)
* [Voice API](https://developer.vonage.com/en/verify/overview)

\* The Proactive Connect API is partially supported in the SDK. Specifically, the Events, Items, and Lists endpoints are supported.

## Other SDKs and Tools

You can find information about other Vonage SDKs and Tooling on our [Developer Portal](https://developer.vonage.com/en/tools).


## License

This library is released under the [Apache 2.0 License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt

## Contribute!

_We :heart: contributions to this library!_

It is a good idea to [talk to us](https://developer.vonage.com/community/slack)
first if you plan to add any new functionality.
Otherwise, [bug reports](https://github.com/Vonage/vonage-ruby-sdk/issues),
[bug fixes](https://github.com/Vonage/vonage-ruby-sdk/pulls) and feedback on the
library are always appreciated.
