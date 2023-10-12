# frozen_string_literal: true

require_relative "./account_handler"
require_relative "./csv_parser"
require_relative "./errors"
require_relative "./version"
require_relative "./logging"

include Logging

class SimpleBank
  # The actual banking occurs in AccountHandler. 
  # This module acts as an entrypoint.
  def initialize(initial_accounts=nil)
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
      @accounts.open_acc(acc_id, balance) 
    }.compact()
  end

  def execute_transfers_from_file(file_path=@default_transfer_path)
    begin
      self.execute_transfers(@parser.read(file_path))
    rescue Errno::ENOENT
      Errno::ENOENT
    rescue fte=Errors::FileTypeError
      logger.error(fte.new().exception(file_path))
      file_path
    end
  end
  
  def execute_transfers(transfers=[])
    transfers.map { |from, to, value|
      begin
        @accounts.transfer(from, to, value.to_f) # Conversion required for CSV parser as it reads the row as a series of strings
      rescue ode=Errors::OverDraftError
        logger.warn(ode.new().exception(from))
        from
      rescue iai=Errors::InvalidAccountId
        logger.error(iai.new().exception(from))
        from
      end
    }.compact()
  end

  def report(account_id=nil)
    self.generate_report(account_id)
  end

  def generate_report(account_id=nil)
    case account_id
    when nil
      @accounts.accounts.keys.map{
        |account_id| "Account with id: #{account_id} has $#{@accounts.read(account_id)} funds."
    }.join("\n")
    else
      "Account with id: #{account_id} has $#{@accounts.read(account_id)} funds."
    end
  end

  # Exposed for testing
  attr_reader :accounts
end