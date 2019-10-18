# WisperNext

This is the next version of Wisper. Alpha only.

## Installation

```ruby
gem 'wisper_next'
```

## Usage

### Publishing

```ruby
class MyPublisher
  include WisperNext.publisher

  def call
    broadcast(:wow, x: rand(10), y: rand(10), at: Time.now)
  end
end
```

A publisher can broadcast events, the first argument is the event name followed
by an optional payload.

### Listeners

#### Objects

```ruby
class MyListener
  def on_event(event_name, payload)
    puts "#{event_name} received with #{payload.inspect}"
  end
end
```

We can then subscribe an instance of our listener to the publisher:

```ruby
publisher = MyPublisher.new
publisher.subscribe(MyListener.new)
publisher.call
```

#### Blocks

Blocks can be subscribed to a specific event name.

```ruby
publisher = MyPublisher.new
publisher.on(:wow) { |payload| puts(payload) }
publisher.call
```

### Enhanced Listeners

By including `Wisper.subscriber` you can get additional features.

Firstly instead of `#on_event` you provide a method for every event the
listener may receive. For example if our publisher broadcasts a "user_created"
event then the listener would provide a `user_created` method which receives
the payload.

```ruby
class MyListener
  include Wisper.subscriber
  
  def user_created(payload)
    #...
  end
end
```

If the listener receives an event for which there is no method an exception
is raised.

You can opt-out of this behaviour by setting the `strict` option to false:

```ruby
include Wisper.subscriber(strict: false)
```

#### Prefixing broadcast events

The method called can be prefixed with `on_`:

```ruby
class MyListener
  include Wisper.subscriber(prefix: true)
  
  def on_user_created(payload)
    #...
  end
end
```

#### Handling Events Asynchronously

WisperNext has adapters for asynchronous event handling, please refer to
<TODO>.

```ruby
include Wisper.subscriber(async: :true)
```

If you are interested in building an async adapter and releasing it as a gem
please get in touch.

#### Passing options

If the value for an option being passed to subscriber is `true` then you can
use a symbol instead to mean the same thing.

So `WisperNext.subscriber(async: true)` and `WisperNext.subscriber(:async)` are
the same. You can pass multiple symbols with any key/values at the end,
e.g. `WisperNext.subscriber(:async, :prefix, strict: false)`.

### Global Subscriptions

```ruby
EVENTS = WisperNext::Events.new

EVENTS.subscribe(MyListener.new)

EVENTS.broadcast('user_promoted', user: user)
```

## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/krisleech/wisper_next.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WisperNext project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/wisper_next/blob/master/CODE_OF_CONDUCT.md).
