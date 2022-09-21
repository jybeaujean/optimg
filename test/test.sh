#!/bin/bash

uuid=$(uuidgen)
target=target/$(uuidgen)

cp -rf source $target

sourceSize=`du -h source`
echo "Source directory has a size of : $sourceSize"

sh ../src/optimg.sh $target 1000 85