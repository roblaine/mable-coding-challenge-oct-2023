# frozen_string_literal: true

require "csv"
require "simple_banking/errors"

class CsvParser
  def read(path, headers=false)
    maybe_csv_data = File.open(path) do |maybe_csv_file|
      CSV.table(maybe_csv_file, headers: headers)
    end

    if !maybe_csv_data.empty?
      maybe_csv_data.
    else
      raise Errors::FileTypeError
    end
  end
end