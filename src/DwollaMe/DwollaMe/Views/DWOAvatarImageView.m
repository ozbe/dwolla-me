//
//  AvatarImageView.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/16/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOAvatarImageView.h"

@implementation DWOAvatarImageView

NSString *const DefaultImage = @"Unknown User";
static NSCache *imageCache;

#pragma mark - Properties

+ (NSCache *)imageCache {
    return imageCache;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    if (self.imageUrl) {
        self.image = nil;
        [self loadImageFromUrl:self.imageUrl];
    } else {
        [self setImageUnknown];
    }
}

- (void)setImage:(UIImage *)image {
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.masksToBounds = YES;
    [super setImage:image];
}

#pragma mark - Initializers

+ (void)initialize {
    if (self == [DWOAvatarImageView class]) {
        imageCache = [[NSCache alloc] init];
        imageCache.countLimit = 40;
    }
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return self;
}

#pragma mark - Overrides

- (void)setImageUnknown {
    [self setImage:[UIImage imageNamed:DefaultImage]];
}

- (void)loadImageFromUrl:(NSString *)url {
    if (!url) {
        [self setImageUnknown];
        return;
    }
    
    UIImage *image = [[DWOAvatarImageView imageCache] objectForKey:url];
    
    if (image) {
        self.image = image;
    } else {
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            UIImage *image = [UIImage imageWithData:data];
            
            if (image) {
                [[DWOAvatarImageView imageCache] setObject:image forKey:url];
            } else {
                image = [UIImage imageNamed:DefaultImage];
            }
            
            if ([self.imageUrl isEqualToString:url] && !self.image) {
                [self setImage:image];
            }
        }];
    }
}

@end
