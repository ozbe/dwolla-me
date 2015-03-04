//
//  DWOContact.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

@interface DWOContact : NSObject

@property (nonatomic, strong) NSString *contactId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;

@end
