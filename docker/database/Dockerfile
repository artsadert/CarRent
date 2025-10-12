# Use the official PostgreSQL image as the base image
FROM postgres:18

RUN apt-get update

# Install PostgreSQL extensions
RUN apt-get install -y --no-install-recommends \
  postgresql-18-postgis

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Expose the PostgreSQL port
EXPOSE 5432
