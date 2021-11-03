args="${@:2}"


for arg in $args
do
    if [ "${arg:0:1}" == "-" ]
    then
        echo 'Option here!'
    fi
done

if [ $1 == 'registry' ]
then
    echo 'Begin process'
fi