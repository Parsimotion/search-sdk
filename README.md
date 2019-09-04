# search-sdk

[![NPM version](https://badge.fury.io/js/search-sdk.png)](http://badge.fury.io/js/search-sdk)

[Installation instructions](https://github.com/Parsimotion/search-sdk/wiki/Installation-Instructions)

# Examples

``` javascript
const search = new AzureSearch({ 
  url :: String, 
  key :: String,
  index :: String,
  facets :: [String]
})

search.find({
  skip :: Int,
  top :: Int,
  select :: String,
  filter: String // field1 eq 'something'
}) :: {
  items :: [Object],
  count :: Int,
  facets :: [{ key: String, value: Int }]
}

```
