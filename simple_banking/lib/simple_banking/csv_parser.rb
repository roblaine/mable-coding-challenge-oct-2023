# frozen_string_literal: true

require "csv"

require_relative "./errors"
require_relative "./logging"

include Logging

class CsvParser
  def read(path, headers=false)
    maybe_csv_data = File.open(path) do |maybe_csv_file|
      maybe_csv_string = maybe_csv_file.read
      # TODO: Refactor to use headers: ["account_id", "balance"]
      CSV.parse(maybe_csv_string, headers: headers)
    end

    # TODO: Using the above refactor, traverse the table to use returns the rows
    if maybe_csv_data.first.length > 1
      maybe_csv_data
    else
      raise Errors::FileTypeError
    end
  end
end