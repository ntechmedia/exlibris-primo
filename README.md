# Exlibris::Primo
[![Gem Version](https://badge.fury.io/rb/exlibris-primo.png)](http://badge.fury.io/rb/exlibris-primo)
[![Build Status](https://api.travis-ci.org/NYULibraries/exlibris-primo.png?branch=master)](https://travis-ci.org/NYULibraries/exlibris-primo)
[![Code Climate](https://codeclimate.com/github/NYULibraries/exlibris-primo.png)](https://codeclimate.com/github/NYULibraries/exlibris-primo)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/exlibris-primo/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/exlibris-primo?branch=master)

Exlibris::Primo offers a set of classes for interacting with the ExLibris Primo APIs.

## Exlibris::Primo::Search
The Exlibris::Primo::Search class performs a search against Primo for given parameters
and exposes the set of holdings, fulltext links, table of contents links, and related links for each record retrieved.

### Example of Exlibris::Primo::Search in action
Search can search by a query
```ruby
search = Exlibris::Primo::Search.new(
  :base_url => "http://primo.institution.edu",
  :institution => "INSTITUTION", 
  :page_size => "20"
)
search.add_query_term "0143039008", "isbn", "exact"

count = search.size #=> 20+ (assuming there are 20+ records with this isbn)
facets = search.facets #=> Array of Primo facets
records = search.records #=> Array of Primo records
records.size #=> 20 (assuming there are 20+ records with this isbn)
records.each do |record_id, record|
  holdings = record.holdings #=> Array of Primo holdings
  fulltexts = record.fulltexts #=> Array of Primo full texts
  table_of_contents = record.table_of_contents #=> Array of Primo tables of contents
  related_links = record.related_links #=> Array of Primo related links
end
```

Or by a given record id

```ruby
search = Exlibris::Primo::Search.new(
  :base_url => "http://primo.institution.edu",
  :institution => "INSTITUTION"
)
search.record_id! "aleph0123456789"

count = search.size #=> 1
records = search.records #=> Array of Primo records
records.size #=> 1
record = records.first #=> Primo record
holdings = record.holdings #=> Array of Primo holdings
fulltexts = record.fulltexts #=> Array of Primo full texts
table_of_contents = record.table_of_contents #=> Array of Primo tables of contents
related_links = record.related_links #=> Array of Primo related links
```

Search has some methods for setting search params

```ruby
search = Exlibris::Primo::Search.new(
  :base_url => "http://primo.institution.edu",
  :institution => "INSTITUTION"
)
search.isbn_is "0143039008" #=> Equivalent to search.add_query_term "0143039008", "isbn", "exact"
search.title_begins_with "Travels" #=> Equivalent to search.add_query_term "Travels", "title", "begins_with"
search.creator_contains "Greene" #=> Equivalent to search.add_query_term "Greene", "creator", "contains"
```

Search can take a record id the initial hash

```ruby
search = Exlibris::Primo::Search.new(
  :base_url => "http://primo.institution.edu",
  :institution => "INSTITUTION", 
  :record_id => "aleph0123456789"
)
```
Search can also be chained using the ! version of the attribute writer

```ruby
search = Exlibris::Primo::Search.new
  .base_url!("http://primo.institution.edu")
  .institution!("INSTITUTION")
  .record_id!("aleph0123456789")
```
Or

```ruby
search = Exlibris::Primo::Search.new
  .base_url!("http://primo.institution.edu")
  .institution!("INSTITUTION")
  .title_begins_with("Travels")
  .creator_contains("Greene")
  .genre_is("Book")
```
Search can be expanded when using Ex Libris Primo Central by adding a request parameter true

```ruby
search = Exlibris::Primo::Search.new(
  :base_url => "http://primo.institution.edu",
  :institution => "INSTITUTION", 
  :page_size => "20"
)
search.add_query_term "0143039008", "isbn", "exact"
search.add_request_param('pc_availability_ind','true') # adding this line will expand the results

count = search.size #=> 20+ (assuming there are 20+ records with this isbn)
facets = search.facets #=> Array of Primo facets

records = search.records #=> Array of Primo records
records.size #=> 20 (assuming there are 20+ records with this isbn)
records.each do |record_id, record|
  holdings = record.holdings #=> Array of Primo holdings
  fulltexts = record.fulltexts #=> Array of Primo full texts
  table_of_contents = record.table_of_contents #=> Array of Primo tables of contents
  related_links = record.related_links #=> Array of Primo related links
end
```


## Exlibris::Primo::Config
Exlibris::Primo::Config allows you to specify global configuration parameter for Exlibris::Primo

```ruby
Exlibris::Primo.configure do |config|
  config.base_url = "http://primo.institution.edu"
  config.institution = "INSTITUTION"
  config.libraries = { 
    "LIB_CODE1" => "Library Decoded 1", 
    "LIB_CODE2" => "Library Decoded 2",
    "LIB_CODE3" => "Library Decoded 3" 
  }
end
```
Exlibris::Primo::Config can also read in from a YAML file that specifies the various config elements

```ruby
Exlibris::Primo.configure do |config|
  config.load_yaml "./config/primo.yml"
end
```     

## API Choice    
Currently Exlibris provides a fully featured [SOAP API](https://developers.exlibrisgroup.com/primo/apis/webservices/soap) 
and a REST API (see [Primo REST APIs](https://developers.exlibrisgroup.com/primo/apis/webservices/rest) which, supports
a [Brief Search](https://developers.exlibrisgroup.com/primo/apis/search/GET/AnSF56/p3aKzRujr9pj8qtyT3YiaSYVA/f5643222-bb88-4f3d-b2d6-5029e527c515)) 
with limited features.  To choose the API you want to use you can do this at the time of instance creation for the 
various classes (e.g.  `Exlibris::Primo::EShelf`, `Exlibris::Primo::Search`, etc) or set it globally in the `Exlibris::Primo.config`.  


### Choosing the SOAP API
To use the SOAP API you can specify it in your requests as follows:
```ruby
eshelf = Exlibris::Primo::EShelf.new(
  :api => :soap,
  :user_id => "USER_ID",
  :base_url => "http://primo.institution.edu", 
  :insitution => "INSTITUTION"
)
```
__NB:__ If you don't provided the `api` param it will default to `:soap`  

### Choosing the REST API
To use the REST API you will need to not only provide the `api` but also the `api_key`.  Specifically for search you 
will also need to include the `vid` (view id) and `tab` (e.g. default_search, quicksearch, etc) based on the configuration 
of the Exlibrish Primo instance.  Following is an example
```ruby
search = Exlibris::Primo::Search.new(
  :api => :rest,
  :api_key => 'l7xxcb1e0f7b1d9340123edf456ec789f95d',
  :vid => 'ALL',
  :tab => 'quicksearch',
  :base_url => "http://primo.institution.edu",
  :institution => "INSTITUTION"
)
```
__NB:__ If you don't provided the `api` param it will default to `:soap`  

### Choosing the API via configuration
To choose the API globally using the configuration you can use one of the two approaches:

```ruby
Exlibris::Primo.configure do |config|
  config.api :rest
end
    
# OR
 
Exlibris::Primo.config.api = :rest
```

__N.B.__: As mentioned earlier the REST API only supports a subset of the features provided by the SOAP API so global 
setting should be done with caution. 


## Exlibris::Primo::EShelf
The Exlibris::Primo::EShelf class provides methods for reading a given user's Primo eshelf
and eshelf structure as well as adding and removing records.

## Example of Exlibris::Primo::EShelf in action
```ruby
eshelf = Exlibris::Primo::EShelf.new(
  :user_id => "USER_ID",
  :base_url => "http://primo.institution.edu", 
  :insitution => "INSTITUTION"
)
records = eshelf.records
size = eshelf.size
basket_id = eshelf.basket_id
eshelf.add_records(["PrimoRecordId","PrimoRecordId2"], basket_id)
```

## Exlibris::Primo::Reviews
The Exlibris::Primo::Reviews class provides methods for reading a given user's Primo reviews
features.

## Example of Exlibris::Primo::Reviews in action
```ruby
reviews = Exlibris::Primo::Reviews.new(
  :record_id => "aleph0123456789", 
  :user_id => "USER_ID",
  :base_url => "http://primo.institution.edu", 
  :insitution => "INSTITUTION"
)
user_record_reviews = reviews.reviews #=> Array of Primo reviews
```

## Exlibris::Primo::Tags
The Exlibris::Primo::Tags class provides methods for reading a given user's Primo tags
features.

## Example of Exlibris::Primo::Tags in action
```ruby
tags = Exlibris::Primo::Tags.new(
  :record_id => "aleph0123456789", 
  :user_id => "USER_ID",
  :base_url => "http://primo.institution.edu", 
  :insitution => "INSTITUTION"
)
user_record_tags = tags.tags #=> Array of Primo tags
```
