#!/bin/bash

LOG_FILE="/root/checker/daily/$(date '+%d-%m-%Y')_daily_health.log"


function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function line_1 {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}" | tee -a $LOG_FILE
}

function line_2 {
  echo -e "${RED}##############################################################################${NORMAL}" | tee -a $LOG_FILE
}

function start_work {
  echo "Запуск всех отчетов в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  cd /root/vprofile/node
  }

function nesa_health { 
  echo "Запуск проверки nesa_auto_restart.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory nesa_auto_restart.yml >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "nesa_auto_restart.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении nesa_auto_restart.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function hemi_health { 
  echo "Запуск проверки hemi_health.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  ansible-playbook -i inventory hemi_change_gas.yml >> $LOG_FILE 2>&1

  if [ $? -eq 0 ]; then
      echo "hemi_change_gas.yml выполнен успешно в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  else
      echo "Ошибка при выполнении hemi_change_gas.yml в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
  fi
  sleep 1000
}

function end_work {
  echo "Период отчетов успешно окончен в $(date '+%d-%m-%Y %H:%M:%S')" >> $LOG_FILE
}

line_2
start_work
line_2
nesa_health
line_1
hemi_health
line_1
end_work
line_2
