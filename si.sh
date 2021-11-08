#!/bin/bash
printpage()
{   
    {
      read _; read _ # discard header and leading blank line
      while read -r siguid spaceurl siname; do
      read -r sispacename orgurl < <(cf curl $spaceurl | jq -r '"\(.entity.name)  \(.entity.organization_url)"' && printf '\0')
      siorgname=$(cf curl $orgurl | jq -r .entity.name)
      echo "$siguid $siname $siorgname $sispacename" | awk '{ printf "%-40s|%-40s|%-40s|%-40s\n", $1, $2 , $3, $4}'
      done
    } < <(echo $resources | jq -r '"\(.metadata.guid)  \(.entity.space_url)  \(.entity.name)"' && printf '\0')
}

## main 
## get first page
onepage=$(cf curl /v2/service_instances)
next_url=$(echo $onepage | jq -r '.next_url')
resources=$(echo $onepage | jq -r '.resources[]')

echo "SI_GUID SI_NAME ORG SPACE" | awk '{ printf "%-40s|%-40s|%-40s|%-40s\n", $1, $2 , $3, $4}'
echo $(yes - | head -n80)
printpage

## get remaining pages
while [ $next_url != "null" ]; do
    onepage=$(cf curl $next_url)
    next_url=$(echo $onepage | jq -r '.next_url')
    resources=$(echo $onepage | jq -r '.resources[]')
    printpage
done