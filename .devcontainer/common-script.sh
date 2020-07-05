#!/bin/ash
set -e

USERNAME=${1:-"$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)"}
USER_UID=${2:-1000}
USER_GID=${3:-1000}

apk add --no-cache \
    git \
    openssh-client \
    less \
    bash \
    libgcc \
    libstdc++ \
    curl \
    wget \
    unzip \
    nano \
    jq \
    gnupg \
    procps \
    coreutils \
    ca-certificates \
    krb5-libs \
    libintl \
    libssl1.1 \
    lttng-ust \
    tzdata \
    userspace-rcu \
    zlib \
    shadow

if id -u $USERNAME > /dev/null 2>&1; then
  if [ "$USER_GID" != "$(id -G $USERNAME)" ]; then
    groupmod --gid $USER_GID $USERNAME
    usermod --gid $USER_GID $USERNAME
  fi
  if [ "$USER_UID" != "$(id -u $USERNAME)" ]; then
    usermod --uid $USER_UID $USERNAME
  fi
else
  groupadd --gid $USER_GID $USERNAME
  useradd -s /bin/ash -K MAIL_DIR=/dev/null --uid $USER_UID --gid $USER_GID -m $USERNAME
fi

apk add --no-cache sudo
echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME

echo "export PATH=\$PATH:\$HOME/.local/bin" | tee -a /root/.bashrc >> /home/$USERNAME/.bashrc
chown $USER_UID:$USER_GID /home/$USERNAME/.bashrc