# Crawlbase Take-Home — [Serhii Doryba]

## How to run

````
docker compose up --build -d
````

## Check code quality
````
docker compose run --rm lint bundle exec rubocop
````


Run tests

````
docker compose run --rm test bundle exec rspec
````

<!-- The command(s) to bring everything up (e.g. `docker compose up`),
     and how to hit the endpoints once it's running. -->

## CURL sample quesry

````
curl -X POST http://localhost:3000/track \
  -H "X-Api-Token: my-secret-token"
````

## Design decisions
- REDIS: I choosed Sliding stratage because it better for owr case. At requirment we have a request to rate limit request per PERIOD - It best approach to use SLIDING strategy stored owr data. Big problem what we sole is N request from NOW per setted period. Advantage of solution to predicted Retry-After oldest request expires for end customer and get real wait time.

- NGIX setup: 
  - owr App use internal network and revers all requst to NGIX.
  - Setup and configure PUMA custome setup to ensure that we alwais use revers proxy to PUMA.
  - Instead TCP conenction at puma I setup  idle connections to have less latency and load under traffic.
  - Set real IP and schema forwarding


## Tradeoffs / what I'd do with more time

<!-- What did you intentionally skip or simplify, and what would you
     revisit before this went to production? -->

## AI tooling
  Used for this Cursor IDE, ChatGPT for get quick best solution of Tech requirments 

  - nginx configuration for create great and correct setup
  - Redis sliding storage config (lib/rate_limit/track/script.lua)
  - Do quick fix when I cought some stuck or worse error
