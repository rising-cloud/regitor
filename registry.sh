y=("y" "Y" "yes" "Yes")

new-registry(){
    read -p "Name of new Registry : " name
    read -p "Enter port on which '$name' to be run : " port
    
    
    while true
    do
    
        read -p "Want to assign password to this registry ? (y/n) : " yn
        yn=${yn,,}

        if [[ "$yn" == "y" || "$yn" == "yes" ]];
        then
            docker run -d \
            -p $port \
            --restart=always \
            --name $name \
            -v "$(pwd)"/auth:/auth \
            -e "REGISTRY_AUTH=htpasswd" \
            -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
            -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
            -v "$(pwd)"/certs:/certs \
            -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
            -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
            registry
            return
        elif [[ "$yn" == "n" || "$yn" == "no" ]];
        then
            echo docker run -d -p $port --restart=always --name $name registry
            return
        fi

    done

}

upload(){

    read -p "Enter image name/id : " image
    read -p "Name the Image : " name
    read -p "Enter registry port : " port

    docker tag $image localhost:$port/$name
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


if [ $1 == 'registry' ]
then
    echo 'Begin process'
    "$2"
fi