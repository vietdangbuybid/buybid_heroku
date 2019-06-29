#  product 

# Create elasticsearch indexes from the designated mapping 
Spree::Product.__elasticsearch__.create_index!
# Index the first product
Spree::Product.first.__elasticsearch__.index_document
# Import data from the db into Spree::Product
Spree::Product.__elasticsearch__.import
