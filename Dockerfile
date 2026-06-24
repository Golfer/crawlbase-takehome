FROM ruby:3.3-slim AS base

ARG BUNDLE_WITHOUT="development:test"

ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
    RACK_ENV=production \
    PORT=4567

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends build-essential curl \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system --gid 1001 app \
    && useradd --system --uid 1001 --gid app --create-home app

WORKDIR /app

COPY Gemfile Gemfile.lock* ./
RUN bundle install

COPY --chown=app:app . .

USER app

EXPOSE 4567

HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=5 \
  CMD curl -fsS http://127.0.0.1:4567/health || exit 1

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "config.ru"]
