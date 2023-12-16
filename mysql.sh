#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33"
N="\e[0"

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

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "disabling mysql module"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "Copyied mysql repo"

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "Installing MySQL"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "enabling MySQL"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "Starts MySQL"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "Setting MySQL Root password"
