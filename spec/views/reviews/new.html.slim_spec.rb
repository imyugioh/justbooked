require 'rails_helper'

RSpec.describe "reviews/new", type: :view do
  before(:each) do
    assign(:review, Review.new(
      :user_id => 1,
      :chef_id => 1,
      :menu_id => 1,
      :rate => 1,
      :feedback => "MyString"
    ))
  end

  it "renders new review form" do
    render

    assert_select "form[action=?][method=?]", reviews_path, "post" do

      assert_select "input#review_user_id[name=?]", "review[user_id]"

      assert_select "input#review_chef_id[name=?]", "review[chef_id]"

      assert_select "input#review_menu_id[name=?]", "review[menu_id]"

      assert_select "input#review_rate[name=?]", "review[rate]"

      assert_select "input#review_feedback[name=?]", "review[feedback]"
    end
  end
end
