//
//  DWORestClient.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWORestClient.h"
// categories
#import "NSString+URLEncoding.h"
// constants
#import "DWORestApiConstants.h"
#import "DWOErrorConstants.h"

@implementation DWORestClient

#pragma mark - Initializers

#warning init with just host name

- (instancetype)initWithCredentials:(DWOCredentials *)credentials {
    self = [super init];
    
    if (self) {
        self.credentials = credentials;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithCredentials:[DWOCredentials sharedCredentials]];
}

#pragma mark - Public

- (id)getRelativePath:(NSString *)relativePath
       addParameters:(void(^)(NSMutableDictionary *parameters))addParameters
convertResponse:(id(^)(id response))convertResponse
                error:(NSError **)error {
    @try {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        addParameters(parameters);
        NSDictionary *dictionary = [self getRelativePath:relativePath withParameters:parameters error:error];
        return (*error) ? nil : convertResponse([dictionary objectForKey:kDWOResponseKeyResponse]);
    }
    @catch (NSException *exception) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setValue:exception.name forKey:@"DWOExceptionName"];
        [info setValue:exception.reason forKey:@"DWOExceptionReason"];
        [info setValue:exception.callStackReturnAddresses forKey:@"DWOExceptionCallStackReturnAddresses"];
        [info setValue:exception.callStackSymbols forKey:@"DWOExceptionCallStackSymbols"];
        [info setValue:exception.userInfo forKey:@"DWOExceptionUserInfo"];
        *error = [NSError errorWithDomain:kDWOErrorDomain code:kDWOErrorCodeApi userInfo:info];
        return nil;
    }
}

- (NSDictionary *)getRelativePath:(NSString *)relativePath withParameters:(NSDictionary *)parameters {
    NSError *error = nil;
    return [self getRelativePath:relativePath withParameters:parameters error:&error];
}

- (NSDictionary *)getRelativePath:(NSString *)relativePath withParameters:(NSDictionary *)parameters error:(NSError **)error {
    NSURLResponse *response;
    NSURL *url = [NSURL URLWithString:[DWORestClient appendQueryParameters:parameters toBaseUrl:[self getFullPath:relativePath]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:kDWOMimeTypeJson forHTTPHeaderField:@"Accept"];
    [request setValue:kDWOMimeTypeJson forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:error];
    
    return (*error) ? [NSDictionary dictionary] : [self safelyDeserializeJson:data error:error];
}

- (NSDictionary *)postRelativePath:(NSString *)relativePath withBody:(NSDictionary *)body {
    NSError *error = nil;
    return [self postRelativePath:relativePath withBody:body error:&error];
}

- (NSDictionary *)postRelativePath:(NSString *)relativePath withBody:(NSDictionary *)body error:(NSError **)error {
    NSURLResponse *response;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:error];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self getFullPath:relativePath]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:kDWOMimeTypeJson forHTTPHeaderField:@"Accept"];
    [request setValue:kDWOMimeTypeJson forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)json.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:error];
    
    return (*error) ? [NSDictionary dictionary] : [self safelyDeserializeJson:data error:error];
}
                                                  
- (NSDictionary *)safelyDeserializeJson:(NSData *)data error:(NSError **)error {
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
    return (*error) ? [NSDictionary dictionary] : [self verifyApiResponse:result error:error];
}

- (NSDictionary *)verifyApiResponse:(NSDictionary *)response error:(NSError **)error {
    if (![[response objectForKey:kDWOResponseKeySuccess] boolValue]) {
        *error = [NSError errorWithDomain:kDWOErrorDomain
                                     code:kDWOErrorCodeApi
                                 userInfo:@{ kDWOErrorUserInfoKeyMessage: [response objectForKey:kDWOResponseKeyMessage] }];
    }
    return (*error) ? [NSDictionary dictionary] : response;
}

+ (NSString *)appendQueryParameters:(NSDictionary *)parameters toBaseUrl:(NSString *)baseUrl {
    NSMutableString *suffix = [NSMutableString string];
    
    for (NSString *key in parameters) {
        if ([suffix length]) {
            [suffix appendString:@"&"];
        }
        
        [suffix appendFormat:@"%@=%@", key, [[parameters valueForKey:key] urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [baseUrl stringByAppendingString:[@"?" stringByAppendingString:suffix]];
}

- (NSString *)getFullPath:(NSString *)relativePath {
    return [self.credentials.baseUrl stringByAppendingString:relativePath];
}

@end
