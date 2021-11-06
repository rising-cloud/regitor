new-registry(){
    read -p "Name of new Registry : " name
    read -p "Enter port on which '$name' to be run : " port

    docker run -d -p $port --restart=always --name $name registry
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


#if [ $1 == 'registry' ]
#then
#    echo 'Begin process'
#fi