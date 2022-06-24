#!/bin/bash

#a script that automatically parses a yaml file to create a corresponding parameter.json file

if [[ $# -eq 0 ]]; then
    echo "No arguments supplied... exiting"
    exit 1
elif [[ ! -f $1 ]]; then
    echo "File doesn't exist... exiting"
    exit 1
fi
#gets the parameter from the specified file
parameters=($(sed '/Parameters:/,/^[A-Z]/!{/Parameters:/!{/^[A-Z] /!d}}' $1 | sed '1d; $d' | sed '/\ \ \ \ /d' | sed 's/://' | sed 's/\ \ //')) || (echo "error occured while parsing... exiting" ; exit 0)

#takes the objects and encapsulates them in square brackets
function encapsulate_array(){
    echo -e "[\n$1\n]"
}
# encapsulate_array "$(encapsulate_object josn)"
for i in "${parameters[@]}"; do
    echo -n "$i: "
    read ParameterValue
    objects+="\t{\n\t\t\"ParameterKey\": \"$i\",\n\t\t\"ParameterValue\": \"$ParameterValue\"\n\t},\n"
done
if [[ $2 ]]; then
    echo -e "[\n${objects:0:-3}\n]" > $2
else
    echo -e "[\n${objects:0:-3}\n]" > parameters.json
fi
exit 1