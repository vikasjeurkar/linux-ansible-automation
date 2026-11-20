# Linux Configuration & Automation with Ansible

Automates Linux server setup and routine administration on **RHEL** and **Ubuntu** using **Ansible playbooks**, **Bash scripts** and **cron jobs**.

## What it does

| Area | Implementation |
|------|----------------|
| User setup | Ansible creates admin/app users, sudo access (validated with `visudo`) |
| Package installation | Installs git, curl, vim, htop, rsync, cron and chrony (works on `apt` and `dnf`) |
| Service configuration | Enables and starts cron, chrony and SSH |
| Backups | `backup.sh` creates timestamped `tar.gz` backups and removes old ones (7-day retention) |
| Disk monitoring | `disk_usage_monitor.sh` alerts when any filesystem passes 80% |
| Log rotation | `rotate_logs.sh` compresses and expires logs |
| Scheduling | Ansible installs the cron jobs automatically |

**Tech:** RHEL, Ubuntu, Ansible, Bash, cron

## Project structure

```
linux-ansible-automation/
├── site.yml                  # master playbook
├── ansible.cfg
├── inventory/hosts.ini       # localhost by default, remote examples included
├── group_vars/all.yml        # users, packages, thresholds, retention
├── vars/{RedHat,Debian}.yml  # OS-specific package/service names
├── playbooks/
│   ├── packages.yml
│   ├── users.yml
│   ├── services.yml
│   └── deploy_scripts.yml    # copies scripts + creates cron jobs
├── scripts/
│   ├── backup.sh
│   ├── disk_usage_monitor.sh
│   └── rotate_logs.sh
├── cron/crontab.example
└── docs/screenshots/
```

## Quick start

```bash
# 1. Install Ansible
sudo apt install -y ansible          # Ubuntu
# sudo dnf install -y ansible-core   # RHEL / Rocky / Alma

# 2. Clone
git clone https://github.com/vikasjeurkar/linux-ansible-automation.git
cd linux-ansible-automation

# 3. Dry run, then apply
ansible-playbook site.yml --syntax-check
ansible-playbook site.yml --check
ansible-playbook site.yml
```

Run a single part: `ansible-playbook playbooks/users.yml`

To target remote servers, edit `inventory/hosts.ini` and add `-K` if sudo needs a password.

## Verify

```bash
id opsadmin                                   # user created
sudo crontab -l                               # cron jobs installed
sudo /opt/automation/scripts/backup.sh        # run a backup now
ls -lh /var/backups/automation                # backup archives
sudo /opt/automation/scripts/disk_usage_monitor.sh
tail /var/log/automation/cron.log
```

## Screenshots

**Ansible playbook run**
![Playbook run](docs/screenshots/01-ansible-playbook-run.png)

**Users created**
![Users](docs/screenshots/02-users-created.png)

**Cron jobs installed**
![Cron](docs/screenshots/03-cron-jobs.png)

**Backup script output**
![Backup](docs/screenshots/04-backup-output.png)

**Disk usage monitor**
![Disk monitor](docs/screenshots/05-disk-monitor.png)

## Configuration

Edit `group_vars/all.yml` to change backup sources, retention days, disk threshold, users and packages.

## Author

Vikas Jeurkar - [GitHub](https://github.com/vikasjeurkar)
