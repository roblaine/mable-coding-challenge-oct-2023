# frozen_string_literal: true

require_relative "./errors"

class AccountHandler
  def initialize(init_hash=nil)
    @accounts = init_hash ||= Hash.new
  end

  def deposit(_a, _v)
  end

  def read(_a)
  end

  def open_acc(account_id, opening_balance)
    begin
      # validate account_id first
      case self.valid_account_id(account_id) and self.unique_account_id(account_id)
      when false
        raise Errors::InvalidAccountId
      else
        @accounts[:account_id] = opening_balance
        opening_balance
      end
    rescue err=Errors::InvalidAccountId
      puts err.new().exception(account_id)
      account_id
    end
  end

  def transfer(_a, _r, _v)
  end

  def withdraw(_a, _v)
  end

  def has_balance?(_a, _v)
  end
  
  attr_reader :accounts
  
  private
  def account_id_is_numbers?(account_id)
    # If the account id cannot have each char converted to a valid integer, we should say its invalid as an account id
    !(account_id === "" || account_id.split("").map! { |digit_or_character|
      begin Integer(digit_or_character || '')
      rescue ArgumentError
        nil
      end
    }.any? { |integer_or_nil| integer_or_nil.nil? })
  end

  def valid_account_id(account_id)
    !account_id.nil? and account_id.is_a?(String) && account_id.length == 16 && self.account_id_is_numbers?(account_id)
  end

  def unique_account_id(_a)
    !@accounts.has_key?(_a)
  end
end
