#!/bin/bash
while getopts p:n:s: flag
do
    case "${flag}" in
        p) prompt=${OPTARG};;
        n) number=${OPTARG};;
        s) size=${OPTARG};;
    esac
done

echo $prompt
echo $number
echo $size

JSON_STRING="{
\"prompt\":\"${prompt}\",
\"n\":\"${number}\",
\"size\":\"${size}\"
}"

curl https://api.openai.com/v1/images/generations \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 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' \
  -d ${JSON_STRING}