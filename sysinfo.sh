#! /bin/bash

basic ()
{
  #print hostname
  echo "Hostname: $(hostname)"       

  #print linux version
  echo "Linux vesion: $(cat /etc/issue)"    

  #print architecture
  echo "Architecture: $(lscpu | grep Architecture | awk '{print $2}')"  

  #print username and id
  echo "User: $USER (ID $(id -u))"

  #print number of processes
  echo "Processes: $(ps -e | wc -l)"

  #print number of users
  echo "Users: $(cat /etc/passwd | wc -l)"

  #print number of cores
  echo "Cores: $(lscpu | grep "Core(s)" | awk '{print $4}')"

  #print total memory
  echo "Total Memory: $(cat /proc/meminfo | grep MemTotal | awk '{print $2}') KB"

  #print installed packages
  echo "Installed Packages: $(dpkg --get-selections | grep -v deinstall | wc -l)"

  #print IP addresses
  A=$(ifconfig | grep "inet addr" | awk '{print $2}')
  ADDRESS=""
  for i in $A;
  do
    B=$(echo "$i" | awk -F":" '{print $2}')

    if [ $B != "127.0.0.1" ]; then
      ADDRESS+=" $B"
    fi
  done
  echo "Internet addresses:$ADDRESS"

}

disk () 
{
  #cat /etc/passwd | awk -F":" '{print $6}' | du -sh --block-size=10 2> /tmp/error
  > /tmp/out
  DIRECTORIES=$(cat /etc/passwd | awk -F":" '{print $1} {print $6}')
  echo $DIRECTORIES
  
  #du -sh --block-size=10 $DIRECTORIES 2> /tmp/error #| sort -k1 -n
  for I in $DIRECTORIES;
  do
    if [ -a $I ]; then
      du -sh --block-size=10 $I >> /tmp/out 2> /tmp/error
    fi
  done

  TMP=$(sort -k1 -n /tmp/out)
  COUNT=0

  for I in $TMP;
  do
    echo $I
    #if [ $COUNT -lt 3 ]; then
      #echo $I
      #COUNT+=1
    #fi
  done  
}

if [ $# == 0 ]; then
  basic
elif [ $1 == "-d" ]; then 
  disk
elif [ $1 == "-h" ]; then
  echo "option 2"
else
  echo "check param"
fi  


