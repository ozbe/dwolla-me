# dwolla-me
Proof of concept for mobile Dwolla app

## Background
This project is [abandoned](https://wordnik.com/words/abandoned). It was a proof of concept for a mobile Dwolla app and I thought some of the code may prove useful to others. 

It shows examples of integrating with the Dwolla [Rest API](https://docs.dwolla.com) and [OAuth](https://developers.dwolla.com/dev/pages/auth). 

## Debug

Out of the box the app will use [uat.dwolla.com](http://uat.dwolla.com) and the app credentials I have for Dwolla Me in that envirornment.

### Change client key and secret

1. Go to `DWOAppConstants.m`
2. Change the values for `kDWOClientKey` and `kDWOClientSecret`

Make sure they are not already url encoded.

### Use Production (dwolla.com, not UAT)

Replace all instances of `kDWOBaseUrlTest` with `kDWOBaseUrlProd` in the project (command+shift+option+F), excluding the instance in `DWORestApiConstants.m`
