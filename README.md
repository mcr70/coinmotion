# coinmotion.sh
A script to interact with Coinmotion [API](https://api.coinmotion.com/docs/apicoinmotion.html)

## Getting the balances
To get the balances of your crypto wallets in coinmotion, type

```
coinmotion.sh balances
```

## Getting the buying and selling rates
Buying and selling rates are fetched with this command. the currencyCode reported is the
one being used with `buy` and `sell` commands

```
coinmotion.sh rates
```

## Value of crypto wallets
Following command calculates values of your crypto wallets. and prints out a sum of all of the wallets.
The value is calculated using buying rates. I.e. if you would sell, this would be the amount received.
Note, that coinmotion issues a fee which is not calculated to values.

```
coinmotion.sh values
```

## To sell crypto
Selling is done using following command. crypto is one of currencyCodes seen in `rates` command
```
coinmotion.sh sell <crypto> <amount_in_cents>
```

## To buy crypto
Buying is done using following command. crypto is one of currencyCodes seen in `rates` command
```
coinmotion.sh buy <crypto> <amount_in_cents>
```
