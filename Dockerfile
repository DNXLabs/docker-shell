FROM tbrock/saw:v0.2.2 as saw
FROM alpine:3.13

ENV AWSCLI_VERSION=1.19.73
ENV TERRAFORM_VERSION=0.15.3
ENV SOPS_VERSION=3.7.1

RUN apk --no-cache update && \
    apk --no-cache add \
        python3-dev \
        py3-pip \
        libffi-dev \
        openssl-dev \
        ca-certificates \
        groff \
        less \
        bash \
        make \
        jq \
        gettext-dev \
        curl \
        nodejs \
        npm \
        g++ \
        zip \
        git && \
    pip3 --no-cache-dir install --upgrade setuptools==54.2.0 dnxsso==0.5.0 awscli==${AWSCLI_VERSION} && \
    update-ca-certificates && \
    curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    curl --silent --location -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux && \
    chmod +x /usr/local/bin/sops && \
    rm -rf /var/cache/apk/*

COPY --from=saw /bin/saw /bin/saw
COPY scripts /opt/scripts

ENV PATH "$PATH:/opt/scripts"

WORKDIR /work
