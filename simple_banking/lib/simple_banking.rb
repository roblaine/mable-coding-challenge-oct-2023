# frozen_string_literal: true

require_relative  "simple_banking/version"
require           "simple_banking/errors"

module SimpleBanking
  @default_acc_path = "../mable_acc_balance.csv"
  @default_transfer_path = "../mable_trans.csv"

  def setup_accounts(path=@default_acc_path)
  end
  
  def execute_transfers(path)
  end

  def report
  end
end
