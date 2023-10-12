# frozen_string_literal: true

require "csv"

require_relative "./errors"
require_relative "./logging"

include Logging

class CsvParser
  def read(path, headers=false)
    maybe_csv_data = File.open(path) do |maybe_csv_file|
      maybe_csv_string = maybe_csv_file.read
      # This would be better handled with headers: ["account_id", "balance"], which would support better validation/error checking
      # In this way, we could assure the return of floats for our values
      CSV.parse(maybe_csv_string, headers: headers)
    end

    if maybe_csv_data.first.length > 1
      maybe_csv_data
    else
      raise Errors::FileTypeError
    end
  end
end