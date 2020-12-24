#!/bin/bash
HOME_PATH="/home/logstash/product"

SABANG_DB="s400"
LS_CONFIG_PATH="$HOME_PATH/config"

export SABANG_DB
export LS_CONFIG_PATH

PID_NAME="product.pid"
PID_PATH="$HOME_PATH/$PID_NAME"

function check_has_pid_file {
    if [ ! -f $PID_PATH ]; then
        echo "Not found PID file : $PID_PATH"
         exit 1
    fi
}

function check_running_process {
    PID=$1
    if ps -p $PID > /dev/null; then
        return 0;
    else
        return 1;
    fi
}

function get_pid {
    echo $(cat $PID_PATH)
}

function get_config {
    echo "# 사용가능한 conf 파일"
    FILES="$(ls $LS_CONFIG_PATH/*.conf)"
    for i in $FILES
    do
        FILE="$(echo $i | cut -d '/' -f 6)"
        echo "- $FILE"
    done
    echo ""
    echo "# 실행방법"
    echo "$0 start config {위 파일중 하나}"
}

function get_pipeline {
    echo "# pipeline.yml 정보"
    PIPELINES="$(grep -v '#' $LS_CONFIG_PATH/pipelines.yml)"
    echo "$PIPELINES"
    echo ""
    echo "# 실행방법"
    echo "$0 start pipeline"
}

function start_option {
    START_OPT=$1
    CONFIG_FILE=$2
    case "$START_OPT" in 
        config)
            nohup $HOME_PATH/bin/logstash -f $LS_CONFIG_PATH/$CONFIG_FILE 1>/dev/null 2>&1 & echo $! > $PID_PATH
            echo "nohup $HOME_PATH/bin/logstash -f $LS_CONFIG_PATH/$CONFIG_FILE  & echo $! > $PID_PATH"
            echo "logstash $CONFIG_FILE started ..."
            ;;
        pipeline)
            nohup $HOME_PATH/bin/logstash 1>/dev/null 2>&1 & echo $! > $PID_PATH
#nohup $HOME_PATH/bin/logstash 2>&1 & echo $! > $PID_PATH
            echo "nohup $HOME_PATH/bin/logstash 1>/dev/null 2>&1 & echo $! > $PID_PATH"
            echo "logstash started ..."
            ;;
        *)
            echo "Start Option: $0 start {config|pipeline}"
            exit 1
    esac
}

case "$1" in
    status)
        check_has_pid_file
        PID=$(get_pid)
        if check_running_process $PID; then
            echo "logstash is running"
        else
            echo "logstash is not running"
        fi
        ;;
    start)
        PID=$(get_pid)
        if [ -f $PID_PATH ] && check_running_process $PID; then
            echo "logstash ( $(get_pid) ) already running"
            exit 1
        fi
        start_option $2 $3
        ;;
    stop)
        PID=$(get_pid)
        check_has_pid_file
        if ! check_running_process $PID; then
            echo "logstash already stopped"
            exit 0
        fi

        kill -15 $(get_pid)
        echo -ne "Waiting for process to stop"
        NOT_KILLED=1
        for i in {1..360}; do
            if check_running_process $PID; then
                echo -ne "."
                sleep 1
            else
                NOT_KILLED=0
                echo
                echo "Success to stop logstash!"
                break
            fi
        done

        if [ $NOT_KILLED = 1 ]; then
            echo "Cannot kill process $(get_pid)"
            exit 1
        fi
        ;;
    restart)
        $0 stop
        if [ $? = 1 ]
        then
            exit 1
        fi
        $0 start
        ;;
    config)
        get_config
        ;;
    pipeline)
        get_pipeline
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|config|pipeline}"
        exit 1
esac
