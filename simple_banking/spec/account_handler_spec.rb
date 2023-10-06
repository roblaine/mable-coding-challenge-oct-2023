# frozen_string_literal: true

require "simple_banking/account_handler"

RSpec.describe AccountHandler do
  @default_opening_balance = 0.0

  before(:each) do
    @ac = AccountHandler.new
  end

  it "does open a an account with id & balance returning the balance" do
    opening_balance = 100.00
    account_id = "1234123412341234"

    expected_balance = @ac.store(account_id, opening_balance)

    expect(expected_balance).to eql(opening_balance)
  end

  it "does accept integers as account ids" do
    acc_ids = %w[]"0000000000000000", "1000000000000000", "2000000000000000"]

    acc_ids.map { |id| @ac.store(id, @default_opening_balance) }

    expect(@ac.keys.length).to eql(acc_ids.length)
  end

  it "does not accept account ids with invalid characters" do
    invalid_account_id = "ABCDEFGH12341234"

    @ac.store(invalid_account_id, @default_opening_balance)
  end

  it "does read the account balance of a valid account" do

  end

  it "does not read the account balance of a non-existant account" do

  end

  it "does withdraw an amount from an account" do

  end
  
  it "does not put an account into overdraft" do

  end
  
  it "does deposit a value into a valid account id" do

  end

  it "does not deposit values if the account does not exist" do

  end
  
  it "does return true if the account has required funds" do

  end

  it "does not return true if the account hasn't required funds" do

  end
end

