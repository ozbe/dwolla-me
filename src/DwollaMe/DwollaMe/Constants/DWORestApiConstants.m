//
//  DWORestApiConstants.m
//  DwollaMe
//
//  Created by Josh Aaseby on 1/30/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWORestApiConstants.h"

// base urls
NSString * const kDWOBaseUrlProd = @"https://www.dwolla.com/";
NSString * const kDWOBaseUrlTest = @"http://uat.dwolla.com/";

// encodings
NSStringEncoding const kDWODefaultStringEncoding = NSUTF8StringEncoding;

// http methods
// post
// get

// header fields

// scopes
NSString * const kDWOScopeAccountInfoFull = @"AccountInfoFull";
NSString * const kDWOScopeContacts = @"Contacts";
NSString * const kDWOScopeTransactions = @"Transactions";
NSString * const kDWOScopeBalance = @"Balance";
NSString * const kDWOScopeSend = @"Send";
NSString * const kDWOScopeRequest = @"Request";
NSString * const kDWOScopeFunding = @"Funding";
NSString * const kDWOScopeManageAccount = @"ManageAccount";
NSString * const kDWOScopeSeparator = @"|";

// mime types
NSString * const kDWOMimeTypeJson = @"application/json";
NSString * const kDWOMimeTypeHtml = @"text/html";

// contact types
NSString * const kDWOContactTypeDwolla = @"dwolla";
NSString * const kDWOContactTypeEmail = @"email";
NSString * const kDWOContactTypePhone = @"phone";
NSString * const kDWOContactTypeTwitter = @"twitter";

// transaction types
NSString * const kDWOTransactionTypeMoneyReceived = @"money_received";
NSString * const kDWOTransactionTypeMoneySent = @"money_sent";
NSString * const kDWOTransactionTypeWithdrawal = @"withdrawal";
NSString * const kDWOTransactionTypeDeposit = @"deposit";
NSString * const kDWOTransactionTypeFee = @"fee";

// transaction statuses
NSString * const kDWOTransactionStatusCompleted = @"completed";
NSString * const kDWOTransactionStatusPending = @"pending";
NSString * const kDWOTransactionStatusProcessed = @"processed";
NSString * const kDWOTransactionStatusFailed = @"failed";
NSString * const kDWOTransactionStatusCancelled = @"cancelled";
NSString * const kDWOTransactionStatusReclaimed = @"reclaimed";

// funding source id
NSString * const kDWOFundingSourceIdBalance = @"balance";
NSString * const kDWOFundingSourceIdCredit = @"credit";

// relative paths
NSString * const kDWORelativePathAuthenticate = @"oauth/v2/authenticate";
NSString * const kDWORelativePathToken = @"oauth/v2/token";
NSString * const kDWORelativePathContacts = @"oauth/rest/contacts";
NSString * const kDWORelativePathContactsNearby = @"oauth/rest/contacts/nearby";
NSString * const kDWORelativePathFundingSources = @"oauth/rest/fundingsources";
NSString * const kDWORelativePathRequests = @"oauth/rest/requests";
NSString * const kDWORelativePathTransactions = @"oauth/rest/transactions";
NSString * const kDWORelativePathTransactionSend = @"oauth/rest/transactions/send";
NSString * const kDWORelativePathUsers = @"oauth/rest/users";

// funding sources sub paths
NSString * const kDWOSubpathFundingSourcesDeposit = @"deposit";
NSString * const kDWOSubpathFundingSourcesWithdraw = @"withdraw";

// requests sub paths
NSString * const kDWOSubpathRequestFulfill = @"fulfill";
NSString * const kDWOSubpathRequestCancel = @"cancel";

// response keys
NSString * const kDWOResponseKeySuccess = @"Success";
NSString * const kDWOResponseKeyMessage = @"Message";
NSString * const kDWOResponseKeyResponse = @"Response";
NSString * const kDWOResponseKeyImage = @"Image";

// account response keys
NSString * const kDWOResponseKeyAccountId = @"Id";
NSString * const kDWOResponseKeyAccountCity = @"City";
NSString * const kDWOResponseKeyAccountLatitude = @"Latitude";
NSString * const kDWOResponseKeyAccountLongitude = @"Longitude";
NSString * const kDWOResponseKeyAccountName = @"Name";
NSString * const kDWOResponseKeyAccountState = @"State";
NSString * const kDWOResponseKeyAccountType = @"Type";

// contact response keys
NSString * const kDWOResponseKeyContactId = @"Id";
NSString * const kDWOResponseKeyContactName = @"Name";
NSString * const kDWOResponseKeyContactType = @"Type";
NSString * const kDWOResponseKeyContactCity = @"City";
NSString * const kDWOResponseKeyContactState = @"State";

// nearby contact response keys
NSString * const kDWOResponseKeyNearbyContactAddress = @"Address";
NSString * const kDWOResponseKeyNearbyContactCity = @"City";
NSString * const kDWOResponseKeyNearbyContactState = @"State";
NSString * const kDWOResponseKeyNearbyContactLatitude = @"Latitude";
NSString * const kDWOResponseKeyNearbyContactLongitude = @"Longitude";

// funding source response keys
NSString * const kDWOResponseKeyFundingSourceId = @"Id";
NSString * const kDWOResponseKeyFundingSourceName = @"Name";
NSString * const kDWOResponseKeyFundingSourceProcessingType = @"ProcessingType";
NSString * const kDWOResponseKeyFundingSourceType = @"Type";
NSString * const kDWOResponseKeyFundingSourceVerified = @"Verified";

// transaction reponse keys
NSString * const kDWOResponseKeyTransactionId = @"Id";
NSString * const kDWOResponseKeyTransactionType = @"Type";
NSString * const kDWOResponseKeyTransactionStatus = @"Status";
NSString * const kDWOResponseKeyTransactionSourceName = @"SourceName";
NSString * const kDWOResponseKeyTransactionSourceId = @"SourceId";
NSString * const kDWOResponseKeyTransactionDestinationName = @"DestinationName";
NSString * const kDWOResponseKeyTransactionDestinationId = @"DestinationId";
NSString * const kDWOResponseKeyTransactionAmount = @"Amount";
NSString * const kDWOResponseKeyTransactionNotes = @"Notes";
NSString * const kDWOResponseKeyTransactionDate = @"Date";
NSString * const kDWOResponseKeyTransactionClearingDate = @"ClearingDate";
NSString * const kDWOResponseKeyTransactionUserType = @"UserType";
NSString * const kDWOResponseKeyTransactionFees = @"Fees";

// money request response keys
NSString * const kDWOResponseKeyMoneyRequestId = @"Id";
NSString * const kDWOResponseKeyMoneyRequestAmount = @"Amount";
NSString * const kDWOResponseKeyMoneyRequestDateRequested = @"DateRequested";
NSString * const kDWOResponseKeyMoneyRequestDestination = @"Destination";
NSString * const kDWOResponseKeyMoneyRequestDestinationId = @"Id";
NSString * const kDWOResponseKeyMoneyRequestDestinationType = @"Type";
NSString * const kDWOResponseKeyMoneyRequestDestinationName = @"Name";
NSString * const kDWOResponseKeyMoneyRequestDestinationImage = @"Image";
NSString * const kDWOResponseKeyMoneyRequestSource = @"Source";
NSString * const kDWOResponseKeyMoneyRequestSourceId = @"Id";
NSString * const kDWOResponseKeyMoneyRequestSourceType = @"Type";
NSString * const kDWOResponseKeyMoneyRequestSourceName = @"Name";
NSString * const kDWOResponseKeyMoneyRequestSourceImage = @"Image";
NSString * const kDWOResponseKeyMoneyRequestNotes = @"Notes";

// fullfill request response keys
NSString * const kDWOResponseKeyFulfillRequestId = @"RequestId";
NSString * const kDWOResponseKeyFulfillRequestTransactionId = @"Id";
NSString * const kDWOResponseKeyFulfillRequestTransactionStatus = @"Status";

// transaction fee response keys
NSString * const kDWOResponseKeyTransactionFeeId = @"Id";
NSString * const kDWOResponseKeyTransactionFeeType = @"Type";
NSString * const kDWOResponseKeyTransactionFeeAmount = @"Amount";

// request keys
NSString * const kDWORequestKeyClientId = @"client_id";
NSString * const kDWORequestKeyClientSecret = @"client_secret";
NSString * const kDWORequestKeyResponseType = @"response_type";
NSString * const kDWORequestKeyRedirectUri = @"redirect_uri";
NSString * const kDWORequestKeyScope = @"scope";
NSString * const kDWORequestKeyOAuthToken = @"oauth_token";
NSString * const kDWORequestKeyLimit = @"limit";
NSString * const kDWORequestKeySkip = @"skip";

// contact request keys
NSString * const kDWORequestKeyContactTerm = @"search";
NSString * const kDWORequestKeyContactTypes = @"types";

// nearby contact request keys
NSString * const kDWORequestKeyNearbyContactLatitude = @"latitude";
NSString * const kDWORequestKeyNearbyContactLongitude = @"longitude";
NSString * const kDWORequestKeyNearbyContactRange = @"range";

// fund request keys
NSString * const kDWORequestKeyFundPin = @"pin";
NSString * const kDWORequestKeyFundAmount = @"amount";

// pending request keys
NSString * const kDWORequestKeyPendingRequestSinceDate = @"startDate";
NSString * const kDWORequestKeyPendingRequestEndDate = @"endDate";

// fulfill request keys
NSString * const kDWORequestKeyFullfillRequestPin = @"pin";
NSString * const kDWORequestKeyFullfillRequestAmount = @"amount";
NSString * const kDWORequestKeyFullfillRequestNotes = @"notes";
NSString * const kDWORequestKeyFullfillRequestFundsSource = @"fundsSource";
NSString * const kDWORequestKeyFullfillRequestAssumeCosts = @"assumeCosts";

// money request keys
NSString * const kDWORequestKeyMoneyRequestSourceId = @"sourceId";
NSString * const kDWORequestKeyMoneyRequestAmount = @"amount";
NSString * const kDWORequestKeyMoneyRequestSourceType = @"sourceType";
NSString * const kDWORequestKeyMoneyRequestNotes = @"notes";
NSString * const kDWORequestKeyMoneyRequestSenderAssumeCosts = @"senderAssumeCosts";

// transactions request keys
NSString * const kDWORequestKeyTransactionsSinceDate = @"sinceDate";
NSString * const kDWORequestKeyTransactionsEndDate = @"endDate";
NSString * const kDWORequestKeyTransactionsTypes = @"types";

// transaction send request keys
NSString * const kDWORequestKeyTransactionSendPin = @"pin";
NSString * const kDWORequestKeyTransactionSendDestinationId = @"destinationId";
NSString * const kDWORequestKeyTransactionSendDestinationType = @"destinationType";
NSString * const kDWORequestKeyTransactionSendAmount = @"amount";
NSString * const kDWORequestKeyTransactionSendAssumeCosts = @"assumeCosts";
NSString * const kDWORequestKeyTransactionSendNotes = @"notes";
NSString * const kDWORequestKeyTransactionSendFundsSource = @"fundsSource";

// funding sources destination request keys
NSString * const kDWORequestKeyFundingSourcesDestinationId = @"destinationId";
NSString * const kDWORequestKeyFundingSourcesDestinationType = @"destinationType";

// request values
NSString * const kDWORequestKeyResponseTypeCode = @"code";

// error messages
NSString * const kDWOErrorMessageInvalidOAuthToken = @"Invalid access token.";