FROM ruby:2.6.3 AS Core

    # Update
    RUN apt-get update && apt-get install -y npm && npm install -g yarn

    #Set Work Directory
    WORKDIR /usr/src/app

    #Add sudo just to simplify transfer process
    RUN  apt-get -y install sudo

    # Yarn / Node apt-get repositories - not sure if needed 
    RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    # Google chrome apt-get repositories - not sure if needed
    RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    RUN echo "deb https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

    #added line due to not found error https://stackoverflow.com/questions/27423684/unable-to-locate-package-google-chrome-stable-ubuntu12-on-openstack
    RUN sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

    # COPY Data
    COPY src  /usr/src/app/

    #To correct bundler 2 error https://stackoverflow.com/questions/53231667/bundler-you-must-use-bundler-2-or-greater-with-this-lockfile
    RUN gem install bundler 


    # Dependencies for ASPC Main Site - removed google-chrome-stable
    RUN apt-get -y install build-essential git nginx postgresql libpq-dev python-dev \
        libsasl2-dev libssl-dev libffi-dev gnupg2 nodejs \
        curl libjpeg-dev libxml2-dev libxslt-dev nodejs yarn \
        imagemagick


    #Install Gems 
    RUN bundle install 


    EXPOSE 8080


    CMD bundle exec rails s -p 3000 -b '0.0.0.0'



