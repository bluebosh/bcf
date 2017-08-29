set -e

PATCH_DIR="/var/vcap/jobs-src/cloud_controller_ng/templates"
SENTINEL="${PATCH_DIR}/${0##*/}.sentinel"

if [ -f "${SENTINEL}" ]; then
  exit 0
fi

read -r -d '' patch_api_server_name <<'PATCH' || true
--- cloud_controller_api_worker_ctl.erb
+++ cloud_controller_api_worker_ctl.erb
@@ -46,7 +46,7 @@
     wait_for_blobstore
     cd "${CC_PACKAGE_DIR}/cloud_controller_ng"
-    exec bundle exec rake "jobs:local[cc_api_worker.<%= spec.job.name %>.<%= spec.index %>.${INDEX}]"
+    exec bundle exec rake "jobs:local[cc_api_worker.<%= spec.job.name %>.<%= ENV['HCP_COMPONENT_INDEX'].to_i %>.${INDEX}]"
   ;;
   stop)
PATCH

cd "$PATCH_DIR"

echo -e "${patch_api_server_name}" | patch --force

touch "${SENTINEL}"

exit 0

