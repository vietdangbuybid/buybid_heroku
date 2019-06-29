
// Pre-fill all fields with previous information after loaded
BuybidSearch = function() {}

BuybidSearch.setDataAfterReloaded = function() {
  var current_params = new URLSearchParams(window.location.search);
  // Business
  $(`.filter-item-native.${current_params.get('business')}`).prop('checked', 'checked');
  // Product Code
  $('.form-control.filter-product-code-native').val(current_params.get('product_code'));
  // Seller Code
  $('.form-control.filter-seller-code-native').val(current_params.get('seller_code'));
  // Current Price
  $('.form-control.filter-item-native.current-price-from').val(current_params.get('current_price_from'));
  $('.form-control.filter-item-native.current-price-to').val(current_params.get('current_price_to'));
  // Buynow price
  $('.form-control.filter-item-native.buynow-price-from').val(current_params.get('buynow_price_from'));
  $('.form-control.filter-item-native.buynow-price-to').val(current_params.get('buynow_price_to'));
  //Expire in
  $('.form-control.filter-item-native.expire-in').val(current_params.get('expire_in'));
  //Product status
  $(`#collapse-status .filter-item-native.${current_params.get('product_status')}`).prop('checked', 'checked');
  // Seller type
  $(`#collapse-seller .filter-item-native.${current_params.get('seller_type')}`).prop('checked', 'checked');
  // Freeship
  $(`#collapse-ship .filter-item-native.${current_params.get('freeship')}`).prop('checked','checked');
  // Sort option
  $('.data-text.sort-value').text(BuybidSearch.sortDataValuesList[current_params.get('sort')]);
}

// Split the string and then rejoin them into one word
BuybidSearch.format_class_name = function() {
  return name.split(/\W+/).join('-');
}

BuybidSearch.sortDataValuesList = {
  popular: "Độ phổ biến",
  price_asc: "Giá tăng dần",
  price_desc: "Giá giảm dần",
  discontinue_on_asc: "Theo thời điểm kết thúc (tăng dần)",
  discontinue_on_desc: "Theo thời điểm kết thúc (giảm dần)",
  bids_asc: "Số lần bids (tăng dần)",
  bids_desc: "Số lần bids (giảm dần)",
}

BuybidSearch.filterBusiness = function(bizzName) {
  BuybidSearch.redirect_to("business", bizzName);
}

BuybidSearch.filterProductCode = function() {
  let productCode = $('.form-control.filter-product-code-native').val();
  BuybidSearch.redirect_to('product_code', productCode);
};

BuybidSearch.filterSellerCode = function() {
  let sellerCode = $('.form-control.filter-seller-code-native').val();
  BuybidSearch.redirect_to("seller_code", sellerCode);
}

BuybidSearch.filterCategory = function(catName) {
  BuybidSearch.redirect_to('category', catName);
}

BuybidSearch.filterCurrentPrice = function() {
  let from = $('.form-control.filter-item-native.current-price-from').val();
  let to = $('.form-control.filter-item-native.current-price-to').val();
  BuybidSearch.redirect_to("current_price", from, to);
}

BuybidSearch.filterBuynowPrice = function() {
  let from = $('.form-control.filter-item-native.buynow-price-from').val();
  let to = $('.form-control.filter-item-native.buynow-price-to').val();
  BuybidSearch.redirect_to("buynow_price", from, to);
}

BuybidSearch.filterProductStatus = function(productStatus) {
  BuybidSearch.redirect_to('product_status', productStatus);
}

BuybidSearch.filterFreeship = function(freeshipStatus) {
  BuybidSearch.redirect_to('freeship', freeshipStatus);
}

BuybidSearch.filterSellerType = function(sellerType) {
  BuybidSearch.redirect_to('seller_type',sellerType);
}

BuybidSearch.filterBrand = function(brandName) {
  BuybidSearch.redirect_to('brand', brandName);
}

BuybidSearch.filterExpiredIn = function(value) {
  var expire_in = $(".form-control.filter-item-native").children('option:selected').val();
  BuybidSearch.redirect_to('expire_in', expire_in);
}

// When removing all tags, go back to the page with only the business name
BuybidSearch.remove_all_tags = function() {
  $('.btn.btn-default.btn-xs.tags-remove-all').each(function() {
    $(".btn.btn-primary.btn-xs.tags-item").hide();
  });
  window.location = "/search?business=auction&page=1&per_page=9";
}

// Remove only one tag 
BuybidSearch.remove_tag = function(tagName) {
  BuybidSearch.redirect_to("","","",tagName);
}

// Convert the encoding URL to the correct form
BuybidSearch.fixedEncodeURI = function(str) {
    return encodeURI(str).replace(/%255B/g, '[').replace(/%255D/g, ']');
}

// Sort   
BuybidSearch.sortList = function(value) {
  BuybidSearch.redirect_to('sort', value);
}

// go to a new URL with the new search param
BuybidSearch.redirect_to = function(paramKey = "", paramVal = "", optionalVal = "", deletedParam = "") {
  let current_params = new URLSearchParams(window.location.search);
  // Delete page and per page, add those at the end to maintain order.   
  current_params.delete('page');
  current_params.delete('per_page');
  if (optionalVal) {
    current_params.delete(paramKey.concat('_from'));
    current_params.delete(paramKey.concat('_to'));
    current_params.append(paramKey.concat('_from'), paramVal);
    current_params.append(paramKey.concat('_to'), optionalVal);
  }
  // Handle optional params first 
  else if (paramKey) {
    current_params.set(paramKey,paramVal);
  }
  if (deletedParam) {
    // Currently hard code 
    if (deletedParam == 'current_price' || deletedParam == 'buynow_price') {
      current_params.delete(deletedParam.concat('_from'));
      current_params.delete(deletedParam.concat('_to'));
    }
    else {
      current_params.delete(deletedParam);
    }
  }
  current_params.append('page',1);
  current_params.append('per_page',9);
  var new_url = "/search?".concat(current_params.toString());
  window.location = BuybidSearch.fixedEncodeURI(new_url);
}

$(document).ready(function() {
  BuybidSearch.setDataAfterReloaded();
  $('.btn.btn-default.dropdown-toggle.bb-ddl-btn.sort-btn').on('change', function() {
    alert('Hello World my name is Viet Dang');
  })
})

$('sort-list.dropdown.bb-ddl.pull-right').child('.data-value.sort-value').val();
$('.data-value.sort-value').val();