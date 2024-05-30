## Mock::Twilio::Client

This is a SchoolStatus implementation to mock twilio client to perform requests to  [twilio-oai](https://github.com/twilio/twilio-oai)


# Installation

To install using [Bundler][bundler] grab the latest stable version:

```ruby
gem 'mock-twilio', '~> 0.1.0'
```

To manually install `twilio-ruby` via [Rubygems][rubygems] simply gem install:

```bash
gem install mock-twilio
```

## Requirements

- `docker compose up twilio_mock_server`

## Defaults Prism

- `proxy_address = twilio_mock_server`
- `proxy_port = 4010`
- `proxy_protocol = http`


## Swagger - OpenApi Issues

- Array and Boolean validations due open api formats, ie params as `status_callback_event`, `early_media`. Validations removed for them on json files.
