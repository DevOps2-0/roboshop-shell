# roboshop-shell
Build Roboshop Project using shell scripting
<<<<<<< HEAD

roboshop.sh

# To create the instances and route 53 records from roboshop.sh, 

YouTube Session-17
 - https://www.youtube.com/watch?v=5wSLbIUN-XM&list=PL1jY4BuFJn1efO4Sv57kuxMBLt1ThyyUv&index=19

 Create the Role
 Prepare the roboshop.sh script

 from Duration - 36:00

 Roles to resources - 


algorithm
---------------
1. instance creation

aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-087e7afb3a936fce7 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=production}]' 

2. mongodb, mysql, shipping t3.small otherwise t2.micro
3. we need ip address to create route53 record.


aws route53 change-resource-record-sets \
  --hosted-zone-id 1234567890ABC \
  --change-batch '
  {
    "Comment": "Testing creating a record set"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "'" $ENV "'.company.com"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : ""
        }]
      }
    }]
  }
  '
=======
# Test Commit

>>>>>>> f6edfab76d81b11cda020347152ae86b3fa589a3
