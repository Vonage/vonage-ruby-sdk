A simple wrapper for the [Nexmo](http://nexmo.com/) API
=======================================================


Installation
------------

    $ gem install nexmo


Quick Start
-----------

Use the `send_message!` for a "fire and forget" approach to sending a message:

```ruby
require 'nexmo'

nexmo = Nexmo::Client.new('...API KEY...', '...API SECRET...')

nexmo.send_message!({:to => '...NUMBER...', :from => 'Ruby', :text => 'Hello world'})
```

This method call returns the message id if the message was sent successfully,
or raises an exception if there was an error.


Handling Errors
---------------

For more robust error handling use the `send_message` method instead.
This returns the HTTP response wrapped in a `Nexmo::Response` object.


JSON Implementation
-------------------

The "json" library is used by default. This is available in the Ruby 1.9
standard library, and as a gem for Ruby 1.8.

You can specify which implementation you wish to use explicitly when
constructing a client object. For example, here is how you would use
[oj](https://rubygems.org/gems/oj):

```ruby
require 'nexmo'
require 'oj'

nexmo = Nexmo::Client.new('...API KEY...', '...API SECRET...', :json => Oj)
```

Ditto for MultiJSON, or anything that is compatible with the interface
of the default implementation.


Troubleshooting
---------------

Remember that phone numbers should be specified in international format.

The Nexmo documentation contains a [list of error codes](http://nexmo.com/documentation/index.html#response_code)
which may be useful if you have problems sending a message.

Please report all bugs/issues via the GitHub issue tracker.
