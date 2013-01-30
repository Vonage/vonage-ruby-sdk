A Ruby wrapper for the [Nexmo](http://nexmo.com/) API
=====================================================


Installation
------------

    $ gem install nexmo


Quick start (sending a message)
-------------------------------

First you need to load up the gem and construct a Nexmo::Client object
with your API credentials, like this:

```ruby
require 'nexmo'

nexmo = Nexmo::Client.new('...API KEY...', '...API SECRET...')
```

Then you have a choice. For a "fire and forget" approach to sending a message,
use the `send_message!` method, like this:

```ruby
nexmo.send_message!({:to => '...NUMBER...', :from => 'Ruby', :text => 'Hello world'})
```

This method call returns the message id if the message was sent successfully,
or raises an exception if there was an error. If you need more robust error
handling use the `send_message` method instead, like this:

```ruby
response = nexmo.send_message({:to => '...NUMBER...', :from => 'Ruby', :text => 'Hello world'})

if response.ok?
  # do something with response.object
else
  # handle the error
end
```

This method call returns a `Nexmo::Response` object, which wraps the underlying
Net::HTTP response and adds a few convenience methods. Additional methods are
also provided for managing your account and messages.


Authenticating with OAuth (beta)
--------------------------------

If you are building an app that needs access to Nexmo resources on behalf of
other accounts then you will want to use OAuth to authenticate your requests.
Authorizing access and fetching access tokens can be achieved using the
[oauth gem](http://rubygems.org/gems/oauth) directly. You can then use an
OAuth::AccessToken object together with a Nexmo::Client object to make calls
to the API that are authenticated using OAuth. For example:

```ruby
require 'nexmo'
require 'oauth'

nexmo = Nexmo::Client.new
nexmo.oauth_access_token = OAuth::AccessToken.new(consumer, token, secret)

response = nexmo.get_balance

if response.ok?
  # do something with response.object
else
  # handle the error
end
```


Switching JSON implementations
------------------------------

By default the "json" library is used to encode request bodies and decode response
bodies. This is available in the Ruby 1.9 standard library, and as a gem for Ruby 1.8.
You can specify an alternate implementation that you wish to use explicitly when
constructing a client object. For example, to use [multi_json](https://rubygems.org/gems/multi_json):

```ruby
require 'nexmo'
require 'multi_json'

nexmo = Nexmo::Client.new('...API KEY...', '...API SECRET...', :json => MultiJson)
```

Ditto for anything that is compatible with the default implementation.


Troubleshooting
---------------

Remember that phone numbers should be specified in international format.

The Nexmo documentation contains a [list of error codes](http://nexmo.com/documentation/index.html#response_code)
which may be useful if you have problems sending a message.

Please report all bugs/issues via the GitHub issue tracker.
