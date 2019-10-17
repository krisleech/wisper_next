require_relative 'cast_to_options'

module WisperNext
  class Subscriber < Module
    DefaultBroadcasterKey = :send
    EmptyHash = {}.freeze

    def initialize(*args)
      options = CastToOptions.(args)

      strict      = options.fetch(:strict, true)
      prefix      = options.fetch(:prefix, false)
      broadcaster = resolve_broadcaster(options)

      # maps event to another method
      #
      # @param [Symbol] event name
      #
      # @return [Object] payload
      #
      # @api public
      #
      define_method :on_event do |name, payload|
        method_name = ResolveMethod.(name, prefix)

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

    NoMethodError = Class.new(StandardError) do
      # @api private
      def initialize(event_name)
        super("No method found for #{event_name} event")
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
require_relative 'subscriber/resolve_method'
