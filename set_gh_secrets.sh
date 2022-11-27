#!/usr/bin/env bash
set -euxo pipefail

gh secret set CLOUD_RUN_PROJECT --body $(cat /opt/credentials/CLOUD_RUN_PROJECT)
gh secret set CLOUD_RUN_REGION --body $(cat /opt/credentials/CLOUD_RUN_REGION)
gh secret set GCP_SERVICE_ACCOUNT_CREDENTIALS < /opt/credentials/cloud_run_creds.json
