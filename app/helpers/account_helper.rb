module AccountHelper

  def account_not_valid?
    false
    # return false if controller_name == 'account'
    # return false unless stripe_account
    # !(stripe_account.present? &&
    #   stripe_account.details_submitted &&
    #   stripe_account.transfers_enabled)
  end

  def start_time(t)
    if t.nil?
      Chef::DEFAULT_START
    else
      t
    end
  end

  def end_time(t)
    if t.nil?
      Chef::DEFAULT_END
    else
      t
    end
  end

  def off_schedule?(start_time, end_time)
    if start_time.to_i + end_time.to_i == 0
      true
    else
      false
    end
  end
end
