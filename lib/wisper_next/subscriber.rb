require_relative 'cast_to_options'

module WisperNext
  class Subscriber < Module
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
      value = options[:async] || options[:broadcaster] || SendBroadcaster.new

      case value
      when Hash
        broadcaster_for(:async, value)
      when TrueClass
        broadcaster_for(:async)
      when Symbol, String
        broadcaster_for(value)
      else
        value
      end
    end

    def broadcaster_for(name, opts = EmptyHash)
      self.class.const_get("#{name.to_s.capitalize}Broadcaster").new(opts)
    end
  end
end

require_relative 'subscriber/send_broadcaster'
require_relative 'subscriber/resolve_method'
