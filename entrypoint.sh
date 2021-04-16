#!/bin/sh -l

/lib/tech-writer-notify.sh -g . -s $SENDER_EMAIL -r $RECIPIENT_EMAIL -p $PROJECT
/lib/update-tag.sh
