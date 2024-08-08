#!/bin/bash

BACKUP_DIR=~/conf_backup
mkdir -p "$BACKUP_DIR"

FILES=(
    /etc/login.defs
    /etc/pam.d/common-auth
    /etc/pam.d/common-password
    /etc/securetty
    /etc/ssh/sshd_config
    /etc/shadow
    /etc/default/useradd
    /etc/profile
    /etc/csh.login
    /root/.profile
    /root/.bashrc
    /etc/group
    /etc/bashrc
    /etc/rsyslog.conf
    /etc/logrotate.conf
)

for FILE in "${FILES[@]}"; do
    cp -p "$FILE" "$BACKUP_DIR"
done

echo "Резервное копирование завершено. Все файлы сохранены в $BACKUP_DIR"
