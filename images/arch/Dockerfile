FROM archlinux:latest

RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu --noconfirm --needed \
      systemd \
      systemd-sysvcompat \
      ca-certificates \
      dbus \
      iproute2 \
      glibc \
      sudo \
      openssh \
      ansible-core \
      bash-completion \
      curl \
      file \
      gnupg \
      iputils \
      less \
      lsb-release \
      man-db \
      ncurses \
      procps-ng \
      wget && \
    rm -f /etc/ssh/ssh_host_*_key* && \
    echo "ReadKMsg=no" >> /etc/systemd/journald.conf && \
    pacman -Scc --noconfirm && \
    rm -rf \
      /var/cache/pacman/pkg/* \
      /var/log/* \
      /tmp/* \
      /var/tmp/*

RUN sed -i 's/^#en_GB.UTF-8/en_GB.UTF-8/' /etc/locale.gen && \
    locale-gen && \
    echo "LANG=en_GB.UTF-8" > /etc/locale.conf
ENV LANG=en_GB.UTF-8

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone

RUN systemctl mask \
      systemd-modules-load.service \
      sys-kernel-debug.mount \
      sys-kernel-tracing.mount \
      sys-kernel-config.mount

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
    rm -f /var/lib/dbus/machine-id && \
    ln -s /etc/machine-id /var/lib/dbus/machine-id

COPY common/entrypoint.sh /usr/local/bin/entrypoint.sh

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
