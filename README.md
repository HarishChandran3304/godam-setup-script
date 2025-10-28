# GoDAM Site Setup Script

Install script to set up GoDAM site locally.

## Usage

1) Create a site
```shell
fm create <site-name> --frappe-branch version-15 --apps erpnext:version-15
```

2) Enter shell 
```shell
fm shell <site-name>
```

3) Set up your git auth credentials
```shell
export GITHUB_USERNAME="<your-github-username>"
export GITHUB_PAT="<your-github-PAT>"
```

4) Run the setup script
```shell
bash <(curl -s https://raw.githubusercontent.com/HarishChandran3304/godam-setup-script/main/site-setup.sh) <site-name>
```
This will fetch, build and install all apps to `<site-name>`

5) Stop and start again to complete setup
```bash
fm stop <site-name>
fm start <site-name>
```
Check `http://<site-name>/app` and `http://<site-name>/web` to make sure everything is working correctly.