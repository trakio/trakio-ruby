# Official trak.io Ruby Library

## Installation

Add this line to your application's Gemfile:

    gem 'trakio-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trakio-ruby

## Examples

For more indepth documentation see: http://docs.trak.io/ruby.html

### Creating an instance, and then tracking an event.
```ruby
    # create the instance
    trakio = Trakio.new 'my_api_token'
    # track my-event
    resp = trakio.track distinct_id: 'user@example.com', event: 'my-event'
    # resp will look like { 'status': 'success', 'trak_id': '12345' }
```

### Creating a default instance, and then tracking an event.
```ruby
    # set token on default instance
    Trakio.init 'my_api_token'
    # track our event
    resp = Trakio.track distinct_id: 'user@example.com', event: 'my-event'
    # resp will look like { 'status': 'success', 'trak_id': '12345' }
```

### Creating an instance and aliasing an entry
```ruby
    # set token on default instance
    Trakio.init 'my_api_token'

    resp = Trakio.alias distinct_id: 'u1@example.com', alias: ['u2@example.com']
    # resp will look like { 'status': 'success', 'trak_id': '12345', 'distinct_ids': ['u1@example.com', 'u2@example.com'] }

    # an equivilent is shown below

    resp = Trakio.alias distinct_id: 'u1@example.com', alias: 'u2@example.com'
    # resp will look like { 'status': 'success', 'trak_id': '12345', 'distinct_ids': ['u1@example.com', 'u2@example.com'] }
```

### Creating an instance and using identify
```ruby
    # set token on default instance
    Trakio.init 'my_api_token'

    resp = Trakio.identify distinct_id: 'user@example.com', properties: { name: 'Tobie' }
    # resp will look like { 'status': 'success', 'trak_id': '12345', 'distinct_ids': ['user@example.com'] }
```

### Creating an instance and using annotate
```ruby
    # set token on default instance
    Trakio.init 'my_api_token'

    resp = Trakio.annotate event: 'event', channel: 'channel'
    # resp will look like { 'status': 'success', 'trak_id': '12345', 'properties': {} }
```

## Creating and Running Tests
* Tests can be run by running the following commands `bundle exec rspec`
* Tests can be added by either adding into an existing spec file, or creating a new one.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
