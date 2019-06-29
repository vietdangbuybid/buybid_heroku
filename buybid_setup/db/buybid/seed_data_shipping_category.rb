ActiveRecord::Base.transaction do
  shipping_data = [
    {
      name: 'NA',
    },
    {
      name: 'freeship' 
    },
    {
      name: 'fee_applied',
    }
  ]
  shipping_data.each do |data|
    new_cat =  Spree::ShippingCategory.first_or_create(data)
    if new_cat.save
      p "Success!"
    else
      p "Failure #{new_cat.errors.full_messages}"
    end
  end
end