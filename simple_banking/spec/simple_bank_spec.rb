# frozen_string_literal: true

require "simple_banking/simple_bank"
require "simple_banking/errors"

RSpec.describe SimpleBank do
  before(:each) do
    @bank = SimpleBank.new

    @sample_csv_path = "./spec/fixtures/sample_acc_balance.csv"
    @transfers_csv_path = "./spec/fixtures/sample_transfers_balance.csv"
    @non_csv_path = "./spec/fixtures/non_csv.txt"
  end

  describe "setup_accounts/1" do
    it "does create accounts from a list of account ids and balances" do
      inputs = [
        ["1111111133334444", "42.0"],
        ["1111222233334444", "99.0"],
        ["1111222222224444", "110.0"]
      ]
      failures = @bank.setup_accounts(inputs)
    
      expect(failures).to eql([])
    end

    it "does generate a list of failed setups" do
      inputs = [
        ["ABC", "42.0"]
      ]
      failures = @bank.setup_accounts(inputs)
    
      expect(failures).to eql(["ABC"])
    end

    it "does not create duplicate accounts" do
      inputs = [
        ["1111111133334444", "42.0"], 
        ["1111111133334444", "99.0"]
      ]
      failures = @bank.setup_accounts(inputs)
    
      expect(failures).to eql(["1111111133334444"])
    end
  end

  describe "setup_from_file/1" do
    it "does read a csv file and setup accounts" do
      failures = @bank.setup_from_file(@sample_csv_path)
      # account_ids from the fixture file
      expected_accounts = ["1111834566661834", "6666234522226789"]

      expect(failures).to eql([])
      expect(@bank.accounts.accounts.keys.sort).to eql(expected_accounts.sort)
    end

    it "does returns the filepath on a non csv file" do
      expect(@bank.setup_from_file(@non_csv_path)).to eql(@non_csv_path)
    end
  end

  describe "execute_transfers_from_file/1" do
    it "does read a csv file and setup accounts" do
      failures = @bank.execute_transfers_from_file(@sample_csv_path)
      # account_ids from the fixture file
      expected_accounts = ["1111834566661834", "6666234522226789"]

      expect(failures).to eql([])
      expect(@bank.accounts.accounts.keys.sort).to eql(expected_accounts.sort)
    end

    it "does returns the filepath on a non csv file" do
      expect(@bank.execute_transfers_from_file(@non_csv_path)).to eql(@non_csv_path)
    end
  end

  describe "execute_transfers/1" do
    it "does perform the transfers" do
      fail
    end

    it "does generate a list of failed transfers" do
      fail
    end

    it "does not perform transfers to invalid account ids" do
      fail
    end

    it "does not perform transfers if account lacks funds" do
      fail
    end
  end

  describe "generate_report/1" do
    it "does generate a report by id" do
      account_id, opening_balance = "1234123412341234", 100.0

      acc_handler = AccountHandler.new({account_id => opening_balance})

      bank = SimpleBank.new(acc_handler)
      report = bank.generate_report(account_id)
      expected = "Account with id: #{account_id} has $#{opening_balance} funds."

      expect(report).to eql(expected)
    end

    it "does generate a report of all accounts" do
      account_id, account_id_2, opening_balance = "1234123412341234", "1234123412341235", 100.0

      acc_handler = AccountHandler.new({account_id => opening_balance, account_id_2 => opening_balance})
      bank = SimpleBank.new(acc_handler)

      report = bank.generate_report()
      expected = "Account with id: #{account_id} has $#{opening_balance} funds.\nAccount with id: #{account_id_2} has $#{opening_balance} funds."

      expect(report.inspect).to eql(expected.inspect)
    end
  end
end
