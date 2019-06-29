function set_taxon_group_select (selector, maxLength = undefined) {
  function formatTaxon (taxon) {
    return Select2.util.escapeMarkup(taxon.pretty_name)
  }
  if ($(selector).length > 0) {
    $(selector).select2({
      maximumSelectionSize: maxLength,
      formatSelectionTooBig: function(limit) {
        return 'Seller can only have one main category!'
      },
      placeholder: $(selector).attr('placeholder'),
      multiple: true,
      initSelection: function (element, callback) {
        var url = Spree.url(Spree.routes.taxons_api, {
          ids: element.val(),
          taxonomy_id: $(selector).attr('taxonomy_id'),
          without_children: true,
          token: Spree.api_key
        })
        return $.getJSON(url, null, function (data) {
          return callback(data['taxons'])
        })
      },
      ajax: {
        url: Spree.routes.taxons_api,
        datatype: 'json',
        data: function (term, page) {
          return {
            taxonomy_id: $(selector).attr('taxonomy_id'),
            per_page: 50,
            page: page,
            without_children: true,
            q: {
              name_cont: term
            },
            token: Spree.api_key
          }
        },
        results: function (data, page) {
          var more = page < data.pages
          return {
            results: data['taxons'],
            more: more
          }
        }
      },
      formatResult: formatTaxon,
      formatSelection: formatTaxon
    })
  }
}

function set_taxon_select (selector) {
  set_taxon_group_select('#seller_category_taxon_ids') 
  set_taxon_group_select('#seller_main_category_taxon_id', 1) 
  set_taxon_group_select('#product_taxon_ids')
}
