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

  def setup_from_file(file_path=@default_acc_path)
    begin
      self.setup_accounts(@parser.read(file_path))
    rescue Errno::ENOENT
      Errno::ENOENT
    rescue fte=Errors::FileTypeError
      puts fte.new().exception(file_path)
      file_path
    end
  end

  def setup_accounts(accounts=[])
    # open_acc/2 returns nil when successful, and the acc id when failing the attempt. We can collect these in a new list
    accounts.map { |acc_id, balance| 
      puts "#{acc_id} #{balance}"
      @accounts.open_acc(acc_id, balance) 
    }.compact()
  end
  
  def execute_transfers(path)
  end

  def report
  end

  attr_reader :accounts
end