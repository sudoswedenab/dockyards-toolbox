FROM nicolaka/netshoot:latest

# Install required packages and dependencies
RUN apk add --no-cache \
      curl \
      bash \
      vim \
      jq \
      yq \
      ca-certificates \
      git

# Install kubectl
RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Install talosctl
RUN curl -sL "https://github.com/siderolabs/talos/releases/latest/download/talosctl-linux-amd64" -o /usr/local/bin/talosctl \
    && chmod +x /usr/local/bin/talosctl

# Install flux CLI
RUN curl -s https://fluxcd.io/install.sh | bash

# Install Helm
RUN curl -sSL https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz | tar -xz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64

# Enable bash-completion package
RUN apk add --no-cache bash-completion

# Create completion dirs
RUN mkdir -p /etc/bash_completion.d /usr/share/zsh/site-functions

# Generate and install bash completions
RUN kubectl completion bash > /etc/bash_completion.d/kubectl && \
    talosctl completion bash > /etc/bash_completion.d/talosctl && \
    flux completion bash > /etc/bash_completion.d/flux && \
    helm completion bash > /etc/bash_completion.d/helm && \
    echo "alias k=kubectl" >> /root/.bashrc && \
    echo "complete -F __start_kubectl k" >> /root/.bashrc

# Generate and install zsh completions
RUN kubectl completion zsh > /usr/share/zsh/site-functions/_kubectl && \
    talosctl completion zsh > /usr/share/zsh/site-functions/_talosctl && \
    flux completion zsh > /usr/share/zsh/site-functions/_flux && \
    helm completion zsh > /usr/share/zsh/site-functions/_helm && \
    echo "alias k=kubectl" >> /root/.zshrc && \
    echo "compdef __start_kubectl k" >> /root/.zshrc
