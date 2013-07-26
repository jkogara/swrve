The Swrve Ruby Gem
=====
[![Coverage Status](https://coveralls.io/repos/johnogara/swrve/badge.png?branch=master)](https://coveralls.io/r/johnogara/swrve?branch=master) 
[![Build Status](https://travis-ci.org/jkogara/swrve.png)](https://travis-ci.org/jkogara/swrve) 
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

### Events
```ruby
Swrve.session_start('user uuid')
Swrve.create_event('user uuid', "custom.event.name.that.occurred")
Swrve.purchase('user uuid', 'Item Id', 5)
...
...
Swrve.session_end('user uuid')
```

### Resources 
```ruby
json_resource = Swrve.resource('user uuid', "ab_test_name")
```

[Usage Examples]: #usage-examples

## Documentation
[http://rdoc.info/gems/swrve][documentation]

[documentation]: http://rdoc.info/gems/swrve

