# frozen_string_literal: true

require_relative "./errors"

class AccountHandler
  def initialize(init_hash=nil)
    @accounts = init_hash ||= Hash.new
  end

  def deposit(_a, _v)
  end

  def read(_a)
    @accounts[_a]
  end

  def open_acc(account_id, opening_balance)
    begin
      # validate account_id first
      case self.valid_account_id(account_id) and self.unique_account_id(account_id)
      when false
        raise Errors::InvalidAccountId
      else
        @accounts[account_id] = opening_balance
        opening_balance
      end
    rescue err=Errors::InvalidAccountId
      puts err.new().exception(account_id)
      account_id
    end
  end

  def transfer(_a, _r, _v)
    case self.has_balance?(_a, _v)
    when false
      raise Errors::OverDraftError
    else
      @accounts[_a] -= _v
      @accounts[_r] += _v
    end
  end

  def withdraw(_a, _v)
    case self.has_balance?(_a, _v)
    when false
      raise Errors::OverDraftError
    else
      @accounts[_a] -= _v
    end
  end

  def has_balance?(_a, _v)
    self.read(_a) >= _v
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
