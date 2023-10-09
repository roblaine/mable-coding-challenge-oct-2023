# frozen_string_literal: true

require "simple_banking/csv_parser"
require "simple_banking/errors"

RSpec.describe CsvParser do
  before(:all) do
    @csv_parser = CsvParser.new
    @sample_path = "./spec/fixtures/sample_acc_balance.csv"
    @duplicate_path = "./spec/fixtures/duplicate_acc_balance.csv"
  end

  describe "read/1" do
    it "does raise an error on missing file" do
      expect { @csv_parser.read("./i_dont_exist.csv") }.to raise_error(Errno::ENOENT)
    end

    it "does return a list of accounts and opening balances" do
      results = @csv_parser.read(@sample_path)

      expect(results).to be_a Array
      expect(results.length).to eql(2)

      expect(results.first.first).to be_a String
      expect(results.first.last).to be_a String

      expect(results.first.first).to eql("6666234522226789")
      expect(results.first.last).to eql("5000.00")
    end
    
    
    it "does not filter out duplicates" do
      results = @csv_parser.read(@duplicate_path)

      expect(results).to be_a Array
      expect(results.length).to eql(5)
    end
  end
end
