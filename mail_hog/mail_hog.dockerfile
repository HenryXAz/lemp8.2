FROM alpine:latest

WORKDIR /opt

RUN wget 'https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64'

RUN chmod +x ./MailHog_linux_amd64

CMD ./MailHog_linux_amd64