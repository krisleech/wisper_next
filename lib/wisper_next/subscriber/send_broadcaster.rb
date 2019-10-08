# Default synchronous broadcaster which sends event to subscriber
#
# @api private
module WisperNext
  class Subscriber
    class SendBroadcaster
      def self.call(subscriber, event_name, payload)
        subscriber.public_send(event_name, payload)
      end
    end
  end
end
