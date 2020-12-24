#!/bin/bash

SET=$(seq 0 9)
for i in $SET
do
  echo "######### sabang-order-$i.conf ############"
  echo "sed -i '"s/.order_x_last_run/.order_"$i"_last_run/g"' ./sabang-order-$i.conf"
  sed -i "s/.order_x_last_run/.order_"$i"_last_run/g" ./sabang-order-$i.conf
  sed -i "s/rtl_order_x/rtl_order_"$i"/g" ./sabang-order-$i.conf
  sed -i "s/rtl_order_prod_x/rtl_order_prod_"$i"/g" ./sabang-order-$i.conf
  sed -i "s/x_${idx}/"$i"_${idx}/g" ./sabang-order-$i.conf
done
