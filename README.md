# Tech Writer Notify

GitHub Action which sends notification emails for Tech Writers

## Build Docker Image

```
docker build -t tech-writer-notify .
```

## Run notification

```
cd $YOUR_REPO_HERE

docker run -ti --rm \
  -v $(pwd):/src \
  --env SENDER_EMAIL=john@example.com \
  --env RECIPIENT_EMAIL=jane@example.com \
  --env MAILGUN_API_TOKEN=xxxx \
  --env MAILGUN_MAILBOX=example.com \
  tech-writer-notify
```
