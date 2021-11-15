# Funtion Calling
#   => place "-f" option before the name of function in cmd (command line)
#       => Eg. >>> registry -f new-registry [filename]  --- (filename <- optional)
#       =>     Note = First source this file to run it in this way


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
#              username =  Username for auth login ; Not needed if auth is 0
#              password =  Password for auth login ; Not needed if auth is 0
#              cert     =  0 or 1  => 0 = (no certificate  ; 1 means put certificate) to registry
#

fileReader(){

    # $1 = filename

    if [[ ! -z $(tail -1c $1) ]]; then echo "" >> $1; fi

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
                        value=$( echo "$line" | cut -d "$splitor" -f 2 );
                        value="${value// /}";
                        values[$e-1]=$value;
                        echo $key = $value;
                        break;
                    fi
                done
            fi
        done
    done < $1

}


new-registry(){

    # $1 => filename

    keys=(name port cert auth username password)
    for i in $(seq ${#keys[@]}); do values[$i-1]="<blank>"; done

    reqReader[0]() { 
        while [[ "${values[0]}" == "<blank>" || "${values[0]}" == "" || -d "${values[0]}" ]];
        do
            read -p "Name of new Registry : " values[0]; 
        done
    }

    reqReader[1]() { 
        while [[ ! ${values[1]} =~ [0-9]:[0-9]+$ ]];
        do 
            read -p "Enter port on which this registry is to be run : " values[1]; 
        done
    }

    reqReader[2]() { 
        while true
        do
            read -p "Get certificate of this registry ? (y/n) : " values[2]
            yn=${values[2],,}
            
            if [[ "$yn" == "y" || "$yn" == "ye" || "$yn" == "yes" ]]; then values[2]=1; break;
            elif [[ "$yn" == "n" || "$yn" == "no" ]]; then values[2]=0; break;
            else continue; fi
        done
    }

    reqReader[3]() { 
        while true
        do
            read -p "Want to assign password to this registry ? (y/n) : " values[3]
            yn=${values[3],,}

            if [[ "$yn" == "y" || "$yn" == "ye" || "$yn" == "yes" ]]; then values[3]=1; break;
            elif [[ "$yn" == "n" || "$yn" == "no" ]]; then values[3]=0; break;
            else continue; fi
        done
    }

    reqReader[4]() { read -p "Enter username : " values[3]; }
    reqReader[5]() { read -p "Enter password : " values[4]; }

    if [[ "$1" != "" ]]; then fileReader $1 ${keys[@]}; fi
    if [[ "${values[3]}" == "0" ]]; then values[4]="<not_required>"; values[5]="<not_required>"; fi

    for i in $(seq ${#values[@]}); do if [[ "${values[$i-1]}" == "<blank>" ]]; then "reqReader[$((i-1))]"; fi done
    reqReader[1]

    name=${values[0]}; port=${values[1]}; cert=${values[2]}; auth=${values[3]}; username=${values[4]}; password=${values[5]}

    mkdir $name
    touch $name/data.txt
    echo -e "name => $name\nport => $port\ncert => $cert\nauth => $auth\nuser => $username\npass => $password" >> $name/data.txt

    executor="
        docker run -d 
        -p $port 
        --restart=always 
        --name $name
    "

    if [[ "$cert" == "1" ]];then
        mkdir $name/certs
        executor="
            $executor
            -v "$(pwd)"/$name/certs:/certs \
            -e REGISTRY_HTTP_TLS_CERTIFICATE=$name/certs/domain.crt \
            -e REGISTRY_HTTP_TLS_KEY=$name/certs/domain.key \"
        "
    fi

    if [[ "$auth" == "1" ]]; then
        mkdir $name/auth
        docker run --entrypoint htpasswd httpd:2 -Bbn testuser testpassword > $name/auth/htpasswd

        executor="
            $executor
            -v "$(pwd)"/$name/certs:/certs \
            -e REGISTRY_HTTP_TLS_CERTIFICATE=$name/certs/domain.crt \
            -e REGISTRY_HTTP_TLS_KEY=$name/certs/domain.key \"
        "
    fi

    executor="
        $executor
        registry
    "

    $executor

}


args=("$@")

for arg in $(seq ${#args[@]});
do
    if [[ "$1" == "registry" ]]; then
        if [[ "${args[arg-1]}" == "-f" ]]; then
            ${args[arg]} ${args[arg+1]}
        fi
    fi
done

