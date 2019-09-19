require 'rails_helper'

RSpec.describe Api::CouponsController, type: :controller do
  let(:owner) { create(:user) }
  let(:client) { create(:user) }
  let(:venue) { create(:venue, user_id: owner.id) }
  let(:package) {
    create(:package, venue_id: venue.id, user_id: owner.id)
  }
  let(:coupon) { create(:coupon) }
  let(:booking) { create(:booking,
    sender_id: client.id,
    recipient_id: owner.id,
    package_id: package.id,
    package_info: package.to_json) }

  let(:user) { create(:user) }

  before do
    allow_any_instance_of(User).to receive(
      :create_stripe_customer).and_return(true)
    allow_any_instance_of(User).to receive(
      :send_confirmation_instructions).and_return(true)

    client.confirm
    sign_in(client)
  end

  describe 'GET show' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    it 'should have a current_user' do
      expect(subject.current_user).to_not eq(nil)
    end

    it 'returns coupon if valid' do
      get :show, id: coupon.name
      expect(response.status).to eq(200)
    end

    it 'returns 404 if coupon name not valid' do
      get :show, id: 'some coupon'
      expect(response.status).to eq(404)
    end

    it 'returns 404 if coupon was used by current_user' do
      UsedCoupon.create(coupon: coupon, user: client, confirmed: true)
      get :show, id: 'new discount'
      expect(response.status).to eq(404)
    end

    it 'returns 404 if coupon usage exceeded limit' do
      coupon.update_attributes(limit: 1)
      UsedCoupon.create(coupon: coupon, user: user, confirmed: true)

      get :show, id: 'new discount'
      expect(response.status).to eq(404)
    end
  end
end
