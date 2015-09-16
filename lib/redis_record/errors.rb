module RedisRecord
  module Errors
    class WrongAttribute < StandardError
    end

    class RecordNotFound < StandardError
    end

    class RecordNotSaved < StandardError
    end
  end
end
