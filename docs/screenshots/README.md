

01-ansible-playbook-run.png   -> ansible-playbook site.yml  (show PLAY RECAP with ok/changed, failed=0)
02-users-created.png          -> id opsadmin && id appuser
03-cron-jobs.png              -> sudo crontab -l
04-backup-output.png          -> sudo /opt/automation/scripts/backup.sh && ls -lh /var/backups/automation
05-disk-monitor.png           -> sudo /opt/automation/scripts/disk_usage_monitor.sh
