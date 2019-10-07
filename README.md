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

## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/krisleech/wisper_next.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WisperNext project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/wisper_next/blob/master/CODE_OF_CONDUCT.md).
