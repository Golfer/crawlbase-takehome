max_threads_count = Integer(ENV.fetch("RACK_MAX_THREADS", 5))
min_threads_count = Integer(ENV.fetch("RACK_MIN_THREADS", max_threads_count))
port Integer(ENV.fetch("PORT", 4567))
environment ENV.fetch("RACK_ENV", "development")

threads min_threads_count, max_threads_count
workers Integer(ENV.fetch("WEB_CONCURRENCY", 0))

preload_app!