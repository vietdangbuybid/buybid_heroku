BuybidGui.register_template('category-slide', {
  name: 'category-slide',
  render: function(category) {
    return /*html*/`
      <div class="categories-item">
          <a class="categories-content" href="${category.permalink}" title="${category.name}">
              <div class="categories-image-container">
                <img class="image-center" src="${category.image_url}" alt="${category.name}" class="image-center" >
              </div>
              <div class="categories-name">
                <span class="text">${category.name}</span>
              </div>
          </a>
      </div>`;
  }
});

BuybidGui.register_template('hashtags-slider', {
  name: 'hashtags-slider',
  render: function(category) {
    return /*html*/`
      <div class="seller-logo-item hastags-item">
        <a href="#" title="#${category.name}" class="seller-logo-link">
            <div class="frontpage_square">
                <div class="seller-logo">
                    <img src="assets/images/products/17_20190513022457PM.jpg"
                        alt="#${category.name}">
                </div>
            </div>
            <div class="product_seller-name">#${category.name}</div>
        </a>
    </div>`
  }
});
