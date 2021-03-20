wget -qO- https://api.thecatapi.com/v1/images/search | jq '.[0].url'| tr -d '"' | xargs wget -O image
catimg image -w 150 -l 2 -r 2
curl -s  http://api.icndb.com/jokes/random?firstName=Chuck | jq '.value.joke'
rm image
