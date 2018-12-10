#! /bin/bash

foo(){
    url=${lines[i]} 
    curl -s -o code$i.txt $url 
    if [ $? -ne 0 ]
    then
        echo "$url FAILED"
        echo  "FailedURL" > backup$i.md5
    else
        md5sum code$i.txt | cut -c -32 > code$i.md5 
    
        if [ -e "backup$i.md5" ] 
        then 
            if [ $(cat code$i.md5) != $(cat backup$i.md5) ] 
            then 
                echo "$url UPDATED" 
                cat code$i.md5 > backup$i.md5 
            else 
                echo "$url SAME" 
            fi 
        else 
            cat code$i.md5 > backup$i.md5 
            echo "$url INIT" 
        fi 
        rm code$i.txt 
        rm code$i.md5 
    fi
}


IFS=$'\n' read -d '' -r -a lines < addresses.txt
length=${#lines[@]}

for(( i=0; i<$length; i++ )) 
 do 
    foo "$i" &
 done
 wait

