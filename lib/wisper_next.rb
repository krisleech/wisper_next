require "wisper_next/version"
require 'wisper_next/publisher'

module WisperNext
  class Error < StandardError; end

  def self.publisher
    Publisher.new
  end
end
