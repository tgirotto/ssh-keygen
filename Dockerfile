FROM alpine:latest

# Install OpenSSH and jq
RUN apk add --no-cache openssh jq

# Create a simple wrapper script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
