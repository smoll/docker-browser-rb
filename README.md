# docker-browser-rb
Docker image for running Ruby-based browser tests

## Rationale

The main objective of this repo is to serve as documentation for one possible approach for creating a relatively small (<700 MB) Docker image containing:
  * the Chrome (~181 MB) and/or Firefox (~102 MB) browser
  * Xvfb, so we can run a GUI application headlessly inside the container. We use the `headless` gem in [the example](example), which also lets us do things like [capture video](https://github.com/leonid-shevtsov/headless#capturing-video) of the running tests
  * Ruby, with build dependencies so we can install gems that require native extensions (nokogiri, etc.), inspired by [cloudgear/ruby](https://github.com/cloudgear-images/ruby)

You can literally copy & paste the Dockerfile to [take control of your Docker image dependencies](https://engineering.riotgames.com/news/taking-control-your-docker-image), if you don't want to rely on a public untrusted image.

The aforementioned example is also cleverly leveraged by the CircleCI build to validate whether this image is doing what it is supposed to:

[![Circle CI](https://circleci.com/gh/smoll/docker-browser-rb.svg?style=svg)](https://circleci.com/gh/smoll/docker-browser-rb)

[![](https://badge.imagelayers.io/smoll/browser-rb:latest.svg)](https://imagelayers.io/?images=smoll/browser-rb:latest 'Get your own badge on imagelayers.io')

## Gotchas

* Ensure that your test code starts Xvfb (using the `headless` gem is recommended) _BEFORE_ you attempt to launch a browser; the code should look something [like this](https://github.com/smoll/docker-browser-rb/blob/4247377056fc3954a6bae59e1632d8a527e8a49d/example/spec/spec_helper.rb#L8-L11).

* Ensure that you start chrome with the `--no-sandbox` flag, or else it blows up inside of the Docker container. Something to do with the fact that its sandboxing makes use of unix containers as well; for watir-webdriver, the code looks [like this](https://github.com/smoll/docker-browser-rb/blob/4247377056fc3954a6bae59e1632d8a527e8a49d/example/spec/chrome_spec.rb#L4).
