# Jenkins Configuration for the DHIL

## Building (first time)

Run:

```
docker compose up --build

```

### Setting up

1. Get the initial Jenkins Admin password `docker exec -it jenkins_app cat /var/jenkins_home/secrets/initialAdminPassword`
1. Go to localhost:8080 and paste the initial admin password provided
1. Do not install recommended plugins, select `Select plugins to install` -> `Install`
1. Create your first Administrator
1. On `Instance Configuration`, ensure that Jenkins Url is `http://localhost:8080/` and click `Save and Finish`

All jenkins information should then be in `.data/jenkins_home/`
