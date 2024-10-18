## Simple script to copy over job configurations

#!/bin/bash
echo "Removing old jobs"
git rm -r jobs
echo "Copying new jobs"
rsync -rmv --include='*/' --include="config.xml" --exclude="*" jenkins_home/jobs .
echo "Staging jobs directory"
git add jobs