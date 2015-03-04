//
//  DWORestApiConstants.h
//  DwollaMe
//
//  Created by Josh Aaseby on 1/30/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// base urls
extern NSString * const kDWOBaseUrlProd;
extern NSString * const kDWOBaseUrlTest;

// encodings
extern NSStringEncoding const kDWODefaultStringEncoding;

// scopes
extern NSString * const kDWOScopeAccountInfoFull;
extern NSString * const kDWOScopeContacts;
extern NSString * const kDWOScopeTransactions;
extern NSString * const kDWOScopeBalance;
extern NSString * const kDWOScopeSend;
extern NSString * const kDWOScopeRequest;
extern NSString * const kDWOScopeFunding;
extern NSString * const kDWOScopeManageAccount;
extern NSString * const kDWOScopeSeparator;

// mime types
extern NSString * const kDWOMimeTypeJson;
extern NSString * const kDWOMimeTypeHtml;

// contact types
extern NSString * const kDWOContactTypeDwolla;
extern NSString * const kDWOContactTypeEmail;
extern NSString * const kDWOContactTypePhone;
extern NSString * const kDWOContactTypeTwitter;

// transaction types
extern NSString * const kDWOTransactionTypeMoneyReceived;
extern NSString * const kDWOTransactionTypeMoneySent;
extern NSString * const kDWOTransactionTypeWithdrawal;
extern NSString * const kDWOTransactionTypeDeposit;
extern NSString * const kDWOTransactionTypeFee;

// transaction statuses
extern NSString * const kDWOTransactionStatusCompleted;
extern NSString * const kDWOTransactionStatusPending;
extern NSString * const kDWOTransactionStatusProcessed;
extern NSString * const kDWOTransactionStatusFailed;
extern NSString * const kDWOTransactionStatusCancelled;
extern NSString * const kDWOTransactionStatusReclaimed;

// funding source id
extern NSString * const kDWOFundingSourceIdBalance;
extern NSString * const kDWOFundingSourceIdCredit;

// relative paths
extern NSString * const kDWORelativePathAuthenticate;
extern NSString * const kDWORelativePathToken;
extern NSString * const kDWORelativePathContacts;
extern NSString * const kDWORelativePathContactsNearby;
extern NSString * const kDWORelativePathFundingSources;
extern NSString * const kDWORelativePathRequests;
extern NSString * const kDWORelativePathTransactions;
extern NSString * const kDWORelativePathTransactionSend;
extern NSString * const kDWORelativePathUsers;

// funding sources sub paths
extern NSString * const kDWOSubpathFundingSourcesDeposit;
extern NSString * const kDWOSubpathFundingSourcesWithdraw;

// requests sub paths
extern NSString * const kDWOSubpathRequestFulfill;
extern NSString * const kDWOSubpathRequestCancel;

// response keys
extern NSString * const kDWOResponseKeySuccess;
extern NSString * const kDWOResponseKeyMessage;
extern NSString * const kDWOResponseKeyResponse;
extern NSString * const kDWOResponseKeyImage;

// account response keys
extern NSString * const kDWOResponseKeyAccountId;
extern NSString * const kDWOResponseKeyAccountCity;
extern NSString * const kDWOResponseKeyAccountLatitude;
extern NSString * const kDWOResponseKeyAccountLongitude;
extern NSString * const kDWOResponseKeyAccountName;
extern NSString * const kDWOResponseKeyAccountState;
extern NSString * const kDWOResponseKeyAccountType;

// contact response keys
extern NSString * const kDWOResponseKeyContactId;
extern NSString * const kDWOResponseKeyContactName;
extern NSString * const kDWOResponseKeyContactType;
extern NSString * const kDWOResponseKeyContactCity;
extern NSString * const kDWOResponseKeyContactState;

// nearby contact response keys
extern NSString * const kDWOResponseKeyNearbyContactAddress;
extern NSString * const kDWOResponseKeyNearbyContactCity;
extern NSString * const kDWOResponseKeyNearbyContactState;
extern NSString * const kDWOResponseKeyNearbyContactLatitude;
extern NSString * const kDWOResponseKeyNearbyContactLongitude;

// funding source response keys
extern NSString * const kDWOResponseKeyFundingSourceId;
extern NSString * const kDWOResponseKeyFundingSourceName;
extern NSString * const kDWOResponseKeyFundingSourceProcessingType;
extern NSString * const kDWOResponseKeyFundingSourceType;
extern NSString * const kDWOResponseKeyFundingSourceVerified;

// transaction reponse keys
extern NSString * const kDWOResponseKeyTransactionId;
extern NSString * const kDWOResponseKeyTransactionType;
extern NSString * const kDWOResponseKeyTransactionStatus;
extern NSString * const kDWOResponseKeyTransactionSourceName;
extern NSString * const kDWOResponseKeyTransactionSourceId;
extern NSString * const kDWOResponseKeyTransactionDestinationName;
extern NSString * const kDWOResponseKeyTransactionDestinationId;
extern NSString * const kDWOResponseKeyTransactionAmount;
extern NSString * const kDWOResponseKeyTransactionNotes;
extern NSString * const kDWOResponseKeyTransactionDate;
extern NSString * const kDWOResponseKeyTransactionClearingDate;
extern NSString * const kDWOResponseKeyTransactionUserType;
extern NSString * const kDWOResponseKeyTransactionFees;
extern NSString * const kDWOResponseKeyTransactionType;

// money request response keys
extern NSString * const kDWOResponseKeyMoneyRequestId;
extern NSString * const kDWOResponseKeyMoneyRequestAmount;
extern NSString * const kDWOResponseKeyMoneyRequestDateRequested;
extern NSString * const kDWOResponseKeyMoneyRequestDestination;
extern NSString * const kDWOResponseKeyMoneyRequestDestinationId;
extern NSString * const kDWOResponseKeyMoneyRequestDestinationType;
extern NSString * const kDWOResponseKeyMoneyRequestDestinationName;
extern NSString * const kDWOResponseKeyMoneyRequestDestinationImage;
extern NSString * const kDWOResponseKeyMoneyRequestSource;
extern NSString * const kDWOResponseKeyMoneyRequestSourceId;
extern NSString * const kDWOResponseKeyMoneyRequestSourceType;
extern NSString * const kDWOResponseKeyMoneyRequestSourceName;
extern NSString * const kDWOResponseKeyMoneyRequestSourceImage;
extern NSString * const kDWOResponseKeyMoneyRequestNotes;

// fullfill request response keys
extern NSString * const kDWOResponseKeyFulfillRequestId;
extern NSString * const kDWOResponseKeyFulfillRequestTransactionId;
extern NSString * const kDWOResponseKeyFulfillRequestTransactionStatus;

// transaction fee response keys
extern NSString * const kDWOResponseKeyTransactionFeeId;
extern NSString * const kDWOResponseKeyTransactionFeeType;
extern NSString * const kDWOResponseKeyTransactionFeeAmount;

// request keys
extern NSString * const kDWORequestKeyClientId;
extern NSString * const kDWORequestKeyClientSecret;
extern NSString * const kDWORequestKeyResponseType;
extern NSString * const kDWORequestKeyRedirectUri;
extern NSString * const kDWORequestKeyScope;
extern NSString * const kDWORequestKeyOAuthToken;
extern NSString * const kDWORequestKeyLimit;
extern NSString * const kDWORequestKeySkip;

// contact request keys
extern NSString * const kDWORequestKeyContactTerm;
extern NSString * const kDWORequestKeyContactTypes;

// nearby contact request keys
extern NSString * const kDWORequestKeyNearbyContactLatitude;
extern NSString * const kDWORequestKeyNearbyContactLongitude;
extern NSString * const kDWORequestKeyNearbyContactRange;

// fund request keys
extern NSString * const kDWORequestKeyFundPin;
extern NSString * const kDWORequestKeyFundAmount;

// pending request keys
extern NSString * const kDWORequestKeyPendingRequestSinceDate;
extern NSString * const kDWORequestKeyPendingRequestEndDate;

// fulfill request keys
extern NSString * const kDWORequestKeyFullfillRequestPin;
extern NSString * const kDWORequestKeyFullfillRequestAmount;
extern NSString * const kDWORequestKeyFullfillRequestNotes;
extern NSString * const kDWORequestKeyFullfillRequestFundsSource;
extern NSString * const kDWORequestKeyFullfillRequestAssumeCosts;

// money request keys
NSString * const kDWORequestKeyMoneyRequestSourceId;
NSString * const kDWORequestKeyMoneyRequestAmount;
NSString * const kDWORequestKeyMoneyRequestSourceType;
NSString * const kDWORequestKeyMoneyRequestNotes;
NSString * const kDWORequestKeyMoneyRequestSenderAssumeCosts;

// transactions request keys
extern NSString * const kDWORequestKeyTransactionsSinceDate;
extern NSString * const kDWORequestKeyTransactionsEndDate;
extern NSString * const kDWORequestKeyTransactionsTypes;

// transaction send request keys
extern NSString * const kDWORequestKeyTransactionSendPin;
extern NSString * const kDWORequestKeyTransactionSendDestinationId;
extern NSString * const kDWORequestKeyTransactionSendDestinationType;
extern NSString * const kDWORequestKeyTransactionSendAmount;
extern NSString * const kDWORequestKeyTransactionSendAssumeCosts;
extern NSString * const kDWORequestKeyTransactionSendNotes;
extern NSString * const kDWORequestKeyTransactionSendFundsSource;

// funding sources destination request keys
extern NSString * const kDWORequestKeyFundingSourcesDestinationId;
extern NSString * const kDWORequestKeyFundingSourcesDestinationType;

// request values
extern NSString * const kDWORequestKeyResponseTypeCode;

// error messages
extern NSString * const kDWOErrorMessageInvalidOAuthToken;