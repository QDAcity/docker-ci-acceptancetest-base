# Includes chrome and selenium
FROM selenium/standalone-chrome:86.0

# Prepare
RUN \
  sudo apt-get update && \
  sudo apt-get install -y apt-utils && \
  sudo apt-get install -y software-properties-common && \
  sudo apt-get install -y curl && \
  sudo apt-get install -y unzip && \
  sudo apt-get -y upgrade

# Install Maven (TODO: test to start dev server)
RUN sudo apt install maven -y

# Install Python (required for google cloud sdk)
RUN \
  sudo add-apt-repository ppa:deadsnakes/ppa && \
  sudo apt-get update && \
  sudo apt-get install -y python

# Google cloud sdk
RUN \
  sudo curl -o /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
  sudo mkdir -p /usr/local/gcloud && \
  sudo tar xf /tmp/google-cloud-sdk.tar.gz -C /usr/local/gcloud/ && \
  sudo /usr/local/gcloud/google-cloud-sdk/install.sh && \
  sudo rm -f /tmp/google-cloud-sdk.tar.gz

RUN sudo chown seluser -R /home/seluser/.config/gcloud
RUN sudo chown seluser -R /usr/local/gcloud
  
ENV PATH="/usr/local/gcloud/google-cloud-sdk/bin:${PATH}"

RUN gcloud components install app-engine-java --quiet

# Install npm
RUN \
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
  sudo apt-get install -y nodejs
  
# update to latest npm version
RUN sudo npm i -g npm@5.8

# for testing ports
RUN sudo apt-get install lsof