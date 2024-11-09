# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

#### ⚠️ Disclaimer :
- **This script is for the educational purposes just to show how quickly we can solve lab. Please make sure that you have a thorough understanding of the instructions before utilizing any scripts. We do not promote cheating or  misuse of resources. Our objective is to assist you in mastering the labs with efficiency, while also adhering to both 'qwiklabs' terms of services and YouTube's community guidelines.**

## Run in CloudShell and follow video:

### Task 1:
```
export ZONE=
export REGION=
```


### Task 2:
```
gcloud scc muteconfigs create muting-flow-log-findings \
--description="Rule for muting VPC Flow Logs" \
--filter='category="FLOW_LOGS_DISABLED"' \
--type=STATIC \
--project=$DEVSHELL_PROJECT_ID \
--location=global

gcloud scc muteconfigs create muting-audit-logging-findings \
--description="Rule for muting audit logs" \
--filter='category="AUDIT_LOGGING_DISABLED"' \
--type=STATIC \
--project=$DEVSHELL_PROJECT_ID \
--location=global

gcloud scc muteconfigs create muting-admin-sa-findings \
--description="Rule for muting admin service account findings" \
--filter='category="ADMIN_SERVICE_ACCOUNT"' \
--type=STATIC \
--project=$DEVSHELL_PROJECT_ID \
--location=global
```

### Task 3:

- Open firwall rules - https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/list
- Replace IP address

### Task 4:

- Open VM instances --> click edit --> reserve ext ip as --> `static-ip`
- Open https://console.cloud.google.com/security/web-scanner/scanConfigs

### Task 5:
```
gsutil mb -p $DEVSHELL_PROJECT_ID -c STANDARD -l $REGION -b on gs://scc-export-bucket-$DEVSHELL_PROJECT_ID
gsutil uniformbucketlevelaccess set off gs://scc-export-bucket-$DEVSHELL_PROJECT_ID
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/refs/heads/main/Mitigate%20Threats%20and%20Vulnerabilities%20with%20Security%20Command%20Center%3A%20Challenge%20Lab/findings.jsonl
gsutil cp findings.jsonl gs://scc-export-bucket-$DEVSHELL_PROJECT_ID
```

## ©Credit :
- All rights and credits goes to original content of Google Cloud [Google Cloud SkillBoost](https://www.cloudskillsboost.google/) 

## Congratulations !!

### ** Join us on below platforms **

- <img width="25" alt="image" src="https://github.com/user-attachments/assets/171448df-7b22-4166-8d8d-86f72fb78aff"> [Telegram Discussion Group](https://t.me/+HiOSF3PxrvFhNzU1)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/0ebd7e7d-6f9b-41e9-a241-8483dca9f3f1"> [Telegram Channel](https://t.me/abhiarcadesolution)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/dc326965-d4fa-4f1b-87f1-dbad6e3a7259"> [Abhi Arcade Solution](https://www.youtube.com/@Abhi_Arcade_Solution)
- <img width="26" alt="image" src="https://github.com/user-attachments/assets/d9070a07-7fce-47c5-8626-7ea98ccc46e3"> [WhatsApp](https://whatsapp.com/channel/0029VakEGSJ0VycJcnB8Fn3z)
- <img width="23" alt="image" src="https://github.com/user-attachments/assets/ce0916c3-e5f9-4709-afbd-e67bd42d1c57"> [LinkedIn](https://www.linkedin.com/in/abhi-arcade-solution-9b8a15319/)
