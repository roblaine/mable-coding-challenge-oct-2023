# frozen_string_literal: true

require "simple_banking/account_handler"
require "simple_banking/errors"

RSpec.describe AccountHandler do
  @default_opening_balance = 0.0
  @default_acc_id = "1234123412341234"

  before(:each) do
    @ac = AccountHandler.new
  end

  describe "store/2" do
    it "does open an account with id & balance returning the balance" do
      opening_balance = 100.00

     expect(@ac.store(@default_acc_id, opening_balance)).to eql(opening_balance)
    end
    
    it "does accept integers as account ids" do
      acc_ids = %w["0000000000000000", "1000000000000000", "2000000000000000"]
      
      acc_ids.map { |id| @ac.store(id, @default_opening_balance) }
      
      expect(@ac.keys.length).to eql(acc_ids.length)
    end
    
    it "does not accept account ids with invalid characters" do
      invalid_acc_id = "ABCDEFGH12341234"
      
      @ac.store(invalid_acc_id, @default_opening_balance)
    end
    
    it "does not store the same account id twice" do
      @ac.store(@default_acc_id, @default_opening_balance)
      @ac.store(@default_acc_id, @default_opening_balance)
      
      expect(@ac.keys.length).to eq(1)
    end
  end

  describe "read/1" do
    it "does read the account balance of a valid account" do
      @ac.store(@default_acc_id, @default_opening_balance)
      
      expect(@ac.read(acc_id)).to eql(@default_opening_balance)
    end

    it "does not read the account balance of a non-existant account" do
      expect(@ac.read(@default_acc_id)).to eql(nil)
    end
  end

  describe "withdraw/2" do
    it "does withdraw an amount from an account" do
      opening_balance = 100.0
      withdraw = 30.0

      @ac.store(@default_acc_id, opening_balance)
      @ac.withdraw(@default_acc_id, withdraw)
      new_balance = @ac.read(@default_acc_id)
      
      expect(new_balance).to eql(opening_balance - withdraw)
    end
    
    it "does not put an account into overdraft" do
      opening_balance = 30.0
      withdraw = 100.0

      @ac.store(@default_acc_id, opening_balance)
      
      expect{ @ac.withdraw(@default_acc_id, withdraw) }.to raise_error(Errors::OverDraftError)
      expect(@ac.read(@default_acc_id)).to eql(opening_balance)
    end
  end
  
  describe "deposit/2" do
    it "does deposit a value into a valid account id" do
      opening_balance = 100.0

      @ac.store(@default_acc_id, opening_balance)
      @ac.deposit(@default_acc_id, deposit)
      
      expect(@ac.read(@default_acc_id)).to eql(opening_balance + deposit)    
    end

    it "does not deposit to an account that does not exist" do
      expect{ @ac.deposit("9999999999999999", 1.0) }.to raise_error(Errors::AccountMissingError)    
    end
  end

  describe "transfer/3" do
    it "does transfer funds from one account to another" do
      
    end
    
    it "does not transfer funds if it would leave the account in overdraft" do
      
    end
  end

  describe "has_balance/2" do
    it "does return true if the account has required funds" do

    end

    it "does not return true if the account hasn't required funds" do

    end
  end
end

