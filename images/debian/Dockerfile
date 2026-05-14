FROM debian:13

# Restore documentation by removing any dpkg path-exclude drop-ins (defensive)
RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes /etc/dpkg/dpkg.cfg.d/docker-clean

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ansible \
      ca-certificates \
      dbus \
      locales \
      python3-apt \
      systemd \
      systemd-sysv

COPY common /opt/common
RUN ansible-galaxy collection install community.general && \
    ansible-playbook -i localhost, /opt/common/ansible.yaml -c local && \
    rm -rf /opt/common

ENV LANG=en_GB.UTF-8

# Clear machine-id so each container generates a fresh one on first boot
RUN : > /etc/machine-id && \
    rm -f /var/lib/dbus/machine-id && \
    ln -s /etc/machine-id /var/lib/dbus/machine-id

STOPSIGNAL SIGRTMIN+3
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
