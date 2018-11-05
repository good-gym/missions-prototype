# Helper for Service
module Service
  extend ActiveSupport::Concern

  included do
    def self.call(*args)
      new(*args).call
    end

    # Service Success class
    class Success < ServiceResponseObject
      def success?
        true
      end

      def error?
        false
      end
    end

    # Service Success class
    class Failure < Success
      def success?
        false
      end
    end

    # Service Error class
    class Error < ServiceResponseObject
      def success?
        false
      end

      def error?
        true
      end
    end
  end

  # Base Response Object for service
  class ServiceResponseObject
    attr_accessor :messages, :object, :path

    def initialize(message = nil, object: nil, path: nil)
      @messages = []
      @messages << message if message.present?
      @object = object
      @path = path
    end

    def notice
      messages&.first
    end

    def success?
      raise "No success? configured"
    end

    def failed?
      !success?
    end

    def error?
      raise "No success? configured"
    end
  end
end
