# frozen_string_literal: true

require "simple_banking/csv_parser"
require "simple_banking/errors"

RSpec.describe CsvParser do
  @csv_parser = CsvParser.new

  describe "read/1" do
    it "should raise an error on missing file" do
      expect { @csv_parser.read(made_up_path) }.to raise_error(Errno::ENOENT)
    end
  end
end
