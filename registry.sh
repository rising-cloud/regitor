new-registry(){
    read -p "Name of new Registry : " name
    read -p "Enter port on which '$name' to be run : " port

    docker run -d -p $port --restart=always --name $name registry
}


upload(){

    read -p "Enter image name/id : " image
    read -p "Name the Image : " name
    read -p "Enter registry port on which image is to be pushed : " port

    docker tag $image localhost:$port/$name
}

#if [ $1 == 'registry' ]
#then
#    echo 'Begin process'
#fi