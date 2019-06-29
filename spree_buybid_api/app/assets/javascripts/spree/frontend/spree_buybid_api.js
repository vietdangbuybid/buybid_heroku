// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/frontend/all.js'
//= require spree/api/main

function BuybidApi () {}

BuybidApi.products = {
	base_usl_search: '/api/v1/products',
	api: function(params, q, page, per_page) {
		return BuybidApi.products.base_usl_search + "?" + $.param($.extend({
			q: q,
			page: page,
			per_page: per_page
		}, params));
	},
	api_business: function(business, params, q, page, per_page) {
		return BuybidApi.products.api($.extend({
			business: business
		}, params), q, page, per_page);
	},
	api_trend: function(trend, params, q, page, per_page) {
		return BuybidApi.products.api($.extend({
			trend: trend
		}, params), q, page, per_page);
	},
	api_brand: function(brand_id, params, q, page, per_page) {
		return BuybidApi.products.api($.extend({
			brand_id: brand_id
		}, params), q, page, per_page);
	},
	api_category: function(category_id, params, q, page, per_page) {
		return BuybidApi.products.api($.extend({
			category_id: category_id
		}, params), q, page, per_page);
	},
	hot: function(params, q, page, per_page) {
		return BuybidApi.products.api_trends('hots', params, q, page, per_page);
	},
	new: function(params, q, page, per_page) {
		return BuybidApi.products.api_trends('new', params, q, page, per_page);
	}
}

BuybidApi.ajax = function(url, data, method, type, callback) {
	headers = {}
  if(Spree.api_key) {
  	headers['X-Spree-Token'] = Spree.api_key
  }
	Spree.ajax(url, {
    type: method,
    dataType: type,
    body: data,
    headers: headers,
    success: function(result) {
      callback(result);
    },
    error: function(e) {
       throw new Error(e.responseText);
    }
  });
}

BuybidApi.get = function(url, callback) {
	BuybidApi.ajax(url, {}, 'GET', 'JSON', callback);
}

BuybidApi.post = function(url, body, callback) {
	BuybidApi.ajax(url, body, 'POST', 'JSON', callback);
}

BuybidApi.put = function(url, body, callback) {
	BuybidApi.ajax(url, body, 'PUT', 'JSON', callback);
}

BuybidApi.delete = function(url, body, callback) {
	BuybidApi.ajax(url, body, 'DELETE', 'JSON', callback);
}

BuybidApi.batch = function() {}
BuybidApi.batch.get = function() {}
BuybidApi.batch.get.jobs_map = {};

BuybidApi.batch.get.register = function(url, order, callback) {
	if(!BuybidApi.batch.get.jobs_map[order]) {
		BuybidApi.batch.get.jobs_map[order] = [];
	}
	BuybidApi.batch.get.jobs_map[order].push({
		order: order,
		url: url,
		callback: callback
	});
}

BuybidApi.batch.get.execute_job = function (job_keys, jobs_map, i) {
	if(job_keys.length <= i) {
		return;
	}
	job_key = job_keys[i];
	if(!job_keys) {
		return;
	}
	jobs = jobs_map[job_key];
	if(!jobs) {
		return;
	}
	jobs.forEach(function(job, idx, jobs_array) {
		BuybidApi.get(job.url, function(result) {
			if(idx == jobs_array.length - 1) {
				BuybidApi.batch.get.execute_job(job_keys, jobs_map, i + 1);	
			}
			job.callback(result);
		});
	});
}

BuybidApi.batch.get.execute = function() {
	jobs_map = BuybidApi.batch.get.jobs_map;
	job_keys = Object.keys(jobs_map);
	job_keys.sort();
	BuybidApi.batch.get.jobs = [];
	BuybidApi.batch.get.execute_job(job_keys, jobs_map, 0);
}
