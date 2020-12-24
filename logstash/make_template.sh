curl -s -H "Content-Type:application/json" -XDELETE "http://123.2.134.118:9200/_template/sabang_template" 

curl -s -H "Content-Type:application/json" -XPOST "http://123.2.134.118:9200/_template/sabang_template" -d @sabang_mapping.json
