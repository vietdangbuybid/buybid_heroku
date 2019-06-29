# frozen_string_literal: true

module BuybidFrontend
  module HomeControllerDecorator
    def index
      # A hash containing all required inforamtion for frontend display
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

  end
end

Spree::HomeController.prepend BuybidFrontend::HomeControllerDecorator
