#!/bin/bash
echo "Exporting secret key..."
export SECRET_KEY_BASE=$(mix phx.gen.secret)

echo "Exporting SLL certs..."
export ACAB_SSL_CERT_PATH=[CERT_PATH]/fullchain.pem
export ACAB_SSL_KEY_PATH=[KEY_PATH]/privkey.pem

echo "Creating static files..."
npm run deploy --prefix ./assets
mix phx.digest

echo "Configuring database..."
export DATABASE_URL=mysql://[USERNAME]:[PASSWORD]@[IP]/[DATABASE_NAME]

echo "Setting up environment..."
mix deps.get --only prod
export MIX_ENV=prod
mix compile
mix ecto.create
mix ecto.migrate

echo "Running server..."
export PORT=80
mix phx.server
