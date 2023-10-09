require "csv"

class CsvParser
  def read(path)
    CSV.read(path)
  end
end