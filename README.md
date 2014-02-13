# Official trak.io Ruby Library

# WARNING: Work in progress, this library is incomplete, it has been published but is subject to change.

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
    resp = Trakio.track distinct_id: user@example.com', event: 'my-event'
    # resp will look like { 'status': 'success', 'trak_id': '12345' }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
