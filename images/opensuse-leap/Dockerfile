FROM opensuse/leap:15.6

RUN sed -i 's/^rpm\.install\.excludedocs.*$/rpm.install.excludedocs = no/' /etc/zypp/zypp.conf || true && \
    zypper --non-interactive --gpg-auto-import-keys refresh && \
    zypper --non-interactive install -f -y --no-recommends \
      coreutils \
      glibc \
      systemd \
      util-linux || true

RUN zypper --non-interactive install --no-recommends -y \
      ansible \
      ca-certificates \
      dbus-1 \
      glibc-locale-base \
      python3-rpm \
      systemd \
      systemd-sysvinit

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
