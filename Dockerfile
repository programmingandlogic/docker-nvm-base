# DOCKER-VERSION ~1.1.0
FROM ubuntu:wily

# setup base system
COPY apt.sources.list /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy build-essential libssl-dev git man curl

# def
USER root
ENV HOME /root
ENV NODE_VER v5.6

# setup the cli env
RUN git clone --depth=1 https://github.com/creationix/nvm.git $HOME/.nvm
RUN git clone --depth=1 https://github.com/programmingandlogic/ci $HOME/ci

# npm install
WORKDIR /root/ci

# Install node version into the image as well as run npm install.
RUN /bin/bash -c '. ~/.nvm/nvm.sh; nvm install ${NODE_VER};\
nvm use ${NODE_VER}; nvm alias default ${NODE_VER};\
echo "Running npm install in $(pwd)";\
npm install;'

# modify .profile
RUN echo '. ~/.nvm/nvm.sh' >> $HOME/.profile

# entrypoint for our CI
ENTRYPOINT ["/bin/bash", "--login", "-c", "bash $HOME/ci/run-ci.sh $ORG $REPO $COMMIT"]
