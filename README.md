nexmo
=====


A Ruby wrapper for the [Nexmo API](https://www.nexmo.com/documentation/api/index.html).


Installation
------------

    $ gem install nexmo


Sending a message
-----------------

Construct a Nexmo::Client object and use the #send_message method to
send a message. For example:

```ruby
require 'nexmo'

nexmo = Nexmo::Client.new(key: 'YOUR API KEY', secret: 'YOUR API SECRET')

nexmo.send_message(from: 'Ruby', to: 'YOUR NUMBER', text: 'Hello world')
```

This method call returns the message id if the message was sent successfully,
or raises an exception if there was an error. The Nexmo documentation contains
a [list of error codes](https://docs.nexmo.com/index.php/sms-api/send-message#response_code)
which may be useful for debugging exceptions.


Production environment variables
--------------------------------

Best practice for storing credentials for external services in production is
to use environment variables, as described by [12factor.net/config](http://12factor.net/config).
Nexmo::Client defaults to extracting the api key/secret it needs from the
NEXMO_API_KEY and NEXMO_API_SECRET environment variables if the key/secret
options were not specified explicitly.


Troubleshooting
---------------

Remember that phone numbers should be specified in international format.

Please report all bugs/issues via the GitHub issue tracker.
