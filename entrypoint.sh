#!/bin/sh -l

pwd

git log

/lib/tech-writer-notify.sh -g . -s $SENDER_EMAIL -r $RECIPIENT_EMAIL  
