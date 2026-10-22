# tech613-node-app

Node.js 20 tic-tac-toe app, plus a Bash script that deploys it to a fresh Ubuntu 24.04 VM.

## Deploy

On a new Ubuntu 24.04 VM (security group open on ports 22 and 80):

```bash
curl -sL https://raw.githubusercontent.com/uniiicycle/tech613-node-app/main/provision-app.sh -o provision-app.sh
bash provision-app.sh
```

Then open `http://<public-ip>`.

## What the script does

1. Updates and upgrades packages, with no prompts.
2. Installs NGINX and Git.
3. Sets up NGINX as a **reverse proxy**, so traffic on port 80 goes to the app on port 3000.
4. Installs Node.js 20 and PM2 (skips them if they're already installed).
5. Runs `git clone` on this repo the first time, and `git pull` after that.
6. Runs `npm install`, then starts the app in the background with PM2.

It's **idempotent**: run it again and you still have one copy of the app running.
