$(document).ready(function () {
  $('.exchange-rate').text(BuybidFrontend.ExchangeRate.JPY_TO_VND);
  $('.exchange-rate-date-update').text('25/05/2019');
  $('.transport-fee').text(BuybidFrontend.Utils.format_price(240000, null, null, '.'));

  $('.partners-container.api-streamer').each(function(index, streamer) {
    var api = $(streamer).attr('stream-api');
    var type = $(streamer).attr('stream-type');
    var order = $(streamer).attr('stream-order');
    BuybidApi.batch.get.register(api, order, function(result) {
        $(streamer).addClass('hidden')
        result.sellers.forEach(function(seller) { 
           BuybidGui.render(streamer, type, {
                id: seller.id,
                name: seller.name,
                url: seller.url,
                category_name: seller.category? seller.category.name : 'Tổng hợp',
                image_url: seller.image ? seller.image.large_url : BuybidFrontend.SellerImageDefault.PARTNERS
            });
        });
        $(streamer).owlCarousel({
            loops: false,
            margin: 0,
            navigation: false,
            dots: false,
            autoPlay: true,
            autoPlayInterval: 4000,
            stopOnHover: false,
            items: 4,
            itemsDesktop: [1199, 3],
            itemsDesktopSmall: [974, 2],
            itemsTablet: [768, 2],
            itemsMobile: [479, 2],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria-hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria-hidden="true"></i></div>'],
        });
        $(streamer).removeClass('hidden');
    });
  });
  $('.categories-container.api-streamer').each(function(index, streamer) {
    var api = $(streamer).attr('stream-api');
    var type = $(streamer).attr('stream-type');
    var business_name = $(streamer).attr('stream-business-name');
    var order = $(streamer).attr('stream-order');
    BuybidApi.batch.get.register(api, order, function(result) {
        $(streamer).addClass('hidden')
        result.taxons.forEach(function(taxon) { 
           BuybidGui.render(streamer, type, {
                name: taxon.name,
                image_url: (taxon.image && taxon.image.normal_url) ? taxon.image.normal_url : BuybidFrontend.CategoryImageDefault[business_name.toUpperCase()],
                permalink: taxon.permalink
            });
        });        
        $(streamer).owlCarousel({
            loops: false,
            margin: 0,
            navigation: true,
            dots: false,
            items: 6,
            itemsDesktop: [974, 4],
            itemsDesktopSmall: [768, 4],
            itemsTablet: [600, 2],
            itemsMobile: [0, 1],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria-hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria-hidden="true"></i></div>']
        });
        $(streamer).removeClass('hidden');
    });
  });
  $('.products-container.api-streamer').each(function(index, streamer) {
    var api = $(streamer).attr('stream-api');
    var type = $(streamer).attr('stream-type');
    var order = $(streamer).attr('stream-order');
    BuybidApi.batch.get.register(api, order, function(result) {
        $(streamer).addClass('hidden')
        result.products.forEach(function(product) { 

          var business_name = BuybidFrontend.Utils.get_business_name(product);

          BuybidGui.render(streamer, type, {
                id: product.id,
                slug: product.slug,
                name: product.name,
                business_name: business_name,
                trends: $(streamer).attr('stream-trends'),
                price_jpy: BuybidFrontend.Utils.get_price_in(product, 'jpy'),
                price_vnd: BuybidFrontend.Utils.get_price_in(product, 'vnd', '.'),
                image_url: product.image ? product.image.large_url : BuybidFrontend.ProductImageDefault[business_name.toUpperCase()],
                seller_name: product.seller ? product.seller.name : '',
                seller_url: product.seller? product.seller.URL : '',
                seller_image_url: product.seller && product.seller.spree_image ? product.seller.spree_image.large_url : BuybidFrontend.ProductImageDefault[business_name.toUpperCase()],
          });
        });
        $(streamer).owlCarousel({
            loops: true,
            margin: 0,
            navigation: true,
            dots: false,
            autoPlay: true,
            autoPlayInterval: 4000,
            stopOnHover: true,
            items: 5,
            itemsDesktop: [974, 4],
            itemsDesktopSmall: [768, 4],
            itemsTablet: [600, 2],
            itemsMobile: [0, 1],
            navigationText: ['<div class="slider_nav_left slider_nav"><i class="fa fa-chevron-left" aria-hidden="true"></i></div>', '<div class="slider_nav_right slider_nav"><i class="fa fa-chevron-right" aria-hidden="true"></i></div>']
        });
        $(streamer).removeClass('hidden')
    });
  });

  $('.sellers-container.api-streamer').each(function(index, streamer) {
    var api = $(streamer).attr('stream-api');
    var type = $(streamer).attr('stream-type');
    var business_name = $(streamer).attr('stream-business-name') || '';
    var order = $(streamer).attr('stream-order');
    BuybidApi.batch.get.register(api, order, function(result) {
        $(streamer).addClass('hidden')
        result.sellers.forEach(function(seller) { 
           BuybidGui.render(streamer, type, {
                id: seller.id,
                slug: seller.seller_code,
                name: seller.name,
                order_count: seller.order_count,
                url: seller.URL,
                category_name: seller.category? seller.category.name : 'Tổng hợp',
                image_url: seller.image ? seller.image.large_url : BuybidFrontend.SellerImageDefault[business_name.toUpperCase()]
            });
        })
        $(streamer).removeClass('hidden');
    });
  });

  $('.product-grid.api-streamer').each(function(index, streamer) {

    var api = $(streamer).attr('stream-api');
    var order = $(streamer).attr('stream-order');
    var type = $(streamer).attr('stream-type');

    BuybidApi.batch.get.register(api, order, function(result) {
      $(streamer).addClass('hidden');
      result.products.forEach(function(product) {

        var business_name = BuybidFrontend.Utils.get_business_name(product);
        var trend_name = BuybidFrontend.Utils.get_product_trend(product);

        BuybidGui.render(streamer, type, {
            id: product.id,
            permalink: product.permalink,
            name: product.name,
            //Todo: Translate Vietnamese  to Japanese 
            slug: product.slug,
            image_url: product.image ? product.image.product_url : BuybidFrontend.ProductImageDefault['AUCTION'],
            expired_in: product.expired_in ? product.expired_in : BuybidFrontend.ProductGridData.expired_in,
            business_name: business_name ? business_name : "Auction",
            trend: trend_name, 
            bids: product.bids,
            seller_name: product.seller ? product.seller.name : 'Adidas',
            seller_image_url: (product.seller && product.seller.spree_image) ? product.seller.spree_image.product_url : BuybidFrontend.ProductImageDefault['AUCTION'],
            price_jpy: product.display_price,
            price_vnd: BuybidFrontend.Utils.get_price_in(product, 'vnd', '.'),
        })
      })
      $(streamer).removeClass('hidden');
    });
  });

  BuybidApi.batch.get.execute();
});