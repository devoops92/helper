#!/bin/bash

SET=$(seq 0 9)
for i in $SET
do
  cp sabang-order-origin.conf sabang-order-$i.conf
done
