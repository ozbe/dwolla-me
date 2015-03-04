//
//  DWOUserSearchFilterOption.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/15/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

@interface DWOUserSearchFilterOption : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic) BOOL enabled;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name enabled:(BOOL)enabled;

@end
