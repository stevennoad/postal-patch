FROM ghcr.io/postalserver/postal:2.1.4

LABEL \
  maintainer="Steve <hello@hostingme.co.uk>" \
  description="Postal patch: fixes FrozenError, IPv4 mapped IPv6 addresses when searching for SMTP-IP credentials, fixes Open/Link Tracking"

RUN sed -i \
  -e 's/output\.to_s\.force_encoding/output\.to_s\.dup\.force_encoding/g' \
  -e 's/credential\.ipaddr\.include?(@ip_address)/credential.ipaddr.include?(@ip_address) || (credential.ipaddr.ipv4? \&\& credential.ipaddr.ipv4_mapped.include?(@ip_address))/g' \
  /opt/postal/app/lib/postal/message_db/delivery.rb \
  /opt/postal/app/lib/postal/smtp_server/client.rb 

COPY production.rb /opt/postal/app/config/environments/production.rb
COPY application.html.haml /opt/postal/app/views/layouts/application.html.haml
