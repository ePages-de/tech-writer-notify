# Tech Writer Notify

GitHub Action which sends notification emails for Tech Writers

## Usage

To use this action, create a YAML file in the directory `.github/workflows` with such like contents:

```yaml
name: Tech Writer Notify
on:
  push:
    branches: [ master ]
jobs:
  tech_writer_notify:
    runs-on: ubuntu-latest
    env:
      PROJECT: ${{ github.repository }}
      SENDER_EMAIL: noreply@example.com
      RECIPIENT_EMAIL: recipient@example.com
      MAILGUN_API_TOKEN: ${{ secrets.MAILGUN_API_TOKEN }}
      MAILGUN_MAILBOX: ${{ secrets.MAILGUN_MAILBOX }}
    if: github.repository == 'ePages-de/example'
    steps:
      - name: Checkout microservice
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Run Tech Writer notification
        uses: ePages-de/tech-writer-notify@master
```

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
