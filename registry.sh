#file format
#   => Sequence not necessary
#   => Every pair of key-value should be in new line
#   => Seperators allows "=" and ">"
#         => key = value
#         => key > value
#   => Keys are required for according to functions
#         => new-registry
#              KEYS        Values
#              name     =  Give your custom name to the registry
#              port     =  Eg. 5000:5000 , 1234:5000 , etc
#              auth     =  0 or 1  => 0 = (no password  ; 1 means put password) to registry
#              username =  Username for auth login
#              password =  Password for auth login
#
#       < Other functions under construction! > 


fileReader(){

    # $1 = filename

    if [[ ! -z $(tail -1c $1) ]]; then
        echo "" >> $1
    fi

    splitors=(":" "=" ">")

    keys=(${@:2})
    values=()
    for i in $(seq ${#keys[@]}); do values[$i-1]="<blank>"; done

    while read -r line; do
        for splitor in ${splitors[@]}
        do
            key=$( echo "$line" | cut -d "$splitor" -f 1 )
            if [ ${#key} -lt ${#line} ];then
            key="${key// /}"
                for e in $(seq ${#keys[@]})
                do
                    if [[ "${key,,}" == "${keys[$e-1],,}" && ${values[$e-1]} == "<blank>" ]]; then
                        value=$( echo "$line" | cut -d "$splitor" -f 2 )
                        value="${value// /}"
                        values[$e-1]=$value
                        echo breaking $key = $value
                        break
                    fi
                done
            fi
        done
    done < $1

}

args=$@

new-registry(){

    # $1 => filename

    keys=(name port auth username password)
    for i in $(seq ${#keys[@]}); do values[$i-1]="<blank>"; done

    reqReader[0]() { read -p "Name of new Registry : " values[0]; }
    reqReader[1]() { read -p "Enter port on which this registry is to be run : " values[1]; }
    reqReader[2]() { 
        while true
        do
            read -p "Want to assign password to this registry ? (y/n) : " yn
            yn=${yn,,}
            if [[ "$yn" == "y" || "$yn" == "ye" || "$yn" == "yes" ]]; then
                auth=1
                break
            elif [[ "$yn" == "n" || "$yn" == "no" ]]; then
                auth=0
                break
            else
                continue
            fi
        done 
    }
    reqReader[3]() { read -p "Enter username : " values[2]; }
    reqReader[4]() { read -p "Enter password : " values[3]; }


    echo value ${values[@]}

    if [[ "$1" != "" ]]; then
        fileReader $1 ${keys[@]}
    fi

    if [[ "${values[2]}" == "1" ]]; then
        echo hooray
    else
        values[3]="<not_required>"
        values[4]="<not_required>"
    fi

    for i in $(seq ${#values[@]}); 
    do
        if [[ "${values[$i-1]}" == "<blank>" ]]; then
            "reqReader[$((i-1))]"
        fi
    done


    if [[ ${values[2]} == "1" ]];
        then
            mkdir $name
            mkdir $name/auth
            docker run \
            --entrypoint htpasswd \
            httpd:2 -Bbn $username $password > $name/auth/htpasswd

            docker run -d \
            -p 5000:5000 \
            --restart=always \
            --name $name \
            -v "$(pwd)"/auth:/auth \
            -e "REGISTRY_AUTH=htpasswd" \
            -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
            -e REGISTRY_AUTH_HTPASSWD_PATH=/$name/auth/htpasswd \
            -v "$(pwd)"/certs:/certs \
            -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
            -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
            registry
            return
        else
            echo docker run -d -p $port --restart=always --name $name registry
        fi

}

upload(){

    read -p "Enter image name/id : " image
    read -p "Name the Image : " name
    read -p "Enter registry port : " port

    docker tag $image localhost:$port/$name
    docker push localhost:5000/$name
}

pull(){
    read -p "Enter registry port : " port
    read -p "Enter Image name : " image

    docker pull localhost:$port/$image
}

stop-registry(){
    read -p "Enter registry Name : " registry
    docker container stop $registry
}

new-registry hello.txt