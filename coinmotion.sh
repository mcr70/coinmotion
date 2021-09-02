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

# Create a signature to be used in API calls
time=$(date +%s)
body='{"nonce":"'$time'"}'
signature=$(echo -n $body | openssl dgst -sha512 -hmac $APISECRET)


function usage {
  echo "Usage:"
  echo "  Use following commands to get the balances of crypto wallets, "
  echo "  buy or sell crypto currencies, get the buying and selling rates of"
  echo "  crypto currencies, or get the value of crypto wallets"
  echo "    $ $(basename $0) balances"
  echo "    $ $(basename $0) buy"
  echo "    $ $(basename $0) sell"
  echo "    $ $(basename $0) rates"
  echo "    $ $(basename $0) value"
}

# Get the balances of all the crypto wallets
function balances {
  RESULT=$(curl -s -X POST -H "Content-Type: application/json" \
              -H "X-COINMOTION-APIKEY: $APIKEY" \
              -H "X-COINMOTION-SIGNATURE: $signature" \
        -d "$body" \
        https://api.coinmotion.com/v1/balances)

  if [ `echo $RESULT | jq .success` == "true" ]; then
    echo $RESULT | jq '.payload | with_entries( select(.key|contains("_bal") ))'
  else
    echo $RESULT | jq .
    exit 1
  fi
}

function buy {
  echo buy
}

function sell {
  echo sell
}

# Get the buy and sell rates of different crypto currencies
function rates {
  rates=$(curl -s https://api.coinmotion.com/v2/rates | jq '.payload  | [with_entries( select(.key|contains("'Eur'")))[] | { currencyCode: .currencyCode, buy: .buy, sell: .sell}]')
  echo $rates | jq .
}

# Print the value of different crypto wallets, and calculate total
function value {
  rates=$(rates)
  balances=$(balances)

  currencies="btc ltc eth xrp xlm aave link uni"
  printf '%-9s %-12s %-13s %s\n' Currency Balance Rate Value
  total="0"

  for cur in $currencies; do
    CUR=`echo $cur | tr '[:lower:]' '[:upper:]'`
    bal=`echo $balances | jq -r .${cur}_bal`
    rate=`echo $rates | jq -r '.[] | select (.currencyCode=="'$CUR'") | .buy'`
    val=$(echo "$bal*$rate" | bc)
    total="$total+$val"  

    printf '%-7s %13.6f %13.6f %8.2f\n' $CUR $bal $rate $val
  done

  total=`echo $total | bc`
  printf '%44s\n' "========"
  printf '%44.2f\n' $total
}

case $1 in
  balances)
    balances
    ;;
  buy)
    buy
    ;;
  sell)
    sell
    ;;
  rates)
    rates
    ;;
  value)
    value
    ;;
  *)
    usage
    ;;
esac

###
