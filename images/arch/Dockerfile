FROM archlinux:latest

RUN sed -i '/^NoExtract/d' /etc/pacman.conf && \
    sed -i 's/^#DisableSandboxSyscalls/DisableSandboxSyscalls/' /etc/pacman.conf && \
    pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu --noconfirm coreutils glibc systemd util-linux procps-ng iproute2

RUN pacman -S --noconfirm --needed \
      ansible \
      ca-certificates \
      dbus \
      systemd-sysvcompat

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
