## Mock::Twilio::Client
[![Gem Version](https://badge.fury.io/rb/mock-twilio.svg)](https://badge.fury.io/rb/mock-twilio)
![mock-twilio](https://github.com/schoolstatus/mock-twilio/actions/workflows/ruby.yml/badge.svg)

This is a SchoolStatus implementation to mock twilio client to perform requests to  [twilio-oai](https://github.com/twilio/twilio-oai)


# Installation

To install using bundler grab the latest stable version:

```ruby
gem install mock-twilio
```

## Requirements
- [Twilio OAI](https://github.com/twilio/twilio-oai) and [More Info](https://www.twilio.com/en-us/blog/introducing-twilios-openapi-specification-ga)

OR

- `docker compose up twilio_mock_server` [SS Twilio Mock Server](https://github.com/schoolstatus/twilio_mock_server)

## Defaults Prism

- `proxy_address = twilio_mock_server`
- `proxy_port = 4010`
- `proxy_protocol = http`

## Features Support

| Mock::Twilio::Client | Support       |
| ------------- | ------------- |
| `client.messages.create(to: "+593978613041", body: "Testing SMS", from: "+13212855389")`  | :white_check_mark:  |
| `client.messaging.v1.services("MG"+"F"*32).phone_numbers.create(phone_number_sid: @phone_number_sid)`  | :white_check_mark:  |
| `client.available_phone_numbers('US').local.list(limit: 20)`  | :white_check_mark:  |
| `client.incoming_phone_numbers.create(phone_number: "+1987654321", voice_url: "#{BASE_URL}/api/v1/twilio_calls/incoming", sms_url: "#{BASE_URL}/api/v1/twilio_requests/inbound")`  | :white_check_mark:  |
| `client.lookups.v2.phone_numbers("+14159929960").fetch(fields: :line_type_intelligence)`  | :white_check_mark:  |
| `client.calls.create(url: '<http://demo.twilio.com/docs/voice.xml>', to: '+14155551212', from: '+15017122661', status_callback: '<https://myapp.com/events>', status_callback_event: ['ringing'], status_callback_method: 'POST')`  | :white_check_mark:  |
| `client.conferences("CF"+("F")*32).participants.create(label: 'customer', early_media: true, beep: 'onEnter', status_callback: '<https://myapp.com/events>', status_callback_event: ['ringing'], record: true, from: '+15017122661', to: '+15558675310')`  | :white_check_mark:  |


## Trigger resources updates

| Mock::Twilio::Webhooks  | Support       |
| ------------- | ------------- |
| `Webhooks::Messages`  | :white_check_mark: |
| `Webhooks::InboundMessages`  | :white_check_mark: |
| `Webhooks::Calls`  | :white_check_mark:  |
| `Webhooks::CallStatusUpdates`  | :white_check_mark:  |
| `Webhooks::Conferences`  | :white_check_mark:  |
| `Webhooks::CustomerProfiles`  | :white_check_mark:  |
| `Webhooks::Brands`  | :white_check_mark:  |

## How to use
Initializer sample
```ruby
Mock::Twilio.configure do |config|
  config.host = "http://shunkan-ido-service"
  config.forwarded_host = "shunkan-ido-service"
  config.port = "3000"
  config.proto = "http"
end
```

Example
```ruby
export TWILIO_ACCOUNT_SID=ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
export TWILIO_API_KEY=SKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export TWILIO_API_SECRET=ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

mock_client = Mock::Twilio::Client.new
client = Twilio::REST::Client.new(nil, nil, nil, nil, mock_client)
client.messages.create(to: "+593978613041", body: "RB This is the ship that made the Kesssssel Run in fourteen parsecs?", from: "+13212855389")
```

## Run tests
```unix
rake test
```

## Swagger - OpenApi Issues

- Array and Boolean validations due open api formats, ie params as `status_callback_event`, `early_media`. Validations removed for them on json files.
