module WisperNext
  class Subscriber < Module
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
      # maps event to another method
      #
      # @param [Symbol] event name
      #
      # @return [Object] payload
      #
      # @api public
      #
      def on_event(name, payload)
        if respond_to?(name)
          public_send(name, payload)
        else
          raise NoMethodError.new(name)
        end
      end
    end
  end
end
