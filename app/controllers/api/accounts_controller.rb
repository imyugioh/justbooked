module Api
  class AccountsController < ApiController
    before_action :check_current_user!
    before_action :retrieve_account
    before_action :set_entity_defaults, only: %w(personal business terms_of_service)
    respond_to :json

    # def update
    #   entity = @acc.legal_entity
    #   entity_params = params['stripe']['legal_entity']
    #   entity.business_name = entity_params['business_name']
    # end

    def terms_of_service
      if params['stripe']['tos_acceptance']['accepted']
        @acc.tos_acceptance.date = Time.zone.now.to_i
        @acc.tos_acceptance.ip = request.ip
        @entity.type = 'company'
      end
      update_account
    end

    def bank_account
      if request.put?
        @acc.external_account = params['stripe']['external_account']
        update_account
      elsif request.delete?
        begin
          @acc.external_accounts.retrieve(
            params['stripe']['external_account']).delete
          rescue Stripe::InvalidRequestError => e
            render json: { errors: [e.message] }, status: 400
          else
            render json: @acc
        end
      else
        render json: @acc.external_accounts
      end
    end

    def personal
      dob_params = @entity_params['dob']
      %w(first_name last_name).each do |key|
        @entity.send("#{key}=", @entity_params[key]) # if unverified?(@entity)
      end
      @entity_params['dob'].keys.each do |key|
        if dob_params[key].present? && !dob_params[key].to_s.empty?
          @entity.dob.send("#{key}=", dob_params[key])
        end
      end
      if @entity_params['personal_id_number'].present? && !@entity_params['personal_id_number'].empty?
        @entity.personal_id_number = @entity_params['personal_id_number']
      end
      update_account
    end

    def business
      @entity.type = 'company'
      @entity.business_name = @entity_params['business_name']
      # unless @entity_params['business_tax_id_provided']
      if @entity_params['business_tax_id'] && !@entity_params['business_tax_id'].empty?
        @entity.business_tax_id = @entity_params['business_tax_id']
      end
      # end
      update_account
    end

    def address
      address = @acc.legal_entity.address
      address_params = params['stripe']['legal_entity']['address']
      address.city = address_params['city']
      address.line1 = address_params['line1']
      address.postal_code = address_params['postal_code']
      address.state = address_params['state'] #if address_params['state']
      update_account
    end

    private

    def retrieve_account
      @acc = Stripe::Account.retrieve(current_account.stripe_account)
    end

    def set_entity_defaults
      @entity = @acc.legal_entity
      @entity_params = params['stripe']['legal_entity']
    end

    def unverified?(entity)
      entity.verification.status == 'unverified'
    end

    def update_account
      begin
        @acc.save
      rescue ArgumentError
        render json: { errors: [e.message] }, status: 400
      rescue Stripe::InvalidRequestError => e
        render json: { errors: [e.message] }, status: 400
      else
        render json: @acc
      end
    end
  end
end
