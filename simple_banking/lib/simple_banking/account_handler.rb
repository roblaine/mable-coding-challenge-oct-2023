# frozen_string_literal: true

require "simple_banking/errors"
require "simple_banking/logging"

include Logging

class AccountHandler
  def initialize(init_hash=nil)
    @accounts = init_hash ||= Hash.new
  end

  def deposit(account_id, value)
    case @accounts.has_key?(account_id)
    when false
      raise Errors::AccountMissingError
      nil
    else
      @accounts[account_id] += value
    end
  end

  def read(account_id)
    @accounts[account_id]
  end

  def open_acc(account_id, opening_balance)
    begin
      case self.valid_account_id(account_id) and self.unique_account_id(account_id)
      when false
        err = Errors::InvalidAccountId
        logger.error(err.new().exception(account_id))
        raise err
      else
        @accounts[account_id] = opening_balance
        nil
      end
    rescue err=Errors::InvalidAccountId
      logger.error(err.new().exception(account_id))
      account_id
    end
  end

  def transfer(account_id, recipient_account_id, value)
    case self.has_balance?(account_id, value)
    when false
      raise Errors::OverDraftError
    else
      @accounts[account_id] -= value
      @accounts[recipient_account_id] += value
    end
  end

  def withdraw(account_id, value)
    case self.has_balance?(account_id, value)
    when false
      raise Errors::OverDraftError
    else
      @accounts[account_id] -= value
    end
  end

  def has_balance?(account_id, value)
    self.read(account_id) >= value
  end
  
  # This is really only used in the tests
  attr_reader :accounts
  
  private
  def valid_account_id(account_id)
    # match only 16 digit strings
    /\d{16}/.match?(account_id)
  end

  def unique_account_id(account_id)
    !@accounts.has_key?(account_id)
  end
end
