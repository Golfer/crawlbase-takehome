-- Sliding-window rate limit using a Redis sorted set (ZSET).
--   key:    rate:<token>          (KEYS[1])
--   member: unique request id    (ARGV[4])
--   score:  request timestamp    (ARGV[1] as `now`)
--
-- Returns { allowed_flag, count, retry_after_seconds }

local key    = KEYS[1]
local now    = tonumber(ARGV[1])
local window = tonumber(ARGV[2])
local limit  = tonumber(ARGV[3])
local member = ARGV[4]

local function prune_expired()
  -- Drop requests older than the window (score <= now - window).
  redis.call("ZREMRANGEBYSCORE", key, 0, now - window)
end

local function request_count()
  return redis.call("ZCARD", key)
end

local function seconds_until_retry()
  -- Oldest request has the lowest score; WITHSCORES returns [member, score].
  local oldest = redis.call("ZRANGE", key, 0, 0, "WITHSCORES")
  if not oldest[2] then return 1 end
  local wait = math.ceil(tonumber(oldest[2]) + window - now)
  if wait < 1 then wait = 1 end
  return wait
end

prune_expired()
local count = request_count()
if count >= limit then
  return {0, count, seconds_until_retry()}
end

redis.call("ZADD", key, now, member)
redis.call("EXPIRE", key, window)
return {1, count + 1, 0}