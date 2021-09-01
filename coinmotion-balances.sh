#!/bin/bash
#
# A script to get balances of crypto wallets from coinmotion.
#
# This generator can be used to create signature correctly:
# https://www.liavaag.org/English/SHA-Generator/HMAC/
#

dir=$(dirname $0)
. $dir/.coinmotion.secrets
if [ -z $APIKEY ]; then
  echo "Configure APIKEY and APISECRET in file $dir/.coinmotion.secrets"
  exit 1
fi

time=$(date +%s)
body='{"nonce":"'$time'"}'
signature=$(echo -n $body | openssl dgst -sha512 -hmac $APISECRET)

RESULT=$(curl -s -X POST -H "Content-Type: application/json" \
             -H "X-COINMOTION-APIKEY: $APIKEY" \
             -H "X-COINMOTION-SIGNATURE: $signature" \
       -d "$body" \
       https://api.coinmotion.com/v1/balances)

if [ `echo $RESULT | jq .success` == "true" ]; then
  echo $RESULT | jq '.payload | with_entries( select(.key|contains("_bal") ))'
else
  echo $RESULT | jq .
fi

###
