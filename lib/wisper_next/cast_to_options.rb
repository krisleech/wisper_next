module WisperNext
  # @api private
  class CastToOptions
    # @example
    #
    #   def call(*args)
    #     DesugarArguments.call(args)
    #   end
    #
    #   call(:strict, :async: false) # => { strict: true, async: false }
    #
    def self.call(arguments)
      arguments.reduce({}) do |memo, item|
        case item
        when Symbol
          memo[item] = true
        when Hash
          memo.merge!(item)
        else
          raise(ArgumentError, "Unsupported option: #{item.inspect} (#{item.class.name})")
        end

        memo
      end
    end
  end
end
