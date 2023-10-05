require 'simple_banking'

describe SimpleBanking::AccountHandler do
  it "assigns a starting balance to an account id returning the balance" do
    starting_balance = 100.00
    account_id = 1234123412341234

    expect(
      SimpleBanking::AccountHandler.store(account_id, starting_balance)
    ).to eql(starting_balance)
  end

  it "rejects accounts that contain any non-number character" do
  
  end
end

