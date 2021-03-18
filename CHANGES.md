# 7.4.0

* Added new NCCO builder functionality for constructing Voice API actions

# 7.2.0

* Replaced JWT generation with the [`nexmo-jwt` gem](https://github.com/Nexmo/nexmo-jwt-ruby).
* Bug fix: Restored ability to update `app_id` in the Numbers API with the SDK.

# 7.1.2

* Bug fix: Restore broken instantiation and SMS functionality due to earlier changes in Sorbet introduction.

# 7.1.1

* Bug fix: Client instantiation was broken in the last release from a redefinition of an object in a method check during Sorbet introduction.

# 7.1.0

* Added support for Payment Services Directive 2 (PSD2) Request: https://developer.nexmo.com/api/verify#verifyRequestWithPSD2
* Introduced strict typing to more SDK classes

# 7.0.0

**Major Release with Breaking Changes**

* Renamed the `Calls` class to `Voice`

  This is a backwards incompatible change.

* Raise exceptions for any error responses in the `NumberInsight`, `SMS` and `Verify` API classes

  This change eliminates the need for users to build custom error handling for error responses
  that come as part of a `200 OK` API response in the legacy APIs.

  This is a backwards incompatible change.

* Added support for additional environment variables

  Support has been added for:
    * `ENV['NEXMO_APPLICATION_ID']`
    * `ENV['NEXMO_PRIVATE_KEY']`
    * `ENV['NEXMO_PRIVATE_KEY_PATH']`

* Added type checking for Account and Alerts APIs

# 6.3.0

* Added `api_host` and `rest_host` config options

  Use these options to override the default hostnames:

      Nexmo.configure do |config|
        config.api_host = 'api-sg-1.nexmo.com'
        config.rest_host = 'rest-nexmo-com-xxx.curlhub.io'
      end

* Added type checking for SMS API

# 6.2.0

* Upgraded zeitwerk dependency to version 2.2 or newer

* Fixed authentication for Redact API method

* Fixed ruby 2.7 deprecation warnings

# 6.1.0

* Added support for newer signature methods

  Use the `signature_method` config option or the `NEXMO_SIGNATURE_METHOD`
  environment variable to specify a different signature method:

      Nexmo.configure do |config|
        config.signature_method = 'sha512'
      end

* Added support for error responses with description keys

# 6.0.1

* Fixed Nexmo::Conversations#record method to use the correct path

# 6.0.0

* Dropped support for older rubies

  **Required version is now Ruby 2.5.0**

* Added Nexmo.configure method for global configuration

  Use `Nexmo.configure` to specify config options globally:

      Nexmo.configure do |config|
        config.logger = Logger.new(STDOUT)
      end

  Alternatively use the Nexmo::Client#config attribute to set config options on a per client basis:

      client = Nexmo::Client.new
      client.config.logger = Logger.new(STDOUT)

  Nexmo::Client objects can still be constructed with a hash of config options as before.

* Added Nexmo::Conversations#record method for recording a conversation

* Added zeitwerk dependency to handle constant autoloading

* Changed `Nexmo::Applications` to use Application API v2 (potentially backwards incompatible)

* Changed API methods to return `Nexmo::Response` objects instead of `Nexmo::Entity` objects (potentially backwards incompatible)

* Removed the deprecated Nexmo::Client#auth_token= method

# 5.9.0

* Added YARD documentation

* Changed error handling to accept application/json problem details responses

* Changed Nexmo::Account#update to accept underscored parameter keys

# 5.8.0

* Added support for [Application API v2](https://developer.nexmo.com/api/application.v2)

# 5.7.1

* Fixed that response errors were not being raised as exceptions

  The original/correct behaviour was broken in version 5.5.0. If you are using an affected version (5.5.0, 5.6.0, or 5.7.0) you are encouraged to upgrade

# 5.7.0

* Added support for [Conversation API](https://developer.nexmo.com/api/conversation)

# 5.6.0

* Added support for [US Short Code 2FA API](https://developer.nexmo.com/api/sms/us-short-codes/2fa) (thanks @dusty)

* Added simplecov for measuring code coverage

# 5.5.0

* Added http options

  This makes it possible to configure the underlying net/http connections for
  things like timeouts, proxies, and SSL certificate settings. For example:

      client = Nexmo::Client.new({
        http: {
          read_timeout: 5,
          proxy_address: 'localhost',
          proxy_port: 8888,
          ca_file: 'certificate.pem'
        }
      })

* Improved parsing of error message details

# 5.4.0

* Added methods for Secret Management API

* Fixed debug logging of nil response bodies

# 5.3.0

* Fixed `client.files.save` raising IOError (https://github.com/Nexmo/nexmo-ruby/issues/102)

* Renamed Nexmo::Client#auth_token attribute to #token

* Dropped support for Ruby 2.0.0

# 5.2.0

* Added Redact API transaction method

# 5.1.1

* Fixed `client.applications.update` sending application/x-www-form-urlencoded instead of JSON

# 5.1.0

* Added logging functionality for requests and responses

  Use the logger option to specify a logger. For example:

      require 'logger'

      logger = Logger.new(STDOUT)

      client = Nexmo::Client.new(logger: logger)

* Added Nexmo::Client#api_key= method

* Added Nexmo::Client#api_secret= method

* Added Nexmo::Client#signature_secret= method

* Added Nexmo::Client#application_id= method

* Added Nexmo::Client#private_key= method

# 5.0.2

* Fixed pricing endpoints

# 5.0.1

* Fixed `client.numbers.buy` sending JSON instead of application/x-www-form-urlencoded

* Fixed `client.numbers.list` to support calls without any arguments

# 5.0.0

* Dropped support for Ruby 1.9

* **(breaking change)** API methods are now namespaced

  For example: `client.calls.list` instead of `client.get_calls`

* **(breaking change)** API methods now return Nexmo::Entity objects

  For example: `response.messages.first.status` instead of `response['messages'].first['status']`

* **(breaking change)** Renamed Nexmo::Client `key` option to `api_key`

* **(breaking change)** Renamed Nexmo::Client `secret` option to `api_secret`

* **(breaking change)** Renamed `Nexmo::JWT.auth_token` method to `Nexmo::JWT.generate`

* Param keys for the SMS API and Conversion API are now hyphenated for you

  For example: `status_report_req: 1` instead of `'status-report-req' => 1`

* Param keys for the Number API are now camelcased for you

  For example: `voice_callback_type: 'app'` instead of `voiceCallbackType: 'app'`

* Added new methods for update call actions (hangup, mute, unmute, earmuff, unearmuff, and transfer)

# 4.8.0

* Nexmo::Client :key and :secret args are now optional

  If you're only making calls to the Voice API you can now instantiate a client object with just an application_id and private_key. For example:

      client = Nexmo::Client.new(application_id: application_id, private_key: private_key)

* Fixed compatibility with ruby-jwt v2

* Removed legacy SNS methods

* Removed legacy USSD methods

# 4.7.0

* Added better error messages for missing credentials

* Added save_file method for downloading call recordings

# 4.6.0

* Removed deprecated get_number_insight method

* Fixed update_application method returning 400 errors

* Added get_file method for downloading call recordings

* Added auth_token accessor for specifying a JWT auth token

# 4.5.0

* Added track_message_conversion method

* Added track_voice_conversion method

* Removed deprecated methods for Verify API

# 4.4.0

* Added get_advanced_number_insight method

* Added get_standard_number_insight method

* Deprecated get_number_insight method

* Added get_advanced_async_number_insight method

* Changed basic and standard number insight methods to new NI endpoints

* Fixed formatting of user-agent header

# 4.3.1

* Fixed bug in check_signature method

# 4.3.0

* Added sns_publish method

* Added sns_subscribe method

* Added app_name and app_version options

* Added Application API methods

* Added new Voice API methods

* Added check_signature method for checking callback signatures

* Deprecated old Verify API methods

* Deprecated old Voice API methods

# 4.2.0

* Added get_sms_pricing method

* Added get_voice_pricing method

* Added get_event_alert_numbers method to get opt-in/opt-out numbers

* Added resubscribe_event_alert_number method to opt-in a number

* Added more clearly named methods for Verify API

# 4.1.0

* Added topup method

* Added update_settings method

* Added api_host option

# 4.0.0

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

# 3.1.0

* Renamed #number_search method to #get_available_numbers

* Added #control_verification_request method

# 3.0.0

* Removed :http accessor

* Changed #send_message to return full message object

* Fixed Voice API TTS methods (now on api.nexmo.com)

* Added Number Verify API methods

* Added Number Insight API method

* Added license info

# 2.0.0

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

# 1.3.0

* Added Nexmo::Client#buy_number method

* Added Nexmo::Client#cancel_number method

* Added Nexmo::Client#update_number method

* Added :host option for specifying a different hostname to connect to

# 1.2.0

* Added initializer block functionality for tweaking response behaviour

* Deprecated the :json option (use an initializer block instead)

# 1.1.0

* Added default lookup of NEXMO_API_KEY and NEXMO_API_SECRET environment variables

* Added preliminary/experimental support for [Nexmo OAuth](https://labs.nexmo.com/#oauth) (beta)

# 1.0.0

* Ruby 1.8.7 compatibility

* Rewrote Nexmo::Client#send_message

* Added Nexmo::Client#send_message! method

# 0.5.0

* Added Nexmo::Client#search_messages method

* Changed Nexmo::Response#object to return hash instead of Nexmo::Object

* Added :json option for specifying an alternate JSON implementation

# 0.4.0

* Added Nexmo::Client#get_balance method

* Added Nexmo::Client#get_country_pricing method

* Added Nexmo::Client#get_prefix_pricing method

* Added Nexmo::Client#get_account_numbers method

* Added Nexmo::Client#number_search method

* Added Nexmo::Client#get_message method

* Added Nexmo::Client#get_message_rejections method

# 0.3.1

* Fixed content type checking (thanks @dbrock)

# 0.3.0

* Fixed Nexmo::Client#send_message for unexpected HTTP responses

# 0.2.2

* Added Nexmo status code to error messages

# 0.2.1

* No significant changes

# 0.2.0

* Added Nexmo::Client#headers method

# 0.1.1

* Ruby 1.8.7 compatibility

# 0.1.0

* First version!
