FROM registry.fedoraproject.org/fedora-toolbox:41

ENV ARGOCD_VERSION=2.14.15 \
    YQ_VERSION=4.23.1 \
    HELM_VERSION=3.18.3 \
    OC_VERSION=4.19.1 \
    JQ_VERSION=1.8.0 \
    VAULT_VERSION=1.19.5 \
    KUSTOMIZE_VERSION=5.6.0

ENV PACKAGES="ansible gzip iputils bind-utils net-tools nodejs npm nodejs-nodemon python3-pip httpd-tools gettext-envsubst"

RUN dnf -y install \
    ${PACKAGES} && \
    dnf -y -q clean all && rm -rf /var/cache/yum && \
    ln -s /usr/bin/node /usr/bin/nodejs

# argo
RUN curl -sL https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64 -o /usr/local/bin/argocd && \
    chmod -R 775 /usr/local/bin/argocd && \
    echo "🐙🐙🐙🐙🐙"

# oc client
RUN rm -f /usr/bin/oc && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xzf - && \
    echo "🐨🐨🐨🐨🐨"

# jq / yq
RUN curl -sLo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -sLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    echo "🦨🦨🦨🦨🦨"

# helm
RUN curl -skL -o /tmp/helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -C /tmp -xzf /tmp/helm.tar.gz && \
    mv -v /tmp/linux-amd64/helm /usr/local/bin && \
    chmod -R 775 /usr/local/bin/helm && \
    rm -rf /tmp/linux-amd64 && \
    rm -rf /tmp/helm.tar.gz && \
    echo "⚓️⚓️⚓️⚓️⚓️"

# vault
RUN curl -skL -o /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip -q /tmp/vault.zip -d /tmp vault && \
    mv -v /tmp/vault /usr/local/bin && \
    chmod -R 775 /usr/local/bin/vault && \
    rm -rf /tmp/vault.zip && \
    echo "🔑🔑🔑🔑🔑"

# Install kustomize
RUN curl -skL -o /tmp/kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    tar -C /tmp -xzf /tmp/kustomize.tar.gz && \
    mv -v /tmp/kustomize /usr/local/bin && \
    chmod -R 775 /usr/local/bin/kustomize && \
    rm -rf /tmp/linux-amd64 && \
    rm -rf /tmp/kustomize.tar.gz && \
    echo "🐾🐾🐾🐾🐾"

# docsify-cli
RUN npm i -g docsify-cli && \
    echo "📚📚📚📚📚"

# python global deps
RUN pip3 install awscli==1.37.15 boto3==1.36.15 botocore==1.36.15 && \
    echo "🦀🦀🦀🦀🦀"
