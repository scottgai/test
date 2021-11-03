#!/bin/bash

#IFS=$'\n' read -r -d '' -a my_array < <( cf curl /v2/service_instances | jq -r '.resources[] | "\(.metadata.guid)  \(.entity.space_url)  \(.entity.name)"' && printf '\0' )
#declare -p my_array

declare -A siguids=() spaceurls=() sinames=() sispacenames=()  siorgnames=()
{
  read _; read _ # discard header and leading blank line
  while read -r siguid spaceurl siname; do
    siguids[$siguid]=$siguid
    spaceurls[$siguid]=$spaceurl
    sinames[$siguid]=$siname

   read -r spacename orgurl < <(cf curl $spaceurl | jq -r '"\(.entity.name)  \(.entity.organization_url)"' && printf '\0')
   sispacenames[$siguid]=$spacename

   siorgnames[$siguid]=$(cf curl $orgurl | jq -r .entity.name)
    
  done
} < <(cf curl /v2/service_instances | jq -r '.resources[] | "\(.metadata.guid)  \(.entity.space_url)  \(.entity.name)"' && printf '\0')

#declare -p siguids spaceurls sinames sispacenames  siorgnames

echo "SI_GUID SI_NAME ORG SPACE" | awk '{ printf "%-40s| %-40s|%-40s|%-40s\n", $1, $2 , $3, $4}'
for i in "${siguids[@]}"
do
   # echo "$i"
   #echo "${siguids[$i]}  ${spaceurls[$i]}  ${sinames[$i]}"
   echo "$i ${sinames[$i]} ${siorgnames[$i]} ${sispacenames[$i]}" | awk '{ printf "%-40s| %-40s|%-40s|%-40s\n", $1, $2 , $3, $4}'
done
