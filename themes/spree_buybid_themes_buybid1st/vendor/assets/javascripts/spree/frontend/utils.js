BuybidFrontend.Utils = class {
  static format_price(n, c = 0, d = '.', t = ',') {
    var c = isNaN(c = Math.abs(c)) ? 2 : c;
    var s = n < 0 ? "-" : "";
    var i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c)));
    var j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
  };

  static get_price_in(product, coin_symbol, t) {
    coin_symbol = coin_symbol.toUpperCase();

    return this.format_price(product.price * BuybidFrontend.ExchangeRate[`JPY_TO_${coin_symbol}`], null, null, t)
        + BuybidFrontend.CoinSymbol[coin_symbol];
  };

  static get_business_name(product) {
    for (var i = 0; i < BuybidFrontend.BusinessNamesArray.length; i++) {
        if(product['buybid_' + BuybidFrontend.BusinessNamesArray[i]]) {
          return BuybidFrontend.BusinessNamesArray[i];
        }
    }
    return BuybidFrontend.BusinessNames.AUCTION; // not belong to any business
  };

  static get_product_trend(product) {
    for (var i = 0; i < BuybidFrontend.TrendNamesArray.length; i++) {
      if(product['buybid_' + BuybidFrontend.TrendNamesArray[i]]) {
        return BuybidFrontend.TrendNamesArray[i];
      }
    }
    return BuybidFrontend.TrendNames.HOT; 
  }

}
