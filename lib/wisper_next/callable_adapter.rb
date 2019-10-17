# Wraps a callable (typically a proc) so it conforms to the listener interface
#
# @api private
#
module WisperNext
  class CallableAdapter
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
      other == callable
    end
  end
end
