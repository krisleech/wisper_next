require "wisper_next/version"
require 'wisper_next/publisher'
require 'wisper_next/subscriber'

module WisperNext
  class Error < StandardError; end

  def self.publisher
    Publisher.new
  end

  def self.subscriber(*args)
    Subscriber.new(*args)
  end
end
