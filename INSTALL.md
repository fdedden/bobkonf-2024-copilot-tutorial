# Installation

In order to run Copilot and use the exercises in this repository, we need:

1. A POSIX compatible host system, e.g. most Linux or MacOS. Windows probably
   works as well.
2. Have `make` and `docker` installed.
3. Be able to run Docker images.

Once the requirements are met, the provided docker image needs to be build. The
repository provides a `Makefile`. From the root of the repository execute:

```sh
$ make build
```

This will build a Debian testing based image containing a Copilot installation.
If this build succeeds, your system is ready to use.
