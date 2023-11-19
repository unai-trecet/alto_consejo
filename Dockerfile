# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Update and install dependencies
RUN apt-get update -qq \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container to /alto_consejo
WORKDIR /alto_consejo

# Add the current directory contents into the container at /alto_consejo
ADD . /alto_consejo

# Install any needed packages specified in Gemfile
RUN bundle install

# Copy the entrypoint script into the container and make it executable
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run the command to start your application when the container launches
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]