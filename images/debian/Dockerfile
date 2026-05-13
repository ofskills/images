FROM debian:13

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      systemd \
      systemd-sysv \
      libsystemd0 \
      ca-certificates \
      dbus \
      iproute2 \
      locales \
      sudo \
      openssh-client \
      openssh-server \
      ansible \
      bash-completion \
      curl \
      file \
      gpg \
      iputils-ping \
      less \
      lsb-release \
      man-db \
      ncurses-term \
      procps \
      wget && \
    rm -f /etc/ssh/ssh_host_*_key* && \
    echo "ReadKMsg=no" >> /etc/systemd/journald.conf && \
    apt-get clean -y && \
    rm -rf \
      /var/lib/apt/lists/* \
      /var/log/* \
      /tmp/* \
      /var/tmp/*

# Generate locale (cloud images ship with en_GB.UTF-8 pre-configured)
RUN sed -i 's/# en_GB.UTF-8/en_GB.UTF-8/' /etc/locale.gen && \
    locale-gen en_GB.UTF-8 && \
    echo "LANG=en_GB.UTF-8" > /etc/default/locale
ENV LANG=en_GB.UTF-8

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone

RUN systemctl mask \
      sys-kernel-debug.mount \
      sys-kernel-tracing.mount \
      sys-kernel-config.mount \
      e2scrub_reap.service \
      e2scrub_all.timer

RUN useradd --create-home --shell /bin/bash user && \
    adduser user sudo && \
    mkdir -p /home/user/.ssh && \
    chown user:user /home/user/.ssh && \
    chmod 700 /home/user/.ssh
COPY common/sshd_config /etc/ssh/sshd_config.d/user.conf

COPY common/ansible.yaml ansible.yaml
RUN ansible-playbook -i localhost, ansible.yaml -c local && \
    rm ansible.yaml

# Clear machine-id so each container generates a fresh one on first boot
RUN : > /etc/machine-id && \
    rm -f /var/lib/dbus/machine-id && \
    ln -s /etc/machine-id /var/lib/dbus/machine-id

COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
