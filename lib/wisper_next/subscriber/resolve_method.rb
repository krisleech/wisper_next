module WisperNext
  class Subscriber
    class ResolveMethod
      def self.call(name, prefix)
        if prefix
          "on_#{name}"
        else
          name
        end
      end
    end
  end
end

