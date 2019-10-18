# Global events bus
#
# @example
#
# # In application boot/initialization
# #
# EVENTS = WisperNext::Events.new
#
# EVENTS.subscribe(MyListener.new)
#
# # Domain model
# #
# class MyCommand
#   def initialize(dependencies = {})
#     @events = dependencies.fetch(:events) { EVENTS }
#   end
#
#   def call(id)
#     user = User.find(id)
#
#     if user.promote!
#       @events.broadcast('user_promoted', user: user)
#     end
#   end
# end
#
# @api public
module WisperNext
  class Events
    include ::WisperNext::Publisher.new
    public :broadcast
  end
end
