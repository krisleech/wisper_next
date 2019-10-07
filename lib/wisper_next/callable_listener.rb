# Wraps a callable (e.g. block) so it can be subscribed as a listener
#
# @api private
#
module WisperNext
  class CallableListener
    attr_reader :event_name, :callable

    def initialize(event_name, callable)
      @event_name  = event_name
      @callable    = callable
      freeze
    end

    def on_event(name, payload)
      if name == @event_name
        @callable.call(payload)
      end
    end

    def ==(other)
      other.is_a?(self.class) && other.event_name == @event_name && other.callable == @callable
    end
  end
end
