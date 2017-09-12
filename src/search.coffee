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
        __ignoreType = (value, key) -> _.endsWith key, "@odata.type"
        next = _(response["@search.nextPageParameters"]).omit(__ignoreType).value()
        facets = _(response["@search.facets"]).omit(__ignoreType).pairs().map(({ key, value }) -> { key, value }).value()
        count = response["@odata.count"]

        { items, facets, next, count }