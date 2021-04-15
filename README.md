# Tech Writer Notify

GitHub Action which sends notification emails for Tech Writers

## Build Docker Image

```
docker build -t tech-writer-notify .
```

## Run notification script

### Locally

```
export MAILGUN_API_TOKEN=*******
export MAILGUN_MAILBOX=*******

./lib/tech-writer-notify.sh -s a@example.com -r b@example.com -p example/repo -g $YOUR_REPO_HERE
```

### Via Docker

```
cd $YOUR_REPO_HERE

docker run -ti --rm \
  -v $(pwd):/github/workspace \
  --workdir="/github/workspace" \
  --env PROJECT=example/repo \
  --env SENDER_EMAIL=john@example.com \
  --env RECIPIENT_EMAIL=jane@example.com \
  --env MAILGUN_API_TOKEN=xxxx \
  --env MAILGUN_MAILBOX=example.com \
  tech-writer-notify
```
