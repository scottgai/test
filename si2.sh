#!/bin/bash
echo "SI_GUID SI_NAME ORG SPACE" | awk '{ printf "%-40s| %-40s|%-40s|%-40s\n", $1, $2 , $3, $4}'

echo "561da063-75d4-49e0-805f-7699bc27b444
8629efff-90ca-4e50-a804-e6af97cc4da0" | while read siguid; do
   read -r siname spaceurl < <(cf curl /v2/service_instances/$siguid | jq -r '"\(.entity.name)  \(.entity.space_url)"' && printf '\0')
   read -r spacename orgurl < <(cf curl $spaceurl | jq -r '"\(.entity.name)  \(.entity.organization_url)"' && printf '\0')
   orgname=$(cf curl $orgurl | jq -r .entity.name)
   echo "$siguid $siname $orgname $spacename" | awk '{ printf "%-40s| %-40s|%-40s|%-40s\n", $1, $2 , $3, $4}'
done
