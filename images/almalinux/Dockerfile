FROM almalinux:9

RUN dnf install -y --allowerasing --setopt=install_weak_deps=False \
      epel-release \
      systemd \
      systemd-libs \
      ca-certificates \
      dbus \
      iproute \
      glibc-langpack-en \
      sudo \
      openssh-clients \
      openssh-server \
      ansible-core \
      bash-completion \
      curl \
      file \
      gnupg2 \
      iputils \
      less \
      man-db \
      ncurses \
      procps-ng \
      wget && \
    rm -f /etc/ssh/ssh_host_*_key* && \
    mkdir -p /etc/systemd/journald.conf.d && \
    printf '[Journal]\nReadKMsg=no\n' > /etc/systemd/journald.conf.d/00-no-kmsg.conf && \
    dnf clean all && \
    rm -rf \
      /var/cache/dnf/* \
      /var/log/* \
      /tmp/* \
      /var/tmp/*

ENV LANG=en_GB.UTF-8

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone

RUN systemctl mask \
      systemd-modules-load.service \
      sys-kernel-debug.mount \
      sys-kernel-tracing.mount \
      sys-kernel-config.mount \
      dnf-makecache.timer \
      dnf-makecache.service

RUN useradd --create-home --shell /bin/bash user && \
    usermod -aG wheel user && \
    mkdir -p /home/user/.ssh && \
    chown user:user /home/user/.ssh && \
    chmod 700 /home/user/.ssh
COPY common/sshd_config /etc/ssh/sshd_config.d/user.conf

RUN ansible-galaxy collection install community.general

COPY common/ansible.yaml ansible.yaml
RUN ansible-playbook -i localhost, ansible.yaml -c local && \
    rm ansible.yaml

RUN : > /etc/machine-id && \
    mkdir -p /var/lib/dbus && \
    rm -f /var/lib/dbus/machine-id && \
    ln -s /etc/machine-id /var/lib/dbus/machine-id

COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
