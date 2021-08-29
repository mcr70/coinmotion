#!/bin/bash
#
# This script lists selling rates of crypto currencies from coinmotion. 
#

rates=$(curl -s https://api.coinmotion.com/v2/rates | jq '.payload  | [with_entries( select(.key|contains("'Eur'")))[] | { currencyCode: .currencyCode, buy: .buy, sell: .sell}]')

if [ -z $1 ]; then
  echo $rates | jq .
else
  echo $rates | jq '.[] | (.currencyCode + " " + .sell)'
fi

###
