## Simple script to copy over job configurations

#!/bin/bash
git rm -r jobs
rsync -rmv --include='*/' --include="config.xml" --exclude="*" jenkins_home/jobs .
git add jobs