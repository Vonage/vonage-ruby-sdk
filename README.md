# Vonage Server SDK for Ruby

[![Gem Version](https://badge.fury.io/rb/vonage.svg)](https://badge.fury.io/rb/vonage) ![Coverage Status](https://github.com/Vonage/vonage-ruby-sdk/workflows/CI/badge.svg) [![codecov](https://codecov.io/gh/Vonage/vonage-ruby-sdk/branch/7.x/graph/badge.svg?token=FKW6KL532P)](https://codecov.io/gh/Vonage/vonage-ruby-sdk)


<img src="https://developer.nexmo.com/assets/images/Vonage_Nexmo.svg" height="48px" alt="Nexmo is now known as Vonage" />

This is the Ruby Server SDK for Vonage APIs. To use it you'll
need a Vonage account. Sign up [for free at vonage.com][signup].

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
    * [Authentication](#authentication)
      * [Basic Authentication](#basic-authentication)
      * [JWT Authentication](#jwt-authentication)
      * [Signature Authentication](#signature-authentication)
    * [Logging](#logging)
    * [Exceptions](#exceptions)
    * [Overriding the default hosts](#overriding-the-default-hosts)
    * [HTTP Client Configuration](#http-client-configuration)
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
client = Vonage::Client.new
```

You can now use the client object to call Vonage APIs. For example, to send an SMS:

```ruby
client.sms.send(from: 'Ruby', to: '447700900000', text: 'Hello world')
```

When instantiating the `Client` object you can pass in various arguments to configure it such as credentials for [authentication](#authentication), values for [overriding the default hosts](overriding-the-default-hosts), or [configuration options for the HTTP client](#http-client-configuration).

### Authentication

All requests to the Vonage APIs are authenticated, so the `Client` object will need access to your Vonage credentials. Different Vonage API products support different authenitcations methods, so the credentials required will depend on the authenticaton method used. A few API products also support [multiple authentication methods](#products-with-multiple-authentication-methods).

Currently, all Vonage API products support one or more of the following authentication methods:

- [Basic Authentication](#basic-authentication)
- [JWT Authentication](#jwt-authentication)
- [Signature Authentication](#signature-authentication)

For a complete list of which products support which authentication methods, please refer to the [Vonage documentation on this topic](https://developer.vonage.com/en/getting-started/concepts/authentication).

Providing the necessary credentials to the client can be done in a number of ways. You can pass the credentials as keyword arguments when calling `Client.new`, for example in order to provide you API Key and API Secret you could use the `api_key` and `api_secret` keyword arguments respectively. You can pass the value for these arguments directly in the method call like so:

```ruby
client = Vonage::Client.new(api_key: 'abc123', api_secret: 'abc123456789')
```

Generally though, and especially for production code or any code that you plan to push up to source control, you will want to avoid exposing your credentials directly in this way and instead use environment variables to define your credentials.

> [!CAUTION]
> When setting environment variables locally, if using a file to do this (such as in an `.env` file), you should include the name of that file in a `.gitignore` file if you are intending to push your code up to source control.

You can choose to define your own custom environment variables and then use Ruby's `ENV` hash to pass them in as the values for your keyword arguments, for example:

```ruby
client = Vonage::Client.new(api_key: ENV['MY_API_KEY'], api_secret: ENV['MY_API_SECRET'])
```

A less verbose approach is to instantiate the client *without* passing in keyword arguments for the authentication credentials. 

```ruby
client = Vonage::Client.new
```

In this case the `Config` object used by the `Client` will search your environment for some pre-defined environment variables and use the values of those variables if defined. The names of these pre-defined environment variables are outlined in the sections below on the specific authentication methods.

Note that some Vonage API products support multiple authentication methods. In these cases the Ruby SDK sets a default authentication method for that product, which can be over-ridden with a configuration setting. You can learn more about this in the section on [Products with Multiple Authentication Methods](#products-with-multiple-authentication-methods).

#### Basic Authentication

For products that use Basic Authentication, the Ruby SDK sets an `Authorization` header on the HTTP request with a value containing a Base64 encoded version of your API key and secret. You can read more about this authentication method in the [Vonage documentation](https://developer.vonage.com/en/getting-started/concepts/authentication?source=getting-started#basic-authentication).

To set the header the SDK requires access to your API Key and API Secret. You can either:

1. Pass them in to the `Client` constructor as `api_key` and `api_secret` keyword arguments, either passing in the values directly or as environement variables with custom keys:
    ```ruby
    client = Vonage::Client.new(api_key: 'abc123', api_secret: 'abc123456789')
    ```
    or
    ```
    # .env
    MY_API_KEY=abc123
    MY_API_SECRET=abc123456789
    ```
    ```ruby
    client = Vonage::Client.new(api_key: ENV['MY_API_KEY'], api_secret: ENV['MY_API_SECRET'])
    ```

2. Set them as environment variables with the `VONAGE_API_KEY` and `VONAGE_API_SECRET` keys and then call the constructor without the keyword arguments:
    ```
    # .env
    VONAGE_API_KEY=abc123
    VONAGE_API_SECRET=abc123456789
    ```
    ```ruby
    client = Vonage::Client.new
    ```

#### JWT Authentication

For products that use Bearer (JWT) Authentication, the Ruby SDK sets an `Authorization` header on the HTTP request with a value containing a JSON Web Token (JWT) derived from an Application ID and Private Key. You can read more about this authentication method in the [Vonage documentation](https://developer.vonage.com/en/getting-started/concepts/authentication#json-web-tokens), but in brief you will need to create a Vonage Application (for example via the [Vonage Developer Dashboard](https://dashboard.vonage.com/applications), [Application API](https://developer.vonage.com/en/application/overview), or [Vonage CLI](https://github.com/vonage/vonage-cli)). This Application will be assigned a unique ID upon creation. You can then generate a public and private key pair specific to this Application.

The Ruby SDK automatically generates the JWT and sets the `Authorization` header for you. To do this it requires access to an Application ID and assocaited Private Key. You can either:

1. Pass them in to the `Client` constructor as `application_id` and `private_key` keyword arguments, either passing in the values directly or as environement variables with custom keys:
    ```ruby
    client = Vonage::Client.new(
      application_id: '78d335fa-323d-0114-9c3d-d6f0d48968cf',
      private_key: '-----BEGIN PRIVATE KEY----- MIIEvQIBADANBgkqhkiG9w0BAQEFA........'
    )
    ```
    or
    ```
    # .env
    MY_APPLICATION_ID=78d335fa-323d-0114-9c3d-d6f0d48968cf
    MY_PRIVATE_KEY=-----BEGIN PRIVATE KEY----- MIIEvQIBADANBgkqhkiG9w0BAQEFA........
    ```
    ```ruby
    client = Vonage::Client.new(application_id: ENV['MY_APPLICATION_ID'], private_key: ENV['MY_PRIVATE_KEY'])
    ```
  
2. Set them as environment variables with the `VONAGE_APPLICATION_ID` and `VONAGE_PRIVATE_KEY` keys and then call the constructor without the keyword arguments:
    ```
    # .env
    VONAGE_APPLICATION_ID=78d335fa-323d-0114-9c3d-d6f0d48968cf
    VONAGE_PRIVATE_KEY=-----BEGIN PRIVATE KEY----- MIIEvQIBADANBgkqhkiG9w0BAQEFA........
    ```
    ```ruby
    client = Vonage::Client.new
    ```

##### Using a Private Key File

Using the private key directly, whether to pass it in as a keyword argument or set it as an environment variable, can be a litle bit unweildy. Another option is to store it in a `.key` file and then read the contents of that file in as necessary.

> [!CAUTION]
> You should include the name of your Private Key file in a `.gitignore` file if you are intending to push your code up to source control.

For example, if you had your private key stored in a file called `private.key` in the root directory of your Ruby application, you could:

1. Read the contents of the file in using Ruby's `File.read` method when passing the `private_key` keyword argument to the `Client` constructor, either by passing the filepath directly or as an environement variables with a custom key:
    ```ruby
    client = Vonage::Client.new(
      application_id: '78d335fa-323d-0114-9c3d-d6f0d48968cf',
      private_key: File.read('/private.key)
    )
    ```
    or
    ```
    # .env
    MY_APPLICATION_ID=78d335fa-323d-0114-9c3d-d6f0d48968cf
    MY_PRIVATE_KEY_PATH=/private.key
    ```
    ```ruby
    client = Vonage::Client.new(application_id: ENV['MY_APPLICATION_ID'], private_key: File.read(ENV['MY_PRIVATE_KEY_PATH']))
    ```

2. Set the path as an environment variable with the `VONAGE_PRIVATE_KEY_PATH` key (note: this is used in place of the `VONAGE_PRIVATE_KEY` key) and then call the constructor without the keyword arguments:
    ```
    # .env
    VONAGE_APPLICATION_ID=78d335fa-323d-0114-9c3d-d6f0d48968cf
    VONAGE_PRIVATE_KEY_PATH=/private.key
    ```
    ```ruby
    client = Vonage::Client.new
    ```

    If `VONAGE_PRIVATE_KEY_PATH` is set, then the Ruby SDK will attempt to read in the contents of the file at the path provided and use those contents as the Private Key.

> [!TIP]
> You can download your Private Key file when creating or updating a Vonage Application in the [Vonage Developer Dashboard](https://dashboard.vonage.com/applications), or creating a Vonage Application with the [Vonage CLI](https://github.com/vonage/vonage-cli). You can also create your own file using the value of the `keys.private_key` param provided in the HTTP response when creating a Vonage Application using the [Application API](https://developer.vonage.com/en/application/overview).

##### Custom JWTs

By default the library generates a short lived JWT per request (the default `ttl` is `900` seconds). If you need to generate a long lived JWT for multiple requests or specify JWT claims directly use `Vonage::JWT.generate` to generate a custom JWT and then pass that in to the `Client` constructor using the `token` option. For example:

```ruby
claims = {
  application_id: ENV['VONAGE_APPLICATION_ID'],
  private_key: File.read(ENV['VONAGE_PRIVATE_KEY_PATH']),
  nbf: 1483315200,
  ttl: 3600
}

token = Vonage::JWT.generate(claims)

client = Vonage::Client.new(token: token)
```

The `Client` object will then use the JWT that you passed in for any API requests rather than generating one on-the-fly for each request.

> [!NOTE]  
> 1. Unlike with the `Client` constructor, you **must** set `application_id` and `private_key` as key-value pairs in the `claims` Hash when generating a custom JWT.
> 2. You can choose to set *either* `ttl` *or* `exp` in the `claims`:
>     - If you set *both* `ttl` is ignored and `exp` is used
>     - If you choose to set `exp` this must be set as the number of seconds since the UNIX epoch (if using `ttl` the generator calculates this for you)

Documentation for the Vonage Ruby JWT generator gem can be found at: https://www.rubydoc.info/gems/vonage-jwt

The documentation outlines all the possible parameters you can use to customize and build a token with.

#### Signature Authentication

Signature authentication signs the request using a signature created via a signing algorithm and using your Vonage Signature Secret. You can read more about this authentication method in the [Vonage documentation](https://developer.vonage.com/en/getting-started/concepts/signing-messages).

To create the signature the SDK requires access to your API Key and Signature Secret. You can either:

1. Pass them in to the `Client` constructor as `api_key` and `signature_secret` keyword arguments, either passing in the values directly or as environement variables with custom keys:
    ```ruby
    client = Vonage::Client.new(api_key: 'abc123', signature_secret: 'hdEooIhQYgo5XAcmbfLfpy5ROcEwGbjcwj6EvywwvYNOxKWj71')
    ```
    or
    ```
    # .env
    MY_API_KEY=abc123
    MY_SIGNATURE_SECRET=hdEooIhQYgo5XAcmbfLfpy5ROcEwGbjcwj6EvywwvYNOxKWj71
    ```
    ```ruby
    client = Vonage::Client.new(api_key: ENV['MY_API_KEY'], api_secret: ENV['MY_SIGNATURE_SECRET'])
    ```

2. Set them as environment variables with the `VONAGE_API_KEY` and `VONAGE_SIGNATURE_SECRET` keys and then call the constructor without the keyword arguments:
    ```
    # .env
    VONAGE_API_KEY=abc123
    VONAGE_SIGNATURE_SECRET=hdEooIhQYgo5XAcmbfLfpy5ROcEwGbjcwj6EvywwvYNOxKWj71
    ```
    ```ruby
    client = Vonage::Client.new
    ```

By default, the Ruby SDK uses the MD5 HASH algorithm to generate the signature. If you've set a different algorithm in your [Vonage API Settings](https://dashboard.vonage.com/settings), you'll need to over-ride the default when instantiating the `Client` object, for example:

```ruby
  client = Vonage::Client.new(
    api_key: 'abc123',
    signature_secret: 'hdEooIhQYgo5XAcmbfLfpy5ROcEwGbjcwj6EvywwvYNOxKWj71',
    signature_method: 'sha512'
  )
```

You can also set the Signature Method as the `VONAGE_SIGNATURE_METHOD` environment variable, for example:

```
# .env
VONAGE_API_KEY=abc123
VONAGE_SIGNATURE_SECRET=hdEooIhQYgo5XAcmbfLfpy5ROcEwGbjcwj6EvywwvYNOxKWj71
VONAGE_SIGNATURE_METHOD=sha512
```
```ruby
client = Vonage::Client.new
```

Supported algorithms are:

- `md5hash`
- `md5` (HMAC)
- `sha1`
- `sha256`
- `sha512`

#### Products with Multiple Authentication Methods

Some Vonage API products support more than one authentication method. For these products the Ruby SDK sets a default authentication method, but this default can be over-ridden in the `Client` configuration using the `authentication_preference` setting. For example, the Messages API supports both Basic Authentication and Bearer Token (JWT) Authentication. For its Messages API implementation the Ruby SDK defaults to Bearer Token (JWT) Authentication and so you would normally need to provide a Vonage Application ID and Private Key as credentials in order to authenticate when using the Messages API via the Ruby SDK. However, you can instead provide your Vonage API Key and API Secret and set the `Client` object to use Basic Authentication instead:

```
# .env
VONAGE_API_KEY=abc123
VONAGE_API_SECRET=abc123456789
```

```ruby
client = Vonage::Client.new(authentication_preference: :basic)
```

Below is a list of Vonage API products currently implemented in the Ruby SDK that support more than one authentication method.

| Product | Authentication Methods | Default | Over-ride Key |
|---|---|---|---|
| Messages API | JWT, Basic | JWT | `:basic` |
| Verify API v2 | JWT, Basic | JWT | `:basic` |
| SMS API | Basic, Signature | Basic | `:signature` |

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

### HTTP Client Configuration

It is possible to set configuration options on the HTTP client. This can be don in a couple of ways.

1. Using an `:http` key during `Vonage::Client` instantiation, for example:
    ```ruby
    client = Vonage::Client.new(
      api_key: 'YOUR-API-KEY',
      api_secret: 'YOUR-API-SECRET',
      http: {
        max_retries: 1
      }
    )
    ```

2. By using the `http=` setter on the `Vonage::Config` object, for example:
    ```ruby
    client = Vonage::Client.new(
      api_key: 'YOUR-API-KEY',
      api_secret: 'YOUR-API-SECRET'
    )

    client.config.http = { max_retries: 1 }
    ```

The Vonage Ruby SDK uses the [`Net::HTTP::Persistent` library](https://github.com/drbrain/net-http-persistent) as an HTTP client. For available configuration options see [the documentation for that library](https://www.rubydoc.info/gems/net-http-persistent/3.0.0/Net/HTTP/Persistent).

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

* [Account API](https://developer.vonage.com/api/developer/account)
* [Application API](https://developer.vonage.com/api/application.v2)
* [Conversation API](https://developer.vonage.com/api/conversation)
* [Voice API](https://developer.vonage.com/api/voice)

To modify the `auto_advance` behavior you can specify it in your method:

```ruby
client.applications.list(auto_advance: false)
```


## Messages API

The [Vonage Messages API](https://developer.vonage.com/messages/overview) allows you to send messages over a number of different channels, and various message types within each channel. See the Vonage Developer Documentation for a [complete API reference](https://developer.vonage.com/en/api/messages) listing all the channel and message type combinations.

### Sending a Message

The Ruby SDK implements a `Messaging` object which can be accessed via a `messaging` method on the `Client` object. The `Messaging` object has a `send` method which lets you send any message type via any channel.

```ruby
response = client.messaging.send(
  # message data
)
```

There are a number of ways in which you can pass the necessary message data to the method.

**Using Keyword Arguments**

You can pass the message properties and their values as keyword arguments to the method. For example:

```ruby
response = client.messaging.send(
  to: '447700900000',
  from: '447700900001',
  channel: 'sms',
  message_type: 'text',
  text: 'Hello world!'
)
```

**Spread a Hash**

For more complex message structures, you can define the message as a Hash literal and then spread that Hash as keyword arguments by passing it to the `send` method using the double-splat opertator (`**`). For example:

```ruby
message = {
  to: '447700900000',
  from: '447700900001',
  channel: 'mms',
  message_type: 'image',
  image: {
    url: 'https://example.com/image.jpg',
    caption: 'This is an image'
  }
}

response = client.messaging.send(**message)
```

**Using a Combination of Keyword Arguments and Spread**

You can use a combination of the above two approaches. This might be useful in situations where you want to iteratively send the same message to multiple recipients, for example:

```ruby
message = {
  from: '447700900000',
  channel: 'sms',
  message_type: 'text',
  text: 'Hello world!'
}

['447700900001', '447700900002', '447700900003'].each do |to_number|
  client.messaging.send(to: to_number, **message)
end
```

**Using Channel Convenience Methods**

The Ruby SDK provides convenience methods for each channel which return a Hash object which you can then pass to the `send` method in the same way that you would with a Hash literal. As well as a simpler interface, the convenience methods also provide some basic validation.

Other than SMS (which has only one type -- `text`), these methods require a `:type` argument, which defines the `message_type` of the message within that channel. They also require a `:message` argument, which defvines the message itself; this is a String in the case of `text` messages, and a Hash containing the appopriate properties for other message types (e.g. `image`). You can also optionally pass an `opts` arguments, the value of which should be a Hash which defines any other property that you want to include in the message.

```ruby
# Using the SMS method like this:
message = client.messaging.sms(to: "447700900000", from: "447700900001", message: "Hello world!")

# is the equivalent of using a Hash literal like this:
message = {
  channel: "sms",
  to: "447700900000",
  from: "447700900001",
  message_type: "text",
  text: "Hello world!"
}
```

Once the message Hash is created, you can then pass it into the `send` method using the double-splat opertator (`**`).

```ruby
response = client.messaging.send(**message)
```

A few additional examples of using these convenience methods are shown below:


```ruby
# creating an RCS Text message
message = client.messaging.rcs(to: "447700900000", from: "RCS-Agent", type: 'text', message: 'Hello world!')

# creating a WhatsApp Text message
message = client.messaging.whatsapp(to: "447700900000", from: "447700900001", type: 'text', message: 'Hello world!')

# creating a WhatsApp Image message
message = client.messaging.whatsapp(to: "447700900000", from: "447700900001", type: 'image', message: { url: 'https://example.com/image.jpg' })

# creating an MMS audio message with optional properties
message = client.messaging.mms(
  to: "447700900000",
  from: "447700900001",
  type: 'audio',
  message: { 
    url: 'https://example.com/audio.mp3'
  },
  opts: {
    client_ref: "abc123"
  }
)
```

You can choose to omit the `to` and/or `from` arguments from the convenience method calls and instead pass them in as keyword arguments during the `send` method invocation.

```ruby
message = client.messaging.sms(from: "447700900001", message: "Hello world!")

['447700900001', '447700900002', '447700900003'].each do |to_number|
  client.messaging.send(to: to_number, **message)
end
```

### Sending a Message with Failover

The Messages API lets you define one or more failover messages which will be sent if the initial message is rejected. In the Ruby SDK, this feature is implemented by passing a `failover` keyword argument during the invocation of the `send` method. The value of this argument must be an Array containing one or more Hash objects representing the failover message(s). For example:

```ruby
# Sending an RCS message with failover to SMS
rcs_message = messaging.rcs(
    to: '447900000000',
    from: 'RCS-Agent',
    type: 'text',
    message: 'This is an RCS message. If you see this, RCS is working!'
  )

  sms_message = messaging.sms(
    to: '447900000000',
    from: 'Vonage',
    message: 'This is a failover SMS message in case RCS fails.'
  )

  response = messaging.send(**rcs_message, failover: [sms_message])
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

### Working with Verify Custom Templates and Template Fragments

Verify custom templates allow you to customize the message sent to deliver an OTP to your users, rather than using the default Vonage templates. See the [Template Management Guide document](https://developer.vonage.com/en/verify/guides/custom-templates) for more information.

#### Templates

```ruby
# Get a list of all templates
template_list = verify.templates.list

# Get details of a specific template
template = verify.templates.info(template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9')

# Create a new template
verify.templates.create(name: 'my-template')

# Update an existing template
verify.templates.update(
  template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
  name: 'my-updated-template'
)

# Delete a template
verify.templates.delete(template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9')
```

#### Template Fragments

```ruby
# Get a list of template fragments for a specific template
template_fragment_list = verify.template_fragments.list(template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9')

# Get details of a specific template fragment
template_fragment = verify.template_fragments.info(
  template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
  template_fragment_id: 'c70f446e-997a-4313-a081-60a02a31dc19'
)

# Create a new template fragement
verify.template_fragments.create(
  template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
  channel: 'sms',
  locale: 'en-gb',
  text: 'Your code is: ${code}'
)

# Update an existing template fragment
verify.template_fragments.update(
  template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
  template_fragment_id: 'c70f446e-997a-4313-a081-60a02a31dc1',
  text: 'Your one-time code is: ${code}'
)

# Delete a template fragment
verify.template_fragments.delete(
  template_id: '8f35a1a7-eb2f-4552-8fdf-fffdaee41bc9',
  template_fragment_id: 'c70f446e-997a-4313-a081-60a02a31dc19'
)
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

Vonage Ruby SDK documentation: https://www.rubydoc.info/gems/vonage

Vonage Ruby SDK code examples: https://github.com/Vonage/vonage-ruby-code-snippets

Vonage APIs API reference: https://developer.vonage.com/api

## Supported APIs

The following is a list of Vonage APIs for which the Ruby SDK currently provides support:

* [Account API](https://developer.vonage.com/en/account/overview)
* [Application API](https://developer.vonage.com/en/application/overview)
* [Conversation API](https://developer.vonage.com/en/conversation/overview)
* [Meetings API](https://developer.vonage.com/en/meetings/overview)
* [Messages API](https://developer.vonage.com/en/messages/overview)
* [Network Number Verification API](https://developer.vonage.com/en/number-verification/overview)
* [Network SIM Swap API](https://developer.vonage.com/en/sim-swap/overview)
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
