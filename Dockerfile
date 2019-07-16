FROM alpine:3.10

ENV CF_CLI_VERSION "6.46.0"
ENV CF_BGD_VERSION "1.4.0"
ENV CF_BGD_CHECKSUM "a2901bf17a030c8f58b6622c855f775dfebd3f239dba1737b4bc2de18307db03"

RUN apk add --update curl bash make libc6-compat \
    && rm -rf /var/cache/apk/*

RUN curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&version=${CF_CLI_VERSION}" | tar -zx -C /usr/local/bin

# Install Plugins
RUN CF_BGD_TEMPFILE=/tmp/blue-green-deploy.linux64 \
    && curl -L -o "${CF_BGD_TEMPFILE}" \
    "https://github.com/bluemixgaragelondon/cf-blue-green-deploy/releases/download/v${CF_BGD_VERSION}/blue-green-deploy.linux64" \
    && echo "${CF_BGD_CHECKSUM}  ${CF_BGD_TEMPFILE}" | sha256sum -c - \
    && chmod +x "${CF_BGD_TEMPFILE}" \
    && cf install-plugin -f "${CF_BGD_TEMPFILE}" \
    && rm "${CF_BGD_TEMPFILE}"
