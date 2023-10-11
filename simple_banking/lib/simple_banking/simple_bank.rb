# frozen_string_literal: true

require "simple_banking/account_handler"
require "simple_banking/csv_parser"
require "simple_banking/errors"
require "simple_banking/version"
require "simple_banking/logging"

include Logging

class SimpleBank
  # The actual banking occurs in AccountHandler. 
  # This module acts as an entrypoint.
  def initialize(initial_accounts=nil)
    # This is setup for testing to allow creating of accounts without relying on other methods
    @accounts = initial_accounts ||= AccountHandler.new
    @parser = CsvParser.new

    @default_acc_path = "../mable_acc_balance.csv"
    @default_transfer_path = "../mable_trans.csv"
  end

  def setup_from_file(file_path=@default_acc_path)
    begin
      self.setup_accounts(@parser.read(file_path))
    rescue Errno::ENOENT
      Errno::ENOENT
    rescue fte=Errors::FileTypeError
      logger.error(fte.new().exception(file_path))
      file_path
    end
  end

  def setup_accounts(accounts=[])
    # open_acc/2 returns nil when successful, and the acc id when failing the attempt. We can collect these in a new list
    accounts.map { |acc_id, balance| 
      # logger.info "Acc_ID: #{acc_id}, Balance: #{balance}"
      @accounts.open_acc(acc_id, balance) 
    }.compact()
  end
  
  def execute_transfers(path)
  end

  def report(account_id=nil)
    case account_id
    when nil
      @accounts.accounts.keys.map{
        |account_id| p "Account with id: #{account_id} has $#{@accounts.read(account_id)} funds."
    }.join("\n")
    else
      @accounts.read(account_id)
    end
  end

  attr_reader :accounts
end