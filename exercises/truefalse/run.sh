#!/bin/sh

# Simple script for executing the exercise.

set -e

dir=`dirname $0`

runhaskell ${dir}/Main.hs
