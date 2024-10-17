## Notes for DHIL Jenkins

### Oct 17, 2024

Now using Docker Compose and inspired by TEIC/Jenkins for jobs configuration.

First, compose and build:

```
docker compose up --build 
```

Then setup administrator stuff (e.g. user accounts etc) for first time builds; don't install plugins since they're already there

And then in the container in `/var/jenkins_home` do:

```
tar xfz jobs.tar.gz 
```

And then go to "Manage Jenkins" -> Tools and Actions -> Reload Configuration from Disk

And then the jobs should all be back in action. Permissions and tokens will need to be reset at the first instance (only on particular jobs)


### Oct 16, 2024

Building:

```
docker build -t sfudhil/jenkins .
```

Running:

```
docker run --rm --name dhiljenkins -p8080:8080 -p 50000:50000 -v /Users/takeda/projects/jenkins/jenkins-data:/var/jenkins_home sfudhil/jenkins
```

According to TEI's Jenkins documentation (from which this more or less derives), you can reset the CSP header via command line but that doesn't totally work. (Probably just missing some sort of apostrophes or whatever).

```
--env JAVA_OPTS="-Dhudson.model.DirectoryBrowserSupport.CSP='default-src self; img-src *'"
```

But that's missing a `'self'` (apostrophes necessary). 

Setting it in the actual Jenkins instance did work (but that's annoying to have to remember):

```
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "default-src 'self'; img-src *;")

```

And to check:

```
System.getProperty("hudson.model.DirectoryBrowserSupport.CSP")
```

Git Credentials are best configured with Tokens set as a Username and password as part of the individual job (though it may be able to be set at a global administrator) — this is necessary for some private repositories etc

Git repos should also have submodule updates

Archiving artifacts --> "dir/**/*" 

How best to store the jobs configuration? Maybe through the .gitignore? E.g.




