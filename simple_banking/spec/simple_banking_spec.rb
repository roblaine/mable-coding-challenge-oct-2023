# frozen_string_literal: true

require "simple_banking"
require "simple_banking/errors"

RSpec.describe SimpleBanking do
  describe "setup_accounts/1" do
    it "does read a csv and creates accounts with balances" do
    end

    it "does generate a list of failed setups" do
    end

    it "does not create duplicate accounts" do
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
