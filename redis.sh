#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33"
N="\e[0"

MONGODB_HOST=mongodb.ikart.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2... $R Failed $N"
        exit 1
    else
        echo -e "$2.. $G Success $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "Repos installation"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "Enabling repos"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
VALIDATE $? "allowing remote connection"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "Engabling redis"

systemctl start redis &>> $LOGFILE
VALIDATE $? "Starting redis"