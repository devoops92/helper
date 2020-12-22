#!/bin/bash

APP_NAME=$0
VERSION="7.9.3"
JOB=""

help() {
  echo "$APP_NAME [OPTIONS]"
  echo "    -h         도움말 출력"
  echo "    -v ARG     elastic stack 버전"
  echo "    -j ARG     수행할 job (download, unzip, rename)"
  exit 0
}


down() {
  echo "## Downloading Kibana-$VERSION"
  wget https://artifacts.elastic.co/downloads/kibana/kibana-$VERSION-linux-x86_64.tar.gz 

  echo "## Downloading ElasticSearch-$VERSION"
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$VERSION-linux-x86_64.tar.gz 

  echo "## Downloading Logstash-$VERSION"
  wget https://artifacts.elastic.co/downloads/logstash/logstash-$VERSION.tar.gz

  echo "## Downloading Metricbeat-$VERSION"
  wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$VERSION-linux-x86_64.tar.gz
}

zip() {
  echo "## Unpacking Logstash-$VERSION"
  tar -xvf logstash-$VERSION.tar.gz

  echo "## Unpacking ElasticSearch-$VERSION"
  tar -xvf elasticsearch-$VERSION-linux-x86_64.tar.gz

  echo "## Unpacking Kibana-$VERSION"
  tar -xvf kibana-$VERSION-linux-x86_64.tar.gz 
}

modify() {
  echo "$VERSION" > .stack_version

  echo "## Rename Kibana-$VERSION"
  mv kibana-$VERSION-linux-x86_64.tar.gz kibana

  echo "## Rename ElasticSearch-$VERSION"
  mv elasticsearch-$VERSION-linux-x86_64.tar.gz elasticsearch

  echo "## Rename Logstash-$VERSION"
  mv logstash-$VERSION.tar.gz logstash
}


while getopts "v:j:h" opt
do 
  case $opt in
    v)
      VERSION=$OPTARG
      ;;
    j)
      JOB=$OPTARG
      ;;
    h) help ;;
    ?) help ;;
  esac
done


case $JOB in
  download)
    down ;;
  unzip)
    zip ;;
  rename)
    modify ;;
  all)
    down
    zip
    modify 
    ;;
esac

