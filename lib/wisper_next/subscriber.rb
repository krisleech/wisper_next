module WisperNext
  class Subscriber < Module
    DefaultBroadcasterKey = :send

    def initialize(options = {})
      strict = options.fetch(:strict, true)
      broadcaster = resolve_broadcaster(options.fetch(:broadcaster, options[:async] ? :async : DefaultBroadcasterKey))

      # maps event to another method
      #
      # @param [Symbol] event name
      #
      # @return [Object] payload
      #
      # @api public
      #
      define_method :on_event do |name, payload|
        if respond_to?(name)
          broadcaster.call(self, name, payload)
        else
          if strict
            raise NoMethodError.new(name)
          else
            # no-op
          end
        end
      end
    end

    def included(descendant)
      super
      descendant.send(:include, Methods)
    end

    NoMethodError = Class.new(StandardError) do
      # @api private
      def initialize(event_name)
        super("No method found for #{event_name} event")
      end
    end

    module Methods
    end

    private

    def resolve_broadcaster(key_or_object)
      if key_or_object.is_a?(Symbol)
        Kernel.const_get("::#{self.class.name}::#{key_or_object.to_s.capitalize}Broadcaster")
      else
        key_or_object
      end
    end
  end
end

require_relative 'subscriber/send_broadcaster'
