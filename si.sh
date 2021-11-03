#!/bin/bash

#IFS=$'\n' read -r -d '' -a my_array < <( cf curl /v2/service_instances | jq -r '.resources[] | "\(.metadata.guid)  \(.entity.space_url)  \(.entity.name)"' && printf '\0' )
#declare -p my_array

declare -A siguids=() spaceurls=() sinames=()
{
  read _; read _ # discard header and leading blank line
  while read -r siguid spaceurl siname; do
    siguids[$siguid]=$siguid
    spaceurls[$siguid]=$spaceurl
    sinames[$siguid]=$siname
  done
} < <(cf curl /v2/service_instances | jq -r '.resources[] | "\(.metadata.guid)  \(.entity.space_url)  \(.entity.name)"' && printf '\0')

# for debugging, print the result of the operation
#declare -p siguids spaceurls sinames

## now loop through the above array
declare -A sigspacenames=()  siorgurls=()
for i in "${siguids[@]}"
do
   # echo "$i"
   #echo "${siguids[$i]}  ${spaceurls[$i]}  ${sinames[$i]}"
   # or do whatever with individual element of the array

   read -r spacename orgurl < <(cf curl ${spaceurls[$i]} | jq -r '"\(.entity.name)  \(.entity.organization_url)"' && printf '\0')
   sigspacenames[$i]=$spacename
   siorgurls[$i]=$orgurl
   
    #echo $spacename  $orgurl
   echo "$i  ${sigspacenames[$i]} ${siorgurls[$i]}"
done


