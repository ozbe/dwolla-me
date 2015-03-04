//
//  DWORestClient.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// data access
#import "DWOCredentials.h"

@interface DWORestClient : NSObject

@property (nonatomic, strong) DWOCredentials *credentials;

- (instancetype)initWithCredentials:(DWOCredentials *)credentials;
- (instancetype)init;

+ (NSString *)appendQueryParameters:(NSDictionary *)parameters toBaseUrl:(NSString *)baseUrl;

- (id)getRelativePath:(NSString *)relativePath
        addParameters:(void(^)(NSMutableDictionary *parameters))addParameters
      convertResponse:(id(^)(id response))convertResponse
                error:(NSError **)error;
- (NSDictionary *)getRelativePath:(NSString *)relativePath withParameters:(NSDictionary *)parameters error:(NSError **)error;
- (NSDictionary *)postRelativePath:(NSString *)relativePath withBody:(NSDictionary *)body error:(NSError **)error;
- (NSString *)getFullPath:(NSString *)relativePath;

@end
