//
//  DWODestination.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/12/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#warning obsolete. use DWOAccount

@interface DWODestination : NSObject

@property (nonatomic, strong) NSString *destinationId;
@property (nonatomic, strong) NSString *destinationType;

- (instancetype)initWithDestinationId:(NSString *)destinationId destinationType:(NSString *)destinationType;

@end
