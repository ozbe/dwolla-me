//
//  DWOContactCell.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOContactCell.h"
// views
#import "DWOAvatarImageView.h"

@interface DWOContactCell()
@property (weak, nonatomic) IBOutlet DWOAvatarImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@end

@implementation DWOContactCell

- (void)setContact:(DWOContact *)contact {
    if (self.contact == contact) {
        return;
    }
    
    _contact = contact;
    [self displayContact];
}

- (void)displayContact {
    self.nameLabel.text = self.contact ? self.contact.name : nil;
    self.typeLabel.text = [self getLocation];
    self.typeImageView.image = [self getTypeImage];
    self.avatarImageView.imageUrl = self.contact ? self.contact.imageUrl : nil;
}

- (NSString *)getLocation {
    return (self.contact && self.contact.city && self.contact.state) ?
        [NSString stringWithFormat:@"%@, %@", self.contact.city, self.contact.state] :
        nil;
}

- (UIImage *)getTypeImage {
    if ([self.contact.type compare:@"Dwolla" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return [UIImage imageNamed:@"DwollaGray"];
    } else if ([self.contact.type compare:@"Email" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return [UIImage imageNamed:@"EmailGray"];
    } else if ([self.contact.type compare:@"Phone" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return [UIImage imageNamed:@"PhoneGray"];
    } else if ([self.contact.type compare:@"Twitter" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return [UIImage imageNamed:@"TwitterGray"];
    } else {
        return nil;
    }
}

@end
