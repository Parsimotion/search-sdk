_ = require "lodash"
Promise = require "bluebird"
retry = require "bluebird-retry"

AzureSearch = require "azure-search"

highland = "highland"
HighlandPagination = require "highland-pagination"

module.exports =
  class Search

    constructor: ({ url, key, @index, @facets }) ->
      @client = Promise.promisifyAll new AzureSearch({ url, key }), multiArgs: true

    save: (docs...) =>
      @client.updateOrUploadDocumentsAsync @index, docs

    remove: (ids...) =>
      @client.deleteDocumentsAsync @index, ids

    find: (query = {}) =>
      @client.searchAsync @index, _.merge({ @facets, count: true }, query)
      .spread (items, response) =>
        __ignoreType = (value, key) => _.endsWith key, "@odata.type"
        next = _(response["@search.nextPageParameters"]).omit(__ignoreType).value()
        facets = 
          _ response["@search.facets"]
            .omitBy __ignoreType
            .entries()
            .map ([key, value]) => { key, value }
            .value()
            
        count = response["@odata.count"]

        { items, facets, next, count }

    suggest: (query = {}) =>
      @client.suggestAsync(@index, _.merge({ suggesterName: "sg" }, query)).get "0"

    reverseStream: (query = {}, pageSize = 10) =>
      @find _.merge({ top: 0 }, query)
      .then ({ count }) =>
        _requestPage = (skip = count - pageSize) =>
          retry =>
            skip = Math.min 100000, skip # Max items to skip in search (azure limit)
          
            top = Math.min pageSize, pageSize + skip  # If skip is < 0 => pageSize + skip = remaining elements
            skip = Math.max 0, skip
            @find _.merge({ skip, top }, query)
            .then ({ items }) => {
              items,
              nextToken: if items.length == pageSize && skip > 0 then (skip - pageSize) else null
            }

        stream: new HighlandPagination(_requestPage).stream()
        count: count
