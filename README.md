# Runtime Verification with the Copilot Language

This repository is part of the tutorial 'Runtime Verification with the Copilot
Language, A Hands on Introduction', at BobKonf 2024, March 15 2024. It contains
a set of exercises that is used during the session, together with a
`Dockerfile` for quickly getting a working Copilot installation.


## Overview

This repository contains a number of files and directories:

```
.
├── Dockerfile
├── Makefile
├── README
├── answers
│   ├── trueFalse
│   │   └── Main.hs
│   └── uav
│       └── Main.hs
├── bin
│   └── rundocker
└── exercises
    ├── truefalse
    │   ├── Main.hs
    │   └── run.sh
    └── uav
        ├── Main.hs
        ├── Makefile
        ├── Voting.hs
        ├── flight.c
        ├── flight.h
        ├── run.sh
        └── uav.c
```

The interesting files are:

- `Dockerfile`: defines the Docker image that we will be using.
- `Makefile`: helps us build the Docker image.
- `answers/`: The answers to the exercises.
- `bin/rundocker`: A wrapper script for running things inside Docker.
- `exercises/`: Directory containing exercises. Each exercises has its own
  subdirectory and a `run.sh` script for running it.


## Requirements & Setup

Please see `INSTALL.md` for installation.


## Running the exercises

Each exercise comes with its own `run.sh` script to make things easier. This
script must be ran inside Docker using `bin/rundocker`

For example, to run the `trueFalse` exercise one can:

```sh
$ bin/rundocker exercises/truefalse/run.sh
```

Eventhough the `uav` example is more complicated (it contains some C code and a
Makefile), one can also simply rely on `run.sh` to build and run the exercise.

```sh
$ bin/rundocker exercises/uav/run.sh
```
