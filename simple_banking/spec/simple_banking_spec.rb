# frozen_string_literal: true

require "simple_banking"
require "simple_banking/errors"

RSpec.describe SimpleBanking do
  before(:each)
    @bank = SimpleBanking.new
  end

  describe "setup_accounts/1" do
    it "does create accounts from a list of account ids and balances" do
      inputs = [
        ["1111111133334444", "42.0"], 
        ["1111222233334444", "99.0"], 
        ["1111222222224444", "110.0"]
      ]
      failures = @simple_banking.setup_accounts(inputs)
    
      expect(failures).to eql([])
    end

    it "does generate a list of failed setups" do
      inputs = [
        ["ABC", "42.0"]
      ]
      failures = @simple_banking.setup_accounts(inputs)
    
      expect(failures).to eql(["ABC"])
    end

    it "does not create duplicate accounts" do
      inputs = [
        ["1111111133334444", "42.0"], 
        ["1111111133334444", "99.0"]
      ]
      failures = @simple_banking.setup_accounts(inputs)
    
      expect(failures).to eql(["1111111133334444"])
    end
  end

  describe "execute_transfers/1" do
    it "does read a csv and performs the transfers" do
    end

    it "does generate a list of failed transfers" do
    end

    it "does not perform transfers to invalid account ids" do
    end

    it "does not perform transfers if accounts lack funds" do
    end
  end

  describe "report/0" do
    it "does generate a report of current accounts" do
    end
  end
end
