FROM tbrock/saw:v0.2.2 as saw


FROM alpine:3.11

# ENV BOTO3_VERSION=1.14.2
# ENV BOTOCORE_VERSION=v2.tar.gz
# ENV AWSCLI_VERSION=2.0.37.tar.gz
ENV TERRAFORM_VERSION=0.14.5
ENV SOPS_VERSION=3.6.1
ENV AWSCLI_VERSION=1.18.154


RUN apk --no-cache update && \
    apk --no-cache add \
        python3-dev=3.8.2-r2 \
        libffi-dev=3.2.1-r6 \
        openssl-dev=1.1.1j-r0 \
        ca-certificates=20191127-r2 \
        groff=1.22.4-r0 \
        less=551-r0 \
        bash=5.0.11-r1 \
        make=4.2.1-r2 \
        jq=1.6-r0 \
        gettext-dev=0.20.1-r2 \
        curl=7.67.0-r3 \
        nodejs=12.21.0-r0 \
        npm=12.21.0-r0 \
        g++=9.3.0-r0 \
        zip=3.0-r7 \
        git=2.24.3-r0  && \
    pip3 --no-cache-dir install --upgrade pip==20.2.3 setuptools==46.1.3 dnxsso==0.5.0 awscli==1.18.154 && \
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
