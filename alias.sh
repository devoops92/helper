#!/bin/bash

ES_URI="http://sbapp:9200"

curl -XPOST $ES_URI"/_aliases" -H 'Content-Type: application/json' -d '
{
  "actions": [
    {
      "add": {
        "index": "sabang_prod_order_s400",
        "alias": "sb_prod_order_s400"
      }
    }
  ]
}'
