class Buybid::Taxon::Abstract < Buybid::ModelService
  def initialize
    super(Spree::Taxon)
  end
  def execute; end
end
