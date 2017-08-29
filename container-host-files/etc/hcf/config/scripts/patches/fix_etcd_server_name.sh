set -e

# This patch is not meant to be upstreamed as vanilla CF uses canary nodes to
# bring up the first etcd node. Our k8s setup doesn't allow this right now, so
# we work around this by making the other nodes sleep until the bootstrap node
# is ready.

PATCH_DIR="/var/vcap/jobs-src/etcd/templates"
SENTINEL="${PATCH_DIR}/${0##*/}.sentinel"

if [ -f "${SENTINEL}" ]; then
  exit 0
fi

read -r -d '' change_etcd_server_name <<'PATCH' || true
--- etcdfab.json.erb
+++ etcdfab.json.erb
@@ -19,7 +19,7@@
   {
     node: {
       name: name,
-      index: spec.index,
+      index: ENV['HCP_COMPONENT_INDEX'].to_i,
       external_ip: discover_external_ip,
     },
PATCH

cd "$PATCH_DIR"

echo -e "${change_etcd_server_name}" | patch --force

touch "${SENTINEL}"

exit 0
