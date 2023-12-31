# frozen_string_literal: true

require "simple_banking/account_handler"
require "simple_banking/errors"

RSpec.describe AccountHandler do
  before(:each) do
    @ac = AccountHandler.new
    @default_opening_balance  = 0.0
    @default_acc_id           = "1234123412341234"
    @recipient                = "1234123412341230"
  end

  describe "open_acc/2" do
    it "does open an account with id & balance returning nil upon success" do
      opening_balance = 100.00

      expect(@ac.open_acc(@default_acc_id, opening_balance)).to eql(nil)
    end
    
    it "does accept integers as account ids" do
      acc_ids = ["0000000000000000", "1000000000000000", "2000000000000000"]
      failed_opens = []

      acc_ids.each { |id| 
        failed_opens.push(@ac.open_acc(id, @default_opening_balance))
      }
      failed_opens = failed_opens.compact
  
      expect(failed_opens).to eql([])
      expect(@ac.accounts.keys.length).to eql(acc_ids.length)
    end
    
    it "does not accept account ids with invalid characters, returning failing account id" do
      illegal_characters = "ABCDEFGH12341234"
      
      expect(@ac.open_acc(illegal_characters, @default_opening_balance)).to eql(illegal_characters)
      expect(@ac.accounts.keys.length).to eql(0)
    end
    
    it "does not accept account ids with invalid length, returning failing account id" do
      fifteen_digits = "111122223333444"

      expect(@ac.open_acc(fifteen_digits, @default_opening_balance)).to eql(fifteen_digits)
      expect(@ac.accounts.keys.length).to eql(0)
    end
    
    it "does not open the same account id twice" do
      @ac.open_acc("0000000000000000", @default_opening_balance)
      @ac.open_acc(@default_acc_id, @default_opening_balance)
      @ac.open_acc(@default_acc_id, @default_opening_balance)
      
      expect(@ac.accounts.keys.length).to eq(2)
    end
  end

  describe "read/1" do
    it "does read the account balance of a valid account" do
      accounts = AccountHandler.new({@default_acc_id => @default_opening_balance})
      expect(accounts.read(@default_acc_id)).to eql(@default_opening_balance)
    end

    it "does not read the account balance of a non-existent account" do
      non_acc_id = "9999999999999999"
      expect(@ac.read(non_acc_id)).to eql(nil)
    end
  end

  describe "withdraw/2" do
    it "does withdraw an amount from an account" do
      opening_balance, withdraw = 100.0, 30.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance})
      accounts.withdraw(@default_acc_id, withdraw)
      
      expect(accounts.read(@default_acc_id)).to eql(opening_balance - withdraw)
    end
    
    it "does raise_error when an account would be put into overdraft" do
      opening_balance, withdraw = 30.0, 100.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance})
      
      expect{ accounts.withdraw(@default_acc_id, withdraw) }.to raise_error(Errors::OverDraftError)
      expect(accounts.read(@default_acc_id)).to eql(opening_balance)
    end
  end
  
  describe "deposit/2" do
    it "does deposit a value into a valid account id" do
      opening_balance, deposit = 100.0, 10.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance})
      accounts.deposit(@default_acc_id, deposit)
      
      expect(accounts.read(@default_acc_id)).to eql(opening_balance + deposit)    
    end

    it "does raise_error and not deposit to an account that does not exist returning nil" do
      expect{ @ac.deposit("9999999999999999", 1.0) }.to raise_error(Errors::AccountMissingError)
    end
  end

  describe "transfer/3" do
    it "does transfer funds from one account to another" do
      opening_balance, recipient_funds = 100.0, 0.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance, @recipient => recipient_funds})

      accounts.transfer(@default_acc_id, @recipient, opening_balance)

      expect(accounts.read(@default_acc_id)).to eql(recipient_funds)
      expect(accounts.read(@recipient)).to eql(opening_balance)
    end
    
    it "does raise_error and not transfer funds if it would leave the account in overdraft" do
      opening_balance, recipient_funds = 0.0, 100.0
      transfer_amount = opening_balance + 0.01
      accounts = AccountHandler.new({@default_acc_id => opening_balance, @recipient => recipient_funds})

      expect { accounts.transfer(@default_acc_id, @recipient, transfer_amount) }.to raise_error(Errors::OverDraftError)

      expect(accounts.read(@default_acc_id)).to eql(opening_balance)
      expect(accounts.read(@recipient)).to eql(recipient_funds)
    end

    it "does not allow transfer from a non-existent account" do
      accounts = AccountHandler.new({@recipient => 1.0})

      expect{ accounts.transfer(@default_acc_id, @recipient, 0.1) }.to raise_error(Errors::InvalidAccountId)
      expect(accounts.read(@recipient)).to eql(1.0)
    end

    it "does not allow transfer to a non-existent recipient" do
      accounts = AccountHandler.new({@default_acc_id => 1.0})

      expect{ accounts.transfer(@default_acc_id, "9999999999999999", 0.1) }.to raise_error(Errors::InvalidAccountId)
      expect(accounts.read(@default_acc_id)).to eql(1.0)
    end
  end

  describe "has_balance/2" do
    it "does return true if the account has the required funds" do
      opening_balance = 100.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance})

      expect(accounts.has_balance?(@default_acc_id, opening_balance)).to eql(true)
      expect(accounts.has_balance?(@default_acc_id, 99.99)).to eql(true)
    end

    it "does not return true if the account hasn't required funds" do
      opening_balance = 0.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance})

      expect(accounts.has_balance?(@default_acc_id, 1.0)).to eql(false)
      expect(accounts.has_balance?(@default_acc_id, 0.01)).to eql(false)
    end
  end
end

