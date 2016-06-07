#! /bin/bash

basic ()
{
  #print hostname
  echo "Hostname: $(hostname)"       

  #print linux version
  echo "Linux vesion: $(cat /etc/issue)"    

  #print architecture
  echo "Architecture: $(lscpu | grep Architecture | awk '{print $2}')"  
-+
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
  > /tmp/out
  echo "Disk usage:"
  DIRECTORIES=$(cat /etc/passwd | awk -F":" '{print $6}')

  for I in $DIRECTORIES;
  do
    if [ -a $I ]; then
      du -sh --block-size=10 $I >> /tmp/out 2> /tmp/error
    fi
  done

  C=$(sort -k1 -nr /tmp/out | awk '{print $2}')
  D=$(cat /etc/passwd)
  COUNT=0
  for I in $C;
  do
    for J in $D;
    do
      E=$(echo "$J" | awk -F":" '{print $6}')
      if [ "$E" == "$I" ] && [ $COUNT -lt 3 ]; then
        USER=$(echo "$J" | awk -F":" '{print $1}')
        LOCATION=$(echo "$J" | awk -F":" '{print $6}')
        SIZE=$(du -sh --block-size=10 $LOCATION 2> /tmp/error | awk '{print $1}')
        
        echo "$USER $SIZE $LOCATION"
        ((COUNT+=1))
      fi
    done  
  done
}

if [ $(id -u) -eq 0 ]; then
  if [ $# == 0 ]; then
    basic
  elif [ $1 == "-d" ] || [ $1 == "--disk-usage" ]; then 
    basic
    disk
  elif [ $1 == "-h" ] || [ $! == "--help" ]; then
    echo "Prints system information. Must be run as root"
    echo "usage: ./sysinfo [--help] [--disk-usage]" 
  else
    echo "check param"
  fi  
else
  echo "Not root user"
fi


