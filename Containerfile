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

# Add completions and alias to bashrc
RUN echo "source <(kubectl completion bash)" >> /root/.bashrc && \
    echo "source <(talosctl completion bash)" >> /root/.bashrc && \
    echo "source <(flux completion bash)" >> /root/.bashrc && \
    echo "source <(helm completion bash)" >> /root/.bashrc && \
    echo "alias k=kubectl" >> /root/.bashrc && \
    echo "complete -F __start_kubectl k" >> /root/.bashrc
