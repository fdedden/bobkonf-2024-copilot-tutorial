#!/bin/bash

# Temporarily change to the exercise's dir, run make and if successful run the
# project afterwards.

set -e

dir=`dirname $0`

cd ${dir}
make -B uav && ./uav
