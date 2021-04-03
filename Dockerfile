FROM tbrock/saw:v0.2.2 as saw
FROM alpine:3.11

# ENV BOTO3_VERSION=1.14.2
# ENV BOTOCORE_VERSION=v2.tar.gz
# ENV AWSCLI_VERSION=2.0.37.tar.gz
#ENV AWSCLI_VERSION=1.18.154
ENV TERRAFORM_VERSION=0.14.5
ENV SOPS_VERSION=3.6.1

RUN apk --no-cache update && \
    apk --no-cache add \
        python3-dev \
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
    pip3 --no-cache-dir install --upgrade pip setuptools dnxsso awscli && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN curl --silent --location -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux && \
    chmod +x /usr/local/bin/sops

COPY --from=saw /bin/saw /bin/saw

COPY scripts /opt/scripts

ENV PATH "$PATH:/opt/scripts"

WORKDIR /work
