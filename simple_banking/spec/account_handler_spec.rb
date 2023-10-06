# frozen_string_literal: true

require "simple_banking/account_handler"

RSpec.describe AccountHandler do
  @default_opening_balance = 0.0
  @default_acc_id = "1234123412341234"

  before(:each) do
    @ac = AccountHandler.new
  end

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

  it "does read the account balance of a valid account" do
    acc_id = "1234123412341234"

    @ac.store(acc_id, @default_opening_balance)
    
    expect(@ac.read(acc_id)).to eql(@default_opening_balance)
  end

  it "does not read the account balance of a non-existant account" do
    acc_id = "1234123412341234"
    
    expect(@ac.read(acc_id)).to eql(nil)
  end

  it "does withdraw an amount from an account" do
    acc_id = "1234123412341234"
    opening_balance = 100.0
    withdraw = 30.0

    @ac.store(acc_id, opening_balance)
    @ac.withdraw(acc_id, withdraw)
    new_balance = @ac.read(acc_id)
    
    expect(new_balance).to eql(opening_balance - withdraw)
  end
  
  it "does not put an account into overdraft" do
    acc_id = "1234123412341234"
    opening_balance = 30.0
    withdraw = 100.0

    @ac.store(acc_id, opening_balance)
    overdrawn = @ac.withdraw(acc_id, withdraw)
    new_balance = @ac.read(acc_id)
    
    expect(new_balance).to eql(opening_balance)
    expect(overdrawn).to eql({:error, opening_balance})
  end
  
  it "does deposit a value into a valid account id" do

  end

  it "does not deposit values if the account does not exist" do

  end
  
  it "does return true if the account has required funds" do

  end

  it "does not return true if the account hasn't required funds" do

  end

  it "does transfer funds from one account to another" do
  
  end

  it "does not transfer funds if it would leave the account in overdraft" do

  end
end

