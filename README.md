nexmo
=====


Ruby client for the [Nexmo API](https://docs.nexmo.com/).


Installation
------------

    $ gem install nexmo


Sending a message
-----------------

Construct a Nexmo::Client object with your API credentials and call
the #send_message method. For example:

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

The Nexmo documentation contains a [list of response codes](https://docs.nexmo.com/api-ref/sms-api/response/status-codes)
which may be useful for debugging errors. Remember that phone numbers
should be specified in international format, and other country specific
restrictions may apply (e.g. US messages must originate from either a
pre-approved long number or short code).


Production environment variables
--------------------------------

Best practice for storing credentials for external services in production is
to use environment variables, as described by [12factor.net/config](http://12factor.net/config).
Nexmo::Client defaults to extracting the api key/secret it needs from the
NEXMO_API_KEY and NEXMO_API_SECRET environment variables if the key/secret
options were not specified explicitly.
