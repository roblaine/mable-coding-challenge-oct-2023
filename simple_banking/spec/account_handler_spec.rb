# frozen_string_literal: true

require "simple_banking/account_handler"
require "simple_banking/errors"

RSpec.describe AccountHandler do
  @default_opening_balance  = 0.0
  @default_acc_id           = "1234123412341234"
  @recipient                = "1234123412341230"

  before(:each) do
    @ac = AccountHandler.new
  end

  describe "open_acc/2" do
    it "does open an account with id & balance returning the balance" do
      opening_balance = 100.00

     expect(@ac.open_acc(@default_acc_id, opening_balance)).to eql(opening_balance)
    end
    
    it "does accept integers as account ids" do
      acc_ids = %w["0000000000000000", "1000000000000000", "2000000000000000"]
      
      acc_ids.map { |id| @ac.open_acc(id, @default_opening_balance) }
      
      expect(@ac.keys.length).to eql(acc_ids.length)
    end
    
    it "does not accept account ids with invalid characters" do
      invalid_acc_id = "ABCDEFGH12341234"
      
      @ac.open_acc(invalid_acc_id, @default_opening_balance)
    end
    
    it "does not open the same account id twice" do
      @ac.open_acc(@default_acc_id, @default_opening_balance)
      @ac.open_acc(@default_acc_id, @default_opening_balance)
      
      expect(@ac.keys.length).to eq(1)
    end
  end

  describe "read/1" do
    it "does read the account balance of a valid account" do
      accounts = AccountHandler.new({@default_acc_id => @default_opening_balance})
      
      expect(accounts.read(acc_id)).to eql(@default_opening_balance)
    end

    it "does not read the account balance of a non-existant account" do
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
    
    it "does not put an account into overdraft" do
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

    it "does not deposit to an account that does not exist" do
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
    
    it "does not transfer funds if it would leave the account in overdraft" do
      opening_balance, recipient_funds = 0.0, 100.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance, @recipient => recipient_funds})

      expect { accounts.transfer(@default_acc_id, @recipient, opening_balance) }.to raise_error(Errors::OverDraftError)

      expect(accounts.read(@default_acc_id)).to eql(opening_balance)
      expect(accounts.read(@recipient)).to eql(recipient_funds)
    end
  end

  describe "has_balance/2" do
    it "does return true if the account has the required funds" do
      opening_balance = 100.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance})

      expect(accounts.has_balance?(opening_balance)).to eql(true)
      expect(accounts.has_balance?(99.99)).to eql(true)
    end

    it "does not return true if the account hasn't required funds" do
      opening_balance = 0.0
      accounts = AccountHandler.new({@default_acc_id => opening_balance})

      expect(accounts.has_balance?(1.0)).to eql(false)
      expect(accounts.has_balance?(0.01)).to eql(false)
    end
  end
end

