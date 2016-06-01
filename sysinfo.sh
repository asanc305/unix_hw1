#! /bin/bash

basic ()
{
  #print hostname
  hostname       

  #print linux version
  echo "Linux vesion" cat /etc/issue    

  #print architecture
  uname -a | awk '{print $12}'  

  #print username and id
  echo "User: $USER (ID $(id -u))"

  #print number of users
  cat /etc/passwd | wc -l

  #print number of processes
  ps -e | wc -l

  
  
}

if [ $# == 0 ]; then
  basic
elif [ $1 == "-d" ]; then 
  echo "option 1"
elif [ $1 == "-h" ]; then
  echo "option 2"
else
  echo "check param"
fi  


