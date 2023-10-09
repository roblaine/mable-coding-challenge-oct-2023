# frozen_string_literal: true

require_relative "./account_handler"
require_relative "./csv_parser"
require_relative "./errors"
require_relative "./version"

class SimpleBank
  # The actual banking occurs in AccountHandler. 
  # This module acts as an entrypoint.

  def initialize
    @accounts = AccountHandler.new
    @parser = CsvParser.new

    @default_acc_path = "../mable_acc_balance.csv"
    @default_transfer_path = "../mable_trans.csv"
  end

  def setup_accounts(path=@default_acc_path)
    begin
      account_inputs = @parser.read(path)
      # open_acc/2 returns nil when successful, and the acc id when failing the attempt. We can collect these in a new list
      failures = account_inputs.map { |acc| @accounts.open_acc(acc.first, acc.last) }
      failures.compact
    rescue Errno::ENOENT
      Errno::ENOENT
    end
  end
  
  def execute_transfers(path)
  end

  def report
  end
end