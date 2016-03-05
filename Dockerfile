FROM ubuntu-debootstrap:14.04

ENV LANG      en_US.UTF-8
ENV LANGUAGE  en_US.UTF-8
ENV LC_ALL    en_US.UTF-8

# Use a version available on the Brightbox repo (https://www.brightbox.com/docs/ruby/ubuntu/)
ENV RUBY_VERSION 2.3

# Locale stuff
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    # Don't install man documents for future packages and remove existing
    printf "path-exclude /usr/share/doc/*\npath-exclude /usr/share/man/*\npath-exclude /usr/share/info/*\npath-exclude /usr/share/lintian/*" >> /etc/dpkg/dpkg.cfg.d/nodoc && \
    cd /usr/share && rm -fr doc/* man/* info/* lintian/* && \

    # Install Ruby + build tools
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C3173AA6 && \
    echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main > /etc/apt/sources.list.d/brightbox-ruby-ng-trusty.list && \
    apt-get update -q && \
    # Remove iceweasel in favor of firefox
    apt remove iceweasel && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        ca-certificates \
        openssl \
        libssl-dev \
        g++ \
        gcc \
        libc6-dev \
        make \
        patch \
        ruby$RUBY_VERSION \
        ruby$RUBY_VERSION-dev \

        # dep for chrome, see https://github.com/dnschneid/crouton/issues/632#issuecomment-35228182
        hicolor-icon-theme \
        # curl is a prereq to be able to download chrome
        curl \

        # Xvfb
        xvfb \

        # For video recording; see headless gem
        libav-tools && \

    # Key for chrome
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \

    # Key for firefox
    echo "deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main" > /etc/apt/sources.list.d/ubuntuzilla.list && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29 && \

    # Install browsers
    apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        google-chrome-stable \
        firefox && \

    # clean up
    rm -rf /var/lib/apt/lists/* && \
    truncate -s 0 /var/log/*log && \

    # Setup Rubygems
    echo 'gem: --no-document' > /etc/gemrc && \
    gem install bundler && gem update --system

CMD ["/usr/bin/ruby"]
