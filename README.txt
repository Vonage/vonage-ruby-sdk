A simple wrapper for the Nexmo API (http://nexmo.com/).

Install via rubygems:

  gem install nexmo

Either require it, or add it to your Rails Gemfile:

  require 'nexmo'

  gem 'nexmo'

Construct a client with your Nexmo API credentials:

  nexmo = Nexmo::Client.new('...KEY...', '...SECRET...')

The underlying HTTP object is easily accessible. For example, you may want
to adjust the SSL verification when testing locally:

  nexmo.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

Use the send_message method to send an SMS, passing the API parameters
as a hash:

  response = nexmo.send_message({
    from: 'RUBY',
    to: '...NUMBER...',
    text: 'Hello world'
  })

If the response is successful you can access the message id, and if it's
a failure you can either check the error message or choose to raise the
error as an exception:

  if response.success?
    # store response.message_id
  elsif response.failure?
    # check response.error.message
    # raise response.error
  end

Chunky bacon.
