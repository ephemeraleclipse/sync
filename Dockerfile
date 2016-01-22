FROM ubuntu
RUN apt-get update && apt-get upgrade -y
RUN apt-get install build-essential git python software-properties-common -y
RUN add-apt-repository ppa:mc3man/trusty-media -y
RUN apt-get update
RUN apt-get install ffmpeg gstreamer0.10-ffmpeg -y
RUN curl --silent --location https://deb.nodesource.com/setup_4.x | sudo bash -
RUN apt-get install nodejs -y
COPY . /var/sync
RUN cd /var/sync && npm install
COPY config.template.yaml /var/sync/config.yaml
RUN sed -i "s/database: 'cytube3'\n *user: 'cytube3'\n *password: ''/database: 'cytube3'\n  user: 'root'\n  password: '$MYSQL_PASSWORD'/" /var/sync/config.yaml
RUN sed -i "s/default-port: 8080/default-port: 80/" /var/sync/config.yaml
RUN sed -i "s/domain: 'http://localhost'/domain: 'http://$VIRTUAL_HOST'/" /var/sync/config.yaml
RUN sed -i "s/root-domain: 'localhost'/root-domain: '$VIRTUAL_HOST'/" /var/sync/config.yaml
RUN sed -i "s/minify: false/minify: true/" /var/sync/config.yaml
RUN sed -i "s/change-me/$COOKIE_SECRET/" /var/sync/config.yaml
RUN sed -i "s/title: 'CyTube'/title: '$TITLE'/" /var/sync/config.yaml
RUN sed -i "s/description: 'Free, open source synchtube'/description: '$DESCRIPTION'/" /var/sync/config.yaml
RUN sed -i "s/domain: 'http://localhost'/domain: 'http://$VIRTUAL_HOST'/" /var/sync/config.yaml
RUN sed -i "s/mail:\n *enabled: false/mail:\n  enabled: true/" /var/sync/config.yaml
RUN sed -i "s/service: 'Gmail'/service: '$MAIL_SERVICE'/" /var/sync/config.yaml
RUN sed -i "s/user: 'some.user@gmail.com'/user: '$SMTP_USER'/" /var/sync/config.yaml
RUN sed -i "s/pass: 'supersecretpassword'/pass: '$SMTP_PASS'/" /var/sync/config.yaml
RUN sed -i "s/from-address: 'some.user@gmail.com'/from-address: '$FROM_ADDRESS'/" /var/sync/config.yaml
RUN sed -i "s/from-name: 'CyTube Services'/from-name: '$FROM_NAME'/" /var/sync/config.yaml
RUN sed -i "s/youtube-v3-key: ''/youtube-v3-key: '$YOUTUBE_API_KEY'/" /var/sync/config.yaml
RUN sed -i "s/ffmpeg:\n *enabled: false/ffmpeg:\n  enabled: true/" /var/sync/config.yaml
EXPOSE 80
CMD ['bash /var/sync/run.sh']
