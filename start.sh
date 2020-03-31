#!/usr/bin/env sh

set -e

if [[ -z "${CONSUL_URL}" ]]; then
  cat << EOF > /opt/vendor/vault/config.json
  storage "file" {
    path = "/tmp/vault/data"
  }

  disable_mlock = true

EOF
else
  cat << EOF > /opt/vendor/vault/config.json
  storage "consul" {
    address = "${CONSUL_URL}"
    path    = "vault"
  }

EOF
fi

cat << EOF >> /opt/vendor/vault/config.json
ui = true

listener "tcp" {
  address     = "0.0.0.0:${PORT:-8200}"
  tls_disable = 1
}
EOF

if [[ -z "${DEV}" ]]; then
  vault server -config=/opt/vendor/vault/config.json
else
  vault server -dev -dev-root-token-id=${TOKEN:-root} -dev-listen-address=0.0.0.0:${PORT:-8200}
fi
