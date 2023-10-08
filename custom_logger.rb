require 'logger'

class CustomLogger
  class << self
    @@logger = Logger.new('logfile.log')

    def debug(message:)
      @@logger.debug(message)
    end

    def info(message:)
      @@logger.info(message)
    end

    def warn(message:)
      @@logger.warn(message)
    end

    def error(message:)
      @@logger.error(message)
    end
  end
end