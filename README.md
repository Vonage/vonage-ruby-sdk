A simple wrapper for the [Nexmo](http://nexmo.com/) API
=======================================================


Requirements
------------

Ruby 1.9; Ruby 1.8 is not currently supported.


Installation
------------

    gem install nexmo


Quick Start
-----------

```ruby
require 'nexmo'

nexmo = Nexmo::Client.new('...API KEY...', '...API SECRET...')

response = nexmo.send_message({
  from: 'RUBY',
  to: '...NUMBER...',
  text: 'Hello world'
})

if response.success?
  puts "Sent message: #{response.message_id}"
elsif response.failure?
  raise response.error
end
```


Troubleshooting
---------------

Phone numbers should be specified in international format.

The Nexmo documentation contains a [list of error codes](http://nexmo.com/documentation/index.html#response_code)
which may be useful if you have problems sending a message.


Bugs/Issues
-----------

Please report all bugs/issues via the GitHub issue tracker.
