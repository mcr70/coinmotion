#!/bin/bash
#
# This script prints out the value of your crypto currencies
#

dir=$(dirname $0)
# Get the current rates and balances
rates=$($dir/coinmotion-rates.sh)
balances=$($dir/coinmotion-balances.sh)

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

###
