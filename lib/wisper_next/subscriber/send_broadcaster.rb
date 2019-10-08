# Default synchronous broadcaster which sends event to subscriber
#
# @api private
module WisperNext
  class Subscriber
    class SendBroadcaster
      def initialize(options = {})
        @public_send = options.fetch(:public_send, true)
      end

      def call(subscriber, event_name, payload)
        if @public_send
          subscriber.public_send(event_name, payload)
        else
          subscriber.send(event_name, payload)
        end
      end
    end
  end
end
