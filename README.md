# Crawlbase Take-Home — [Serhii Doryba]

## How to run

````
docker compose up --build -d
````

## Check code quality
````
docker compose run --rm lint bundle exec rubocop
````
<!-- The command(s) to bring everything up (e.g. `docker compose up`),
     and how to hit the endpoints once it's running. -->

## CURL sample quesry

````
curl -X POST http://localhost:3000/track \
  -H "X-Api-Token: my-secret-token"
````

## Design decisions
 

<!-- Explain your key choices:
     - Which window strategy did you use (fixed vs sliding) and why?
     - How did you enforce the limit atomically in Redis?
     - Anything notable about your nginx setup? -->

## Tradeoffs / what I'd do with more time

<!-- What did you intentionally skip or simplify, and what would you
     revisit before this went to production? -->

## AI tooling
  Used for this Cursor IDE, ChatGPT for get quick best solution of Tech requirments 

  - nginx configuration for create great and correct setup
  - Redis sliding storage config (lib/rate_limit/track/script.lua)
  - Do quick fix when I cought some stuck or worse error

<!-- Please be specific and honest:
     - Which AI tools you used, and for what.
     - One thing the agent got right that saved you time.
     - One thing it got wrong or led you astray on, and how you caught it. -->
