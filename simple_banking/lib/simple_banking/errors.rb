# frozen_string_literal: true

class Errors
  class AccountMissingError < RuntimeError
    def exception(acc_id)
      "The account with id: #{acc_id} does not exist"
    end
  end

  class InvalidAccountId < RuntimeError
    def exception(acc_id)
      "The account with id: #{acc_id} has illegal characters"
    end
  end

  class FileTypeError < RuntimeError
    def exception(file_path)
      "Invalid file type at path: #{file_path}"
    end
  end

  class OverDraftError < RuntimeError
    def exception(acc_id)
      "The account with id: #{acc_id} does not have the required funds"
    end
  end

  class ParsingError < RuntimeError
    def exception(path)
      "Failed to parse file located at #{path}"
    end
  end
end
