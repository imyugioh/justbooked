class WelcomeController < ApplicationController
  def index
    @meta_title = Settings.page_title.index
  end

  def history
    @status = %x[git log --pretty=format:"%h - %an, %ar : %s" --since=1.month]
  end

  def mail_list
  end

  def terms_and_privacy
  end
end
