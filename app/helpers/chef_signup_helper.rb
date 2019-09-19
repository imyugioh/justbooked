module ChefSignupHelper

  def time_selected(s_time)
    string_time = s_time.to_s
    string_time = string_time.rjust(4, '0') if string_time.length < 4

    if string_time.present?
      string_time = string_time.insert 2, ':'
      if s_time < 1200
        string_time = string_time + 'am'
      else
        string_time = string_time + 'pm'
      end
    else
      string_time = "10:00am"
    end

    string_time
  end

  def to_display_date(d)
    if d
      d.strftime("%d/%m/%Y")
    else
      ""
    end
  end
  
  def done_chef_info?
    @chef.id.present? ? true : false
  end

  def done_first_menu?
    @chef.menus.present? ? true : false
  end
  
  def done_payment_info?
    @chef.payment_account.present? ? true : false
  end
  
  def wizard_step_class(step_name)
    css_class = ["jb-wizard-link"]
    
    if step_name == step
      css_class << "is-active"
    end
    
    if step_name == "chef_info"
      css_class << "is-checked" if done_chef_info?
    elsif step_name == "first_menu"
      css_class << "is-checked" if done_first_menu?
    elsif step_name == "payment_info"
      css_class << "is-checked" if done_payment_info?
    end
    
    css_class.join(' ')
  end
  
  def off_schedule?(start_time, end_time)
    if start_time.to_i + end_time.to_i == 0
      true
    else
      false
    end
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

  def split(obj)
    first_half = []
    second_half = []
    full_cnt = obj.length
    
    if full_cnt == 1
      first_half = obj
      second_half = []
    elsif full_cnt > 1
      half_cnt = (full_cnt + 1) / 2
      first_half = obj.slice(0, half_cnt)  || []
      second_half = obj.slice(half_cnt, full_cnt - 1) || []
    end 
    {first_half: first_half, second_half: second_half}
  end

  def menu_count_info(menu_category_id)
    cnt = menu_count(menu_category_id)
    pluralize(cnt, 'menu')
  end
  
end