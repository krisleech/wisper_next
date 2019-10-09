require_relative 'desugar_arguments'

module WisperNext
  class Subscriber < Module
    DefaultBroadcasterKey = :send
    EmptyHash = {}.freeze

    def initialize(*args)
      options = DesugarArguments.(args)

      strict      = options.fetch(:strict, true)
      broadcaster = resolve_broadcaster(options)
      prefix      = options.fetch(:prefix, false)

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

    def resolve_broadcaster(options)
      if options.has_key?(:async)
        broadcaster_opts = options[:async].is_a?(Hash) ? options[:async] : EmptyHash
        broadcaster = :async
      else
        broadcaster = options.fetch(:broadcaster, DefaultBroadcasterKey)
        broadcaster_opts = EmptyHash
      end

      if broadcaster.is_a?(Symbol)
        Kernel.const_get("::#{self.class.name}::#{broadcaster.to_s.capitalize}Broadcaster").new(broadcaster_opts)
      else
        broadcaster
      end
    end
  end
end

require_relative 'subscriber/send_broadcaster'
