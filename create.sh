[[ $1 == '' ]] && stackname="UdacityProject" || stackname="$1"
[[ $2 == '' ]] && body="file://project2.yml" || body="file://$2"
[[ $3 == '' ]] && parameters="file://parameters.json" || parameters="file://$3"

aws cloudformation create-stack --stack-name $stackname --template-body $body --parameters $parameters