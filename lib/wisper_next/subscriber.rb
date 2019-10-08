module WisperNext
  class Subscriber < Module
    DefaultBroadcasterKey = :send

    def initialize(options = {})
      strict = options.fetch(:strict, true)
      broadcaster = resolve_broadcaster(options.fetch(:broadcaster, options[:async] ? :async : DefaultBroadcasterKey))
      prefix = options.fetch(:prefix, false)

      # maps event to another method
      #
      # @param [Symbol] event name
      #
      # @return [Object] payload
      #
      # @api public
      #
      define_method :on_event do |name, payload|
        method_name = resolve_method_name(name, prefix)

        if respond_to?(method_name)
          broadcaster.call(self, method_name, payload)
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
      def resolve_method_name(name, prefix)
        if prefix
          "on_#{name}"
        else
          name
        end
      end
    end

    private


    def resolve_broadcaster(key_or_object)
      if key_or_object.is_a?(Symbol)
        Kernel.const_get("::#{self.class.name}::#{key_or_object.to_s.capitalize}Broadcaster").new
      else
        key_or_object
      end
    end
  end
end

require_relative 'subscriber/send_broadcaster'
