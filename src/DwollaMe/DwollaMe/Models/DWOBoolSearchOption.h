//
//  DWOBoolSearchOption.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

@interface DWOBoolSearchOption : NSObject

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic) BOOL enabled;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name;
- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name enabled:(BOOL)enabled;

@end
