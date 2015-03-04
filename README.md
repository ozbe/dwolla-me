# dwolla-me
Side project Dwolla app I worked on while watching TV.

## Background
This project is [abandoned](https://wordnik.com/words/abandoned). It was a side project I found buried in my Dropbox and thought there may be some useful code to others. 

It shows examples of integrating with the Dwolla [Rest API](https://docs.dwolla.com) and [OAuth](https://developers.dwolla.com/dev/pages/auth). 

It does not always show best practices for [async](http://www.objc.io/issue-2/), memory management, naming, [auto layout](http://code.tutsplus.com/categories/auto-layout), [code organization](http://www.objc.io/issue-1/) or...

It does not show best practices for testing... I'm pretty sure I was too distracted by [House of Cards](http://en.wikipedia.org/wiki/House_of_Cards_(U.S._TV_series)) when I was hacking on this project.

I'm going to try to leverage some of the DataAccess code to make a new [Dwolla iOS library](https://github.com/ozbe/dwolla-ios-sdk) as I find time.

In the mean time feel free to [fork](https://help.github.com/articles/fork-a-repo/) the project, pull it down and run it, or submit [issues](https://github.com/ozbe/dwolla-me/issues) knowing they may never get fixed. But please don't just pull this project down and submit it to the app store with a different name.

Thanks.

## Debug

Out of the box the app will use [uat.dwolla.com](http://uat.dwolla.com) and the app credentials I have for Dwolla Me in that envirornment.

### Change client key and secret

1. Go to `DWOAppConstants.m`
2. Change the values for `kDWOClientKey` and `kDWOClientSecret`

Make sure they are not already url encoded.

### Use Production (dwolla.com, not UAT)

Replace all instances of `kDWOBaseUrlTest` with `kDWOBaseUrlProd` in the project (command+shift+option+F), excluding the instance in `DWORestApiConstants.m`