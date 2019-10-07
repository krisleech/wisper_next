module WisperNext
  class Subscriber < Module
    def initialize(options = {})
      strict = options.fetch(:strict, true)

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
          public_send(name, payload)
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
  end
end
