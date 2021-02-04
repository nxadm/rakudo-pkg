#!/bin/sh -e
cd $1
pip3 install --user cloudsmith-cli
chmod +x *.sh
for i in *.sh; do
  ./$i
done