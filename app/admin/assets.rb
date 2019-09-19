ActiveAdmin.register Asset do
  menu parent: 'Chef resource'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  controller do
    def destroy
      @asset = Asset.find(params[:id])
      @asset.destroy
      redirect_to :back, notice: 'Asset removed'
    end
  end
end
