FROM almalinux:9

RUN sed -i '/^tsflags=nodocs/d' /etc/dnf/dnf.conf && \
    dnf reinstall -y --setopt=install_weak_deps=False \
      coreutils \
      glibc-minimal-langpack \
      systemd \
      util-linux || true

RUN dnf install -y --allowerasing --setopt=install_weak_deps=False \
      ansible-core \
      ca-certificates \
      coreutils \
      curl \
      dbus \
      epel-release \
      glibc-langpack-en \
      systemd

COPY common /opt/common
RUN ansible-galaxy collection install community.general && \
    ansible-playbook -i localhost, /opt/common/ansible.yaml -c local && \
    rm -rf /opt/common

ENV LANG=en_GB.UTF-8

# Clear machine-id so each container generates a fresh one on first boot
RUN : > /etc/machine-id && \
    mkdir -p /var/lib/dbus && \
    rm -f /var/lib/dbus/machine-id && \
    ln -s /etc/machine-id /var/lib/dbus/machine-id

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
