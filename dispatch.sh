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
        echo -e "$2... $G Success $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROr:: Please run this script with root user $N"
    exit 1
fi

dnf install golang -y &>> $LOGFILE
VALIDATE $? "Installing golang"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "roboshop user creation"
else
    echo "roboshop user already exists $Y Skipping $N"
fi

mkdir /app &>> $LOGFILE
VALIDATE $? "app direcotry creation"

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip $LOGFILE
VALIDATE $? "Download the dispatch application"

cd /app $LOGFILE

unzip /tmp/dispatch.zip $LOGFILE
VALIDATE $? "Unzipping dispatch"

cd /app 
go mod init dispatch
go get 
go build

cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service $LOGFILE
VALIDATE $? "systemd dispatch service"

systemctl daemon-reload $LOGFILE
VALIDATE $? "daemon reload"

systemctl enable dispatch $LOGFILE
VALIDATE $? "enabling dispatch service"

systemctl start dispatch $LOGFILE
VALIDATE $? "starts dispatch service"