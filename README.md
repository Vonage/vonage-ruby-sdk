A simple wrapper for the [Nexmo](http://nexmo.com/) API
=======================================================


Installation
------------

Run `gem install nexmo` and `require 'nexmo'`,
or do the gemfile/bundle thing if you're using Rails.


Usage
-----

Construct a client object with your Nexmo API credentials:

```ruby
nexmo = Nexmo::Client.new('...KEY...', '...SECRET...')
```

The underlying HTTP object is easily accessible. For example, you may want
to adjust the SSL verification when testing locally:

```ruby
nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
```

Use the `send_message` method to send an SMS, passing the API
parameters as a hash:

```ruby
response = nexmo.send_message({
  from: 'RUBY',
  to: '...NUMBER...',
  text: 'Hello world'
})
```

Phone numbers should be specified in international format. If the response
is successful you can access the message id, and if it's a failure you can
retrieve the error message and/or the underlying HTTP response returned from
the server:

```ruby
if response.success?
  # store response.message_id
elsif response.failure?
  # check response.error.message and/or response.http
  # raise response.error
end
```

The Nexmo documentation contains a [list of error codes](http://nexmo.com/documentation/index.html#dlr_error)
which may be useful if you have problems sending a message.

That's all folks. Chunky bacon.
