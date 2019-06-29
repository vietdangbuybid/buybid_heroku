BuybidGui.register_template('seller-grid', {
  name: 'seller-grid',
  render: function(seller) {
    return /*html*/`
      <div class="seller-item">
        <a href="${seller.url}" title="${seller.name}" class="seller-link" target="_blank">
          <div class="seller-img">
            <img class="image-center" src="${seller.image_url}" alt="${seller.name}">
          </div>
          <div class="seller-overlay"></div>
          <div class="seller-desc">
              <div class="seller-h1">${seller.name}</div>
              <p class="seller-p">${seller.category_name}</p>
              <p class="seller-p">${seller.order_count} đơn hàng</p>
          </div>
        </a>
      </div>`;
  }
});

BuybidGui.register_template('partner-slide', {
  name: 'partner-slide',
  render: function(seller) {
    return /*html*/`
      <div class="seller-logo-item">
          <a href="${seller.url}" title="${seller.name}" class="seller-logo-link">
              <div class="frontpage_square">
                  <div class="seller-logo">
                      <img src="${seller.image_url}" alt="${seller.name}" class="image-center">
                  </div>
              </div>
          </a>
      </div>`;
  }
});
