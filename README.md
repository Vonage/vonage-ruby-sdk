# Nexmo Client Library for Ruby

[![Gem Version](https://badge.fury.io/rb/nexmo.svg)](https://badge.fury.io/rb/nexmo) [![Build Status](https://api.travis-ci.org/Nexmo/nexmo-ruby.svg?branch=master)](https://travis-ci.org/Nexmo/nexmo-ruby) [![Coverage Status](https://coveralls.io/repos/github/Nexmo/nexmo-ruby/badge.svg?branch=coveralls)](https://coveralls.io/github/Nexmo/nexmo-ruby?branch=master)

This is the Ruby client library for Nexmo's API. To use it you'll
need a Nexmo account. Sign up [for free at nexmo.com][signup].

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
    * [Logging](#logging)
    * [Overring the default hosts](#overriding-the-default-hosts)
    * [JWT authentication](#jwt-authentication)
    * [Webhook signatures](#webhook-signatures)
* [Documentation](#documentation)
* [License](#license)


## Requirements

Nexmo Ruby supports MRI/CRuby (2.5 or newer), JRuby (9.2.x), and Truffleruby.


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

You can now use the client object to call Nexmo APIs. For example, to send an SMS:

```ruby
client.sms.send(from: 'Ruby', to: '447700900000', text: 'Hello world')
```

For production you can specify the `NEXMO_API_KEY` and `NEXMO_API_SECRET`
environment variables instead of specifying the key and secret explicitly,
keeping your credentials out of source control.


## Logging

Use the logger option to specify a logger. For example:

```ruby
require 'logger'

logger = Logger.new(STDOUT)

client = Nexmo::Client.new(logger: logger)
```

By default the library sets the logger to `Rails.logger` if it is defined.

To disable logging set the logger to `nil`.


## Overriding the default hosts

To override the default hosts that the SDK uses for HTTP requests, you need to
specify the `api_host`, `rest_host` or both in the client configuration. For example:

```ruby
client = Nexmo::Client.new(
  api_host: 'api-sg-1.nexmo.com',
  rest_host: 'rest-sg-1.nexmo.com'
)
```

By default the hosts are set to `api.nexmo.com` and `rest.nexmo.com`, respectively.


## JWT authentication

To call newer endpoints that support JWT authentication such as the Voice API you'll
also need to specify the `application_id` and `private_key` options. For example:

```ruby
client = Nexmo::Client.new(application_id: application_id, private_key: private_key)
```

Both arguments should have string values corresponding to the `id` and `private_key`
values returned in a ["create an application"](https://developer.nexmo.com/api/application.v2#createApplication)
response. These credentials can be stored in a datastore, in environment variables,
on disk outside of source control, or in some kind of key management infrastructure.

By default the library generates a short lived JWT per request. To generate a long lived
JWT for multiple requests or to specify JWT claims directly use `Nexmo::JWT.generate` and
the token option. For example:

```ruby
claims = {
  application_id: application_id,
  nbf: 1483315200,
  exp: 1514764800,
  iat: 1483228800
}

private_key = File.read('path/to/private.key')

token = Nexmo::JWT.generate(claims, private_key)

client = Nexmo::Client.new(token: token)
````


## Webhook signatures

To check webhook signatures you'll also need to specify the `signature_secret` option. For example:

```ruby
client = Nexmo::Client.new
client.config.signature_secret = 'secret'
client.config.signature_method = 'sha512'

if client.signature.check(request.GET)
  # valid signature
else
  # invalid signature
end
```

Alternatively you can set the `NEXMO_SIGNATURE_SECRET` environment variable.

Note: you'll need to contact support@nexmo.com to enable message signing on your account.


## Documentation

Nexmo Ruby documentation: https://www.rubydoc.info/github/nexmo/nexmo-ruby

Nexmo Ruby code examples: https://github.com/Nexmo/nexmo-ruby-code-snippets

Nexmo API reference: https://developer.nexmo.com/api


## License

This library is released under the [MIT License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt
