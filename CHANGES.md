## [4.0.0](https://github.com/Nexmo/nexmo/tree/v4.0.0) (2016-04-15)

* Removed exception behaviour from #send_message

  This is a backwards incompatible change. You now need to check the message status code returned in the response, for example:

      response = nexmo.send_message(params)

      if response['messages'][0]['status'].zero?
        # success!
      else
        # error response
      end

* Removed deprecated number_search method (use #get_available_numbers instead)

* Added method for Number Insight Basic API

* Added method for Number Insight Standard API

* Added Nexmo::ClientError and Nexmo::ServerError classes

* Added User-Agent header to requests

* Changed license from LGPL-3.0 to MIT

## [3.1.0](https://github.com/Nexmo/nexmo/tree/v3.1.0) (2016-02-05)

* Renamed #number_search method to #get_available_numbers

* Added #control_verification_request method

## [3.0.0](https://github.com/Nexmo/nexmo/tree/v3.0.0) (2015-03-21)

* Removed :http accessor

* Changed #send_message to return full message object

* Fixed Voice API TTS methods (now on api.nexmo.com)

* Added Number Verify API methods

* Added Number Insight API method

* Added license info

## [2.0.0](https://github.com/Nexmo/nexmo/tree/v2.0.0) (2014-07-25)

* Dropped support for Ruby 1.8.7

* Removed deprecated :json option

* Removed beta OAuth functionality

* Removed initializer block functionality

* Removed positional key/secret args in favour of options

* Removed custom response class

* Removed Nexmo::Client#send_message! method

* Added Nexmo::AuthenticationError exception class

* Added USSD API methods

* Added US Shared Short Code API methods

* Added Voice API methods

## [1.3.0](https://github.com/Nexmo/nexmo/tree/v1.3.0) (2014-04-22)

* Added Nexmo::Client#buy_number method

* Added Nexmo::Client#cancel_number method

* Added Nexmo::Client#update_number method

* Added :host option for specifying a different hostname to connect to

## [1.2.0](https://github.com/Nexmo/nexmo/tree/v1.2.0) (2013-09-02)

* Added initializer block functionality for tweaking response behaviour

* Deprecated the :json option (use an initializer block instead)

## [1.1.0](https://github.com/Nexmo/nexmo/tree/v1.1.0) (2013-02-10)

* Added default lookup of NEXMO_API_KEY and NEXMO_API_SECRET environment variables

* Added preliminary/experimental support for [Nexmo OAuth](https://labs.nexmo.com/#oauth) (beta)

## [1.0.0](https://github.com/Nexmo/nexmo/tree/v1.0.0) (2012-11-16)

* Ruby 1.8.7 compatibility

* Rewrote Nexmo::Client#send_message

* Added Nexmo::Client#send_message! method

## [0.5.0](https://github.com/Nexmo/nexmo/tree/v0.5.0) (2012-11-08)

* Added Nexmo::Client#search_messages method

* Changed Nexmo::Response#object to return hash instead of Nexmo::Object

* Added :json option for specifying an alternate JSON implementation

## [0.4.0](https://github.com/Nexmo/nexmo/tree/v0.4.0) (2012-10-06)

* Added Nexmo::Client#get_balance method

* Added Nexmo::Client#get_country_pricing method

* Added Nexmo::Client#get_prefix_pricing method

* Added Nexmo::Client#get_account_numbers method

* Added Nexmo::Client#number_search method

* Added Nexmo::Client#get_message method

* Added Nexmo::Client#get_message_rejections method

## [0.3.1](https://github.com/Nexmo/nexmo/tree/v0.3.1) (2012-05-28)

* Fixed content type checking (thanks @dbrock)

## [0.3.0](https://github.com/Nexmo/nexmo/tree/v0.3.0) (2012-05-27)

* Fixed Nexmo::Client#send_message for unexpected HTTP responses

## [0.2.2](https://github.com/Nexmo/nexmo/tree/v0.2.2) (2012-01-21)

* Added Nexmo status code to error messages

## [0.2.1](https://github.com/Nexmo/nexmo/tree/v0.2.1) (2011-11-25)

* No significant changes

## [0.2.0](https://github.com/Nexmo/nexmo/tree/v0.2.0) (2011-11-16)

* Added Nexmo::Client#headers method

## [0.1.1](https://github.com/Nexmo/nexmo/tree/v0.1.1) (2011-08-30)

* Ruby 1.8.7 compatibility

## [0.1.0](https://github.com/Nexmo/nexmo/tree/v0.1.0) (2011-08-24)

* First version!
