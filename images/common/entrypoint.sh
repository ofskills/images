#!/usr/bin/env bash
set -e

echo "entrypoint diag: kernel=$(cat /proc/sys/kernel/hostname) etc=$(cat /etc/hostname)" >&2

OVERLAY="/overlay-data"
LOWER="/mnt/lower"
MERGED="/mnt/merged"

# Sysbox provides a non-empty /etc/machine-id at runtime, so ConditionFirstBoot=yes
# never fires and sshd-keygen.service is skipped. Generate keys here instead.
ssh-keygen -A >/dev/null

# If /overlay-data is not a mount point (PVC not attached), skip overlay and boot directly.
if ! mountpoint -q "$OVERLAY"; then
  exec /sbin/init --log-level=err
fi

mkdir -p "${OVERLAY}/upper" "${OVERLAY}/work"
# Ensure OverlayFS workdir is empty before mounting, in case of unclean shutdown.
rm -rf "${OVERLAY}/work"/* "${OVERLAY}/work"/.[!.]* "${OVERLAY}/work"/..?* 2>/dev/null || true

mount --make-rprivate /

mkdir -p "$LOWER" "$MERGED"
mount --bind / "$LOWER"
mount -o remount,bind,ro "$LOWER"

mount -t overlay overlay \
  -o "lowerdir=${LOWER},upperdir=${OVERLAY}/upper,workdir=${OVERLAY}/work" \
  "$MERGED"

# Move virtual filesystems into merged root (preserves Sysbox emulations).
# /run may not be a separate mount under CRI-O, so only move actual mount points.
for fs in /proc /sys /dev /run; do
  if mountpoint -q "$fs"; then
    mkdir -p "${MERGED}${fs}"
    mount --move "$fs" "${MERGED}${fs}"
  fi
done

mkdir -p "${MERGED}/mnt/old_root"
cd "$MERGED"
pivot_root . mnt/old_root

# Move virtual files from old root to new root.
for fs in /etc/hosts /home/user/.ssh/authorized_keys; do
  if mountpoint -q /mnt/old_root/$fs; then
    mount --move /mnt/old_root/$fs /$fs
  fi
done

echo "entrypoint diag pre-init: kernel=$(cat /proc/sys/kernel/hostname) etc=$(cat /etc/hostname)" >&2

exec /sbin/init --log-level=err
