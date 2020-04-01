# iTunesCatalogLite
Lightweight iTunes Catalog Challenge

Author: Rajee Jones 👋🏾
jones.rajee@gmail.com

## Challenge:
- [x] Build an API that takes in a search term and uses that value to call the [iTunes Search API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/).
- [x] The API that you build will take the iTunes Search API and sort each of the results into categories based on media type.
- [x] The response of this API should be a JSON object, where each field are the different media types and inside each field is an array of objects
- [x] Required fields: id, name, artwork, genre, url
```
{
  "song": [{
    "id": Integer, // trackId (ID of entity) 
    "name": String, // name of entity 
    "artwork": String, // URL of the artwork 
    "genre": String, // Genre of entity
    "url": String // trackViewUrl
     },
    ],
   "feature-movie": [{
     "id": Integer, // trackId (ID of entity) 
     "name": String, // name of entity 
     "artwork": String, // URL of the artwork 
     "genre": String, // Genre of entity
     "url": String // trackViewUrl
     },
     ]
}
```
- [x] Build a view that allows a user to type in a search query and will display the results on the page
- [x] The results should be split into different sections based on the ‘kind’ of entity
- [x] If a certain “kind” section doesn’t have any entries, do not show that section
- [x] Required data to be shown on the view: picture of the artwork, name, genre, link to iTunes
- [x] Allow items to be marked as “favorites”
- [x] These favorites can be a mix of different “kinds” of entities and should always be accessible on the page (even when no search has been entered)

## Swift Packages
- [Lightweight iTunes Catalog API](https://github.com/rajeejones/iTunesCatalogLite-API)

I created my API as a Swift Package to add as a dependency 🤓


## Demo
![Demo of iTunesChallenge](https://github.com/rajeejones/iTunesCatalogLite/blob/master/iTunesChallengeDemo.gif) 
