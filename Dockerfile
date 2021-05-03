FROM tbrock/saw:v0.2.2 as saw
FROM alpine:3.13

# ENV BOTO3_VERSION=1.14.2
# ENV BOTOCORE_VERSION=v2.tar.gz
# ENV AWSCLI_VERSION=2.0.37.tar.gz
ENV AWSCLI_VERSION=1.19.62
ENV TERRAFORM_VERSION=0.14.5
ENV SOPS_VERSION=3.6.1

RUN apk --no-cache update && \
    apk --no-cache add \
        python3-dev=3.8.8-r0 \
        libffi-dev=3.3-r2 \
        openssl-dev=1.1.1k-r0 \
        ca-certificates=20191127-r5 \
        groff=1.22.4-r1 \
        less=563-r0 \
        bash=5.1.0-r0 \
        make=4.3-r0 \
        jq=1.6-r1 \
        gettext-dev=0.20.2-r2 \
        curl=7.74.0-r1 \
        nodejs=14.16.0-r0 \
        npm=14.16.0-r0 \
        g++=10.2.1_pre1-r3 \
        zip=3.0-r9 \
        git=2.30.2-r0 \
        py3-pip=20.3.4-r0 && \
    pip3 --no-cache-dir install --upgrade setuptools==54.2.0 dnxsso==0.5.0 awscli==${AWSCLI_VERSION} && \
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
