set -e

PATCH_DIR="/var/vcap/jobs-src/cloud_controller_ng/templates"
SENTINEL="${PATCH_DIR}/${0##*/}.sentinel"

if [ -f "${SENTINEL}" ]; then
  exit 0
fi

read -r -d '' patch_api_server_name<<'PATCH' || true
--- cloud_controller_api_ctl.erb
+++ cloud_controller_api_ctl.erb
@@ -43,7 +43,7 @@
 # If this isn't done, all activity will be grouped under 'dynamic hostname'
 # Note: this will only take effect if heroku.use_dyno_names in newrelic.yml
 #       is set to true
-export DYNO=<%= "#{spec.job.name}-#{spec.index}" %>
+export DYNO=<%= "#{spec.job.name}-ENV['HCP_COMPONENT_INDEX'].to_i" %>
 source /var/vcap/packages/capi_utils/syslog_utils.sh
 source /var/vcap/packages/capi_utils/pid_utils.sh
PATCH

cd "$PATCH_DIR"

echo -e "${patch_api_server_name}" | patch --force

touch "${SENTINEL}"

exit 0
