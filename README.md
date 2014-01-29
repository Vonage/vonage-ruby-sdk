nexmo
=====


A Ruby wrapper for the [Nexmo API](https://www.nexmo.com/documentation/api/index.html).


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

The OAuth::Consumer object should be pointed at `rest.nexmo.com` with the `:scheme` option set to `:header`, like this:

```ruby
OAuth::Consumer.new(consumer_key, consumer_secret, {
  :site => 'https://rest.nexmo.com',
  :scheme => :header
})
```

Using the `:body` or `:query_string` authorization mechanisms is not supported.


Custom response behaviour
-------------------------

You can customise the response handling by passing a block when constructing
a Nexmo::Client object. For example, if you want to use an alternative JSON
implementation to decode response bodies, you could do this:

```ruby
nexmo = Nexmo::Client.new do |response|
  response.object = MultiJson.load(response.body) if response.ok? && response.json?
  response
end
```

This might also be useful if you prefer a different style of error handling
(e.g. raising exceptions on error and returning the response object directly
for 200 OK responses), if you need to log responses etc.


Troubleshooting
---------------

Remember that phone numbers should be specified in international format.

The Nexmo documentation contains a [list of error codes](https://docs.nexmo.com/index.php/sms-api/send-message#response_code)
which may be useful if you have problems sending a message.

Please report all bugs/issues via the GitHub issue tracker.
