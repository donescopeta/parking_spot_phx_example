# Parking.Umbrella

The purpose of this application is to cache the data from an external source, without querying it every request. It has an adjustable `refresh_period` for a resource in case the refresh resolution would be too long for a particular resource.

## Examples

* Fetch parking-spot data
```
curl --request GET \
  --url http://localhost:4000/parking_spots/534013 \
  --header 'Content-Type: application/json'
```

* Change refresh_period for parking spot 
```
curl --request PUT \
  --url http://localhost:4000/crawlers/534015 \
  --header 'Content-Type: application/json' \
  --data '{
	"refresh_period": 123
}'

```