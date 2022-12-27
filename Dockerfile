FROM alpine:3

ENV TARGETOS=linux
ENV TARGETARCH=amd64

ENV KUBE_VERSION=1.26.0
ENV HELM_VERSION=3.10.3
ENV YQ_VERSION=4.30.5

RUN apk -U upgrade \
    && apk add --no-cache ca-certificates bash git openssh curl gettext jq python3 py3-pip \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    && wget -q https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETOS}_${TARGETARCH} -O /usr/local/bin/yq \
    && pip3 install --no-cache --upgrade awscli \
    && chmod +x /usr/local/bin/helm /usr/local/bin/kubectl /usr/local/bin/yq \
    && mkdir /config \
    && chmod g+rwx /config /root \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && kubectl version --client \
    && helm version  \
    && aws --version 


WORKDIR /config

CMD bash

