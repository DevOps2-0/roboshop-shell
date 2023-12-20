#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started execution at $TIMESTAMP" &>> $LOGFILE

VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e "$2... $R Failed $N"
        exit 1
    else
        echo -e "$2,,, $G Success $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROr:: Please run this script with root user $N"
    exit 1
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling current nodeJS " 

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabling nodeJS " 

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing nodeJS 18" 

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exists $Y Skipping $N"
fi

mkdir -p /app
VALIDATE $? "Creation app direcotry"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "Download application code"

cd /app

unzip -o /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "Extracting catalogue"

cd /app

npm install &>> LOGFILE
VALIDATE $? "Downloading the dependencies"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "systemd catalogue setup"

systemctl daemon-reload &>> LOGFILE
VALIDATE $? "systemd daemon reload"

systemctl enable catalogue &>> LOGFILE
VALIDATE $? "enabling catalogue"

systemctl start catalogue &>> LOGFILE
VALIDATE $? "start catalogue"



