# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.3
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl default-mysql-client libvips nodejs npm libpq-dev imagemagick && \
    npm install -g corepack && corepack enable && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    default-mysql-client \
    build-essential \
    libpq-dev \
    libsass-dev \
    nodejs \
    imagemagick

# Install JavaScript dependencies
ARG NODE_VERSION=16.19.0
ARG YARN_VERSION=latest
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    corepack enable && \
    rm -rf /tmp/node-build-master

# ImageMagickとlibvips、およびその他の必要な依存関係をインストール
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libvips \
        imagemagick \
        poppler-utils \
        ghostscript \
        libxml2-dev \
        libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install application gems
COPY Gemfile Gemfile.lock ./  
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
COPY package.json yarn.lock ./  
RUN yarn install --frozen-lockfile
RUN corepack enable && yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails
# PostgreSQL client をインストール
RUN apt-get update -qq && apt-get install -y postgresql-client

# Run and own only the runtime files as a non-root user for security
RUN mkdir -p db log storage tmp && \
    useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
# USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]