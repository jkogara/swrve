The Swrve Ruby Gem
=====
[![Coverage Status](https://coveralls.io/repos/johnogara/swrve/badge.png?branch=master)](https://coveralls.io/r/johnogara/swrve?branch=master) 
[![Build Status](https://travis-ci.org/johnogara/swrve.png)](https://travis-ci.org/johnogara/swrve) 
[![Code Climate](https://codeclimate.com/repos/51eee7b989af7e75f4010537/badges/cbb3edf9ca15d0eb5df4/gpa.png)](https://codeclimate.com/repos/51eee7b989af7e75f4010537/feed)
[![Gem Version](https://badge.fury.io/rb/swrve.png)](http://badge.fury.io/rb/swrve)

A Ruby interface to the Swrve AB Testing API.

## Installation
    gem install swrve

## Quick Start Guide
Once your account is set up at Swrve.com use the following to configure Swrve

```ruby
Swrve.configure do |config|
  config.api_key = YOUR_API_KEY
  config.game_id = YOUR_GAME_ID
end
```

The Swrve API is split into two parts, Event Sending and Resource Getting

Event Sending
```ruby
Swrve.create_event(UniqueUserIdentifier, "event.name.that.occurred")
```
Resouce Getting
```ruby
Swrve.resource(UniqueUserIdentifier, "test_name_configured_at_swrve")
```

[Usage Examples]: #usage-examples

## Documentation
[http://rdoc.info/gems/swrve][documentation]

[documentation]: http://rdoc.info/gems/swrve

