set -e

PATCH_DIR="/var/vcap/jobs-src/cloud_controller_ng/templates"
SENTINEL="${PATCH_DIR}/${0##*/}.sentinel"

if [ -f "${SENTINEL}" ]; then
  exit 0
fi

read -r -d '' patch_api_server_name<<'PATCH' || true
--- cloud_controller_api.yml.erb
+++ cloud_controller_api.yml.erb
@@ -140,7 +140,7 @@
   use_nginx: true
   instance_socket: "/var/vcap/sys/run/cloud_controller_ng/cloud_controller.sock"
-index: <%= spec.index %>
+index: <%= ENV['HCP_COMPONENT_INDEX'].to_i %>
 name: <%= name %>
 route_services_enabled: <%= !p("router.route_services_secret").empty? %>
 volume_services_enabled: <%= p("cc.volume_services_enabled") %>
PATCH

cd "$PATCH_DIR"

echo -e "${patch_api_server_name}" | patch --force

touch "${SENTINEL}"

exit 0
