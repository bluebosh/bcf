set -e

PATCH_DIR="/var/vcap/jobs-src/consul_agent/templates/"
SENTINEL="${PATCH_DIR}/${0##*/}.sentinel"

if [ -f "${SENTINEL}" ]; then
  exit 0
fi

read -r -d '' pre_start_patch <<'PATCH' || true
--- pre-start.erb
+++ pre-start.erb
@@ -10,7 +10,7 @@
 function setup_resolvconf() {
   local resolvconf_file
-  resolvconf_file=/etc/resolvconf/resolv.conf.d/head
+  resolvconf_file=/etc/resolv.conf
   if ! grep -qE '127.0.0.1\b' "${resolvconf_file}"; then
           if [[ "$(stat -c "%s" "${resolvconf_file}")" = "0" ]]; then
PATCH

cd "$PATCH_DIR"

echo -e "${pre_start_patch}" | patch --force

touch "${SENTINEL}"

exit 0
