#!/bin/bash

yum install -y qrencode google-authenticator

groupadd gauth
useradd -g gauth gauth
mkdir /etc/openvpn/google-authenticator
chown gauth:gauth /etc/openvpn/google-authenticator
chmod 0700 /etc/openvpn/google-authenticator

echo "plugin /usr/lib64/openvpn/plugins/openvpn-plugin-auth-pam.so openvpn" >> /etc/openvpn/server.conf

echo "#%PAM-1.0" > /etc/pam.d/openvpn
echo "auth required /usr/lib64/security/pam_google_authenticator.so secret=/etc/openvpn/google-authenticator/\${USER} user=gauth" >> /etc/pam.d/openvpn
echo "account     required    pam_nologin.so" >> /etc/pam.d/openvpn
echo "account     include     system-auth" >> /etc/pam.d/openvpn
echo "password    include     system-auth" >> /etc/pam.d/openvpn
echo "session     include     system-auth" >> /etc/pam.d/openvpn

systemctl restart openvpn@server
