module SpreeBuybidApi
  module ApiTaxonsControllerDecorator
    def index
      if params[:business].present?
        @taxons = Buybid::Taxon::Search.new(params).execute.
          order(created_at: :desc).page(params[:page]).per(params[:per_page])

        respond_with(@taxons, default_template: 'buybid/api/taxons/index', status: 200)
      else
        @taxons = if taxonomy
          if params[:ids]
            Spree::Taxon.includes(:children).accessible_by(current_ability, :read).where(id: params[:ids].split(','), taxonomy_id: taxonomy.id)
          else
            taxonomy.root.children
          end
        elsif params[:ids]
          Spree::Taxon.includes(:children).accessible_by(current_ability, :read).where(id: params[:ids].split(','))
        else
          Spree::Taxon.includes(:children).accessible_by(current_ability, :read).order(:taxonomy_id, :lft)
        end

        @taxons = @taxons.ransack(params[:q]).result
        @taxons = @taxons.page(params[:page]).per(params[:per_page])

        respond_with(@taxons)
      end
    end
  end
end

Spree::Api::V1::TaxonsController.prepend SpreeBuybidApi::ApiTaxonsControllerDecorator
