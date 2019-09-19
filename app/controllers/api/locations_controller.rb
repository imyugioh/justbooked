module Api
  class LocationsController < ApiController
    respond_to :json
    include ApplicationHelper

    def all_states
      c = Country[:CA]
      states = c.states.map { |k, v| { short: k, long: v['name'] } }
      render json: states, root: 'states'
    end

    def states
      # states = CS.states(:ca).sort.map { |s| s[1] }
      states = Venue.where(
        listed: true
      ).where('country_code = ?', 'CA').pluck(:state_name).uniq
      render json: states.sort, root: 'states'
    end

    def cities
      # state = CS.states(:ca).invert[params[:state]].to_s
      # cities = CS.cities(state, :ca)

      cities = Venue.where(
        listed: true
      ).search_by_state_name(params[:state]).pluck(:city).uniq
      render json: cities.sort, root: 'cities'
    end

    def cities_with_states
      cities = Venue.where(listed: true).pluck(
        :city, :state_name
      ).uniq.sort.map { |e| { city: e[0], state: e[1] } }
      render json: cities, root: 'cities_with_states'
    end
  end
end
