## Simple script to copy over job configurations

#!/bin/bash

rsync -rmv --include='*/' --include="config.xml" --exclude="*" jenkins-data/jobs .