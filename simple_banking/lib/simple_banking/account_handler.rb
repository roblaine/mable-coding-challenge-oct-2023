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

  def store(_a, _v)
  end

  def transfer(_a, _ra, _v)
  end

  def withdraw(_a, _v)
  end

  def has_balance?(_a, _v)
  end
end
