# Jenkins Configuration for the DHIL

## Building (first time)

Run:

```
docker compose up --build 

```

### Setting up

1. Go to localhost:8080 and copy the initial admin password provided
1. Do not install recommended plugins
1. In the container, update the jobs by running `tar xfz jobs.tar.gz` And then go to "Manage Jenkins" -> Tools and Actions -> Reload Configuration from Disk. And then the jobs should all be back in action. Permissions and tokens will need to be reset at the first instance (only on particular jobs in private repositories). 

All information should then be in `./jenkins_home/`

## Changes to Job Configuration

Any changes made to jobs (new jobs, new settings) are not backed up automatically. To save configuration changes, run:

```
sh ./scripts/copy-jobs.sh
```

This refreshes the `./jobs/` directory, but does not commit the changes — check that everything looks good and then commit.