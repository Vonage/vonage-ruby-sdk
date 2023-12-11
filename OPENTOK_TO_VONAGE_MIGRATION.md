# Migration guide from OpenTok Node SDK to Vonage Video Node SDK

## Installation

You can now interact with Vonage's Video API using the `vonage` gem rather than the `opentok` gem. To do this, add the following to the Gemfile of your Ruby application:

```Gemfile
gem vonage
```

and run `bundle install`

Note: not all the Video API features are yet supported in the `vonage` gem . There is a full list of [Supported Features](supported-features) later in this document.

## Setup

Whereas the `opentok` gem used an `api_key` and `api_secret` for Authorization, the Video API implementation in the `vonage` gem uses a JWT. The SDK handles JWT generation in the background for you, but will require an `application_id` and `private_key` as credentials in order to generate the token. You can obtain these by setting up a Vonage Application, which you can create via the [Developer Dashboard](https://dashboard.nexmo.com/applications). (The Vonage Application is also where you can set other settings such as callback URLs, storage preferences, etc).

These credentials are then passed in when instantiating a `Client` object (the example below assumes you have these set as environment variables):

```ruby
client = Vonage::Client.new(
	application_id: ENV['VONAGE_APPLICATION_ID'],
	private_key: ENV['VONAGE_PRIVATE_KEY_PATH']
)
```

Calling the `Client#video` method returns a `Vonage#video` object:

```ruby
video = client.video
```

You can then use this object to interact with the Vonage Video API via various methods, for example:

- Create a Session

```ruby
session = video.create_session
```

- Retrieve a List of Archive Recordings

```ruby
archive_list = video.archives.list
```

## Changed Methods

There are some changes to methods between the `opentok` SDK and the Video API implementation in the `vonage` SDKs.

- Any positional parameters in method signatures have been replaced with keyword parameters in the `vonage` gem.
- Methods now return either a standard `Vonage::Response` object (most methods), or a class-specific `ListResponse object` (for methods which request data about multiple entities, e.g. `video.archives.list` returns a `Vonage::Archives::ListResponse` object)
- Some methods have been renamed and/or moved, for clarity and/or to better reflect what the method does. These are listed below:

| OpenTok Method Name | Vonage Video Method Name |
|---|---|
| `opentok.generate_token` | `video.generate_client_token` |
| `opentok.archives.create` | `video.archives.start` |
| `opentok.archives.find` | `video.archives.info` |
| `opentok.archives.all` | `video.archives.list` |
| `opentok.archives.stop_by_id` | `video.archives.stop` |
| `opentok.archives.delete_by_id` | `video.archives.delete` |
| `opentok.archives.layout` | `video.archives.change_layout` |
| `opentok.broadcasts.create` | `video.broadcasts.start` |
| `opentok.broadcasts.find` | `video.broadcasts.info` |
| `opentok.broadcasts.all` | `video.broadcasts.list` |
| `opentok.broadcasts.delete_by_id` | `video.broadcasts.delete` |
| `opentok.broadcasts.layout` | `video.broadcasts.change_layout` |
| `opentok.streams.find` | `video.streams.info` |
| `opentok.streams.all` | `video.streams.list` |
| `opentok.streams.layout` | `video.streams.change_layout` |
| `opentok.streams.force_mute` | `video.moderation.mute_single_stream` |
| `opentok.streams.force_mute_all` | `video.moderation.mute_multiple_streams` |
| `opentok.connections.forceDisconnect` | `video.moderation.force_disconnect` |
| `opentok.signals.send` | `video.signals.send_to_one` and `video.signals.send_to_all` |

## Sample Implementation

You can access a [Basic Sample Implementation](https://github.com/Vonage-Community/sample-video_api-sinatra-ruby_sdk) of the Vonage Video API using the Vonage Ruby SDK on our [Vonage Community](https://github.com/Vonage-Community) GitHub org.

## Supported Features

The following is a list of Vonage Video APIs and whether the SDK provides support for them:

| API   |  Supported?
|----------|:-------------:|
| Session Creation | ✅ |
| Stream Management | ✅ |
| Signaling | ✅ |
| Moderation | ✅ |
| Archiving | ✅ |
| Live Streaming Broadcasts | ✅ |
| SIP Interconnect | ✅ |
| Account Management | ❌ |
| Experience Composer | ❌ |
| Audio Connector | ❌ |
| Live Captions | ❌ |
| Custom S3/Azure buckets | ❌ |
