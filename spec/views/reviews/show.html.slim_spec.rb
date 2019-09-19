require 'rails_helper'

RSpec.describe "reviews/show", type: :view do
  before(:each) do
    @review = assign(:review, Review.create!(
      :user_id => 1,
      :chef_id => 2,
      :menu_id => 3,
      :rate => 4,
      :feedback => "Feedback"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Feedback/)
  end
end
