_ = require "lodash"
Promise = require "bluebird"

AzureSearch = require "azure-search"

module.exports =
  class Search

    constructor: ({ url, key, @index, @facets }) ->
      @client = Promise.promisifyAll new AzureSearch({ url, key }), multiArgs: true

    save: (docs) ->
      @client.updateOrUploadDocumentsAsync @index, docs

    find: (query = {}) ->
      @client.searchAsync @index, _.merge({ @facets, count: true }, query)
      .spread (items, response) ->
        __omitType = _.partialRight (value, key) -> _.endsWith key, "@odata.type"
        next = __omitType response["@search.nextPageParameters"]
        facets = __omitType response["@search.facets"]
        count = response["@odata.count"]

        {
          items
          facets
          next
          count
        }