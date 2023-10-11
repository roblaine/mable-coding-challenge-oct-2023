# frozen_string_literal: true

require "simple_banking/csv_parser"
require "simple_banking/errors"

RSpec.describe CsvParser do
  before(:all) do
    @csv_parser = CsvParser.new
    @sample_csv_path = "./spec/fixtures/sample_acc_balance.csv"
    @duplicate_csv_path = "./spec/fixtures/duplicate_acc_balance.csv"
    @non_csv_path = "./spec/fixtures/non_csv.txt"
  end

  describe "read/1" do
    it "does raise an error on missing file" do
      expect { @csv_parser.read("./i_dont_exist.csv") }.to raise_error(Errno::ENOENT)
    end

    it "does return a list of accounts and opening balances" do
      results = @csv_parser.read(@sample_csv_path)

      expect(results).to be_a Array
      expect(results.length).to eql(2)

      first_result, last_result = results.first.first, results.first.last

      expect(first_result).to be_a String
      expect(last_result).to be_a String
      expect(first_result).to eql("6666234522226789")
      expect(last_result).to eql("5000.00")
    end
    
    it "does not filter out duplicates" do
      results = @csv_parser.read(@duplicate_csv_path)

      expect(results).to be_a Array
      expect(results.length).to eql(5)
    end

    it "does raise an error when given a non csv file" do
      expect{ @csv_parser.read(@non_csv_path) }.to raise_error(Errors::FileTypeError)
    end
  end
end
