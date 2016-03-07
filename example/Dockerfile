# An example Dockerfile, used by circle.yml
FROM smoll/browser-rb

ENV CODE_HOME /code
RUN mkdir -p $CODE_HOME
WORKDIR $CODE_HOME

# So we can bundle in a cache-efficient way
COPY Gemfile* $CODE_HOME/

RUN bundle install && \

    # Ensures chromedriver binary is downloaded, via chromedriver-helper gem, at build-time instead of run-time
    chromedriver --version

# Copy the rest of our code
COPY . $CODE_HOME/
