# Vonage Server SDK for Ruby

[![Gem Version](https://badge.fury.io/rb/vonage.svg)](https://badge.fury.io/rb/vonage) [![Coverage Status](https://github.com/Vonage/vonage-ruby-sdk/workflows/CI/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/Vonage/vonage-ruby-sdk/badge.svg?branch=master)](https://coveralls.io/github/Vonage/vonage-ruby-sdk?branch=master)

<img src="https://developer.nexmo.com/assets/images/Vonage_Nexmo.svg" height="48px" alt="Nexmo is now known as Vonage" />

This is the Ruby Server SDK for Vonage APIs. To use it you'll
need a Vonage account. Sign up [for free at vonage.com][signup].

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
    * [Logging](#logging)
    * [Overriding the default hosts](#overriding-the-default-hosts)
    * [JWT authentication](#jwt-authentication)
    * [Webhook signatures](#webhook-signatures)
* [Documentation](#documentation)
* [Frequently Asked Questions](#frequently-asked-questions)
    * [Supported APIs](#supported-apis)
* [License](#license)


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


## Logging

Use the logger option to specify a logger. For example:

```ruby
require 'logger'

logger = Logger.new(STDOUT)

client = Vonage::Client.new(logger: logger)
```

By default the library sets the logger to `Rails.logger` if it is defined.

To disable logging set the logger to `nil`.


## Overriding the default hosts

To override the default hosts that the SDK uses for HTTP requests, you need to
specify the `api_host`, `rest_host` or both in the client configuration. For example:

```ruby
client = Vonage::Client.new(
  api_host: 'api-sg-1.nexmo.com',
  rest_host: 'rest-sg-1.nexmo.com'
)
```

By default the hosts are set to `api.nexmo.com` and `rest.nexmo.com`, respectively.


## JWT authentication

To call newer endpoints that support JWT authentication such as the Voice API you'll
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
````

Documentation for the Vonage Ruby JWT generator gem can be found at
[https://www.rubydoc.info/github/nexmo/nexmo-jwt-ruby](https://www.rubydoc.info/github/nexmo/nexmo-jwt-ruby).
The documentation outlines all the possible parameters you can use to customize and build a token with.

## Webhook signatures

To check webhook signatures you'll also need to specify the `signature_secret` option. For example:

```ruby
client = Vonage::Client.new
client.config.signature_secret = 'secret'
client.config.signature_method = 'sha512'

if client.signature.check(request.GET)
  # valid signature
else
  # invalid signature
end
```

Alternatively you can set the `VONAGE_SIGNATURE_SECRET` environment variable.

Note: you'll need to contact support@nexmo.com to enable message signing on your account.


## Documentation

Vonage Ruby documentation: https://www.rubydoc.info/github/Vonage/vonage-ruby-sdk

Vonage Ruby code examples: https://github.com/Nexmo/nexmo-ruby-code-snippets

Vonage APIs API reference: https://developer.nexmo.com/api

## Frequently Asked Questions

## Supported APIs

The following is a list of Vonage APIs and whether the Ruby SDK provides support for them:

| API   | API Release Status |  Supported?
|----------|:---------:|:-------------:|
| Account API | General Availability |✅|
| Alerts API | General Availability |✅|
| Application API | General Availability |✅|
| Audit API | Beta |❌|
| Conversation API | Beta |❌|
| Dispatch API | Beta |❌|
| External Accounts API | Beta |❌|
| Media API | Beta | ❌|
| Messages API | Beta |❌|
| Number Insight API | General Availability |✅|
| Number Management API | General Availability |✅|
| Pricing API | General Availability |✅|
| Redact API | Developer Preview |✅|
| Reports API | Beta |❌|
| SMS API | General Availability |✅|
| Verify API | General Availability |✅|
| Voice API | General Availability |✅|

## License

This library is released under the [Apache 2.0 License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt
