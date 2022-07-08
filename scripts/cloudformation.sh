#!/bin/bash

function help(){
    echo "Usage: ./$(basename $0)"
}
random_string() {
    #the probability of 2 generated strings being the same in a day is unlikely enough to make not complicate things more.
    echo --stack-name stack-$(date +%F)-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-4} | head -n 1)
}

SHORT=c,d,u,f:,p:,l::,v:,h
LONG=create,delete,update,name::,file:,parameters:,list::,validate:,help
OPTS=$(getopt -o $SHORT --long $LONG -- "$@")
#if the command is deploy, it'll need to have a template-file
file_flag=0
#if a name is not specified a random name depending on the date and a hash will be generated
name_flag=0
eval set -- "$OPTS"

while true; do
    case "$1" in
        -c | --create)
            cloudformation_command="aws cloudformation create-stack "
            file_flag=1
            name_flag=1
            # shift
            ;;
        -d | --delete)
            cloudformation_command="aws cloudformation delete-stack "
            delete_flag=1
            # shift
            ;;
        -u | --update)
            cloudformation_command="aws cloudformation update-stack "
            file_flag=1
            name_flag=1
            # shift
            ;;
        --name)
            stack_name="--stack-name $( [[ -z $2 ]] && random_string || echo $2)"
            name_flag=0
            delete_flag=0
            shift
            ;;
        -f | --file)
            shift
            [[ -f $1 ]] || {
                echo "template file doesn't exist"
                exit 1
            }
            file_flag=0
            template_body="--template-body file://$1"
            ;;
        -p | --parameters)
            shift
            [[ -f $1 ]] || {
                echo "parameters file doesn't exist"
                exit 1
            }
            file_flag=0
            parameters="--parameters file://$1"
            ;;
        -l | --list)
            shift
            query="--query \"Stacks[].{"
            cloudformation_command="aws cloudformation describe-stacks "
            [[ -z "$1" ]] && break
            [[ "$1" == *'a'* ]] && {
                cloudformation_command+="--query Stacks[].{StackId:StackId,StackName:StackName,Description:Description}"
                echo $cloudformation_command
                exit 1
            }
            [[ "$1" == *'i'* ]] && query+="StackId:StackId,"
            [[ "$1" == *'n'* ]] && query+="StackName:StackName,"
            [[ "$1" == *'d'* ]] && query+="Description:Description,"
            query=${query::-1}'}"'
            cloudformation_command+=$query
            ;;
        -v | --validate)
            shift
            [[ -f $1 ]] || {
                echo "template file doesn't exist"
                exit 1
            }
            cloudformation_command="aws cloudformation validate-template "
            template_body="--template-body file://$1"
            break
            ;;
        --)
            # echo exit
            shift
            break
            ;;
    esac
    shift
done
if [[ file_flag -eq 1 ]]; then
    echo -e "you forgot to specify the file \n-f file.yml "
    exit 1
    [[ name_flag -eq 1 ]] && {
        stack_name="--stack-name $(random_string)"
        name_flag=0
    }
fi
if [[ delete_flag -eq 1 ]]; then
    names=$(aws cloudformation describe-stacks --query "Stacks[].{StackName:StackName}")
    [[ "names" = "[]" ]] && {
        echo $names
        echo -n "stack-name: "
        read stack_name
    } || {
        echo "there are no stacks to delete"
        exit 0
    }
fi
echo $cloudformation_command $stack_name $template_body $parameters
# echo $( [[ -z $stack_name ]] && random_string || echo $stack_name)
# set