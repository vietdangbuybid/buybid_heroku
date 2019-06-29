BuybidAdmin = function () {}

BuybidAdmin.Utils = function () {}

BuybidAdmin.Utils.format_price = function (n, c = 0, d = '.', t = ',') {
	var c = isNaN(c = Math.abs(c)) ? 2 : c;
	var s = n < 0 ? "-" : "";
	var i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c)));
	var j = (j = i.length) > 3 ? j % 3 : 0;

	return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

BuybidAdmin.FILE_SIZE_LIMIT = 1024 * 1024;
BuybidAdmin.FILE_COUNT_LIMIT = 10;

BuybidAdmin.CurrencyRateToVND = {
	VND: 1,
	JPY: 282,
	USD: 23410
};
