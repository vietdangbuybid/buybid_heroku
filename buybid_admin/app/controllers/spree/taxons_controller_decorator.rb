module BuybidAdmin
  module TaxonsControllerDecorator
    def taxon_params
      params.require(:taxon).permit(permitted_taxon_attributes + [:auctions, :shops, :partners, :store])
    end
  end
end

Spree::Admin::TaxonsController.prepend BuybidAdmin::TaxonsControllerDecorator
