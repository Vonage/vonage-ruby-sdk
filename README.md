Nexmo Client Library for Ruby
=============================

[Installation](#installation) | [Usage](#usage) | [Examples](#examples) | [License](#license)

This is the Ruby client library for Nexmo's API. To use it you'll
need a Nexmo account. Sign up [for free at nexmo.com][signup].


Installation
------------

To install the Ruby client library using Rubygems:

    $ gem install nexmo

Alternatively you can clone the repo or download the source.


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

Use [Nexmo's SMS API][doc_sms] to send an SMS message. 

Call the send_message method with a hash containing the message parameters. For example:

```ruby
require 'nexmo'

nexmo = Nexmo::Client.new(key: 'YOUR API KEY', secret: 'YOUR API SECRET')

response = nexmo.send_message(from: 'Ruby', to: 'YOUR NUMBER', text: 'Hello world')

if response['messages'][0]['status'].zero?
  # success!
else
  # error response
end
```


License
-------

This library is released under the [MIT License][license]

[signup]: http://nexmo.com?src=ruby-client-library
[doc_sms]: https://docs.nexmo.com/messaging/sms-api
[license]: LICENSE.txt
