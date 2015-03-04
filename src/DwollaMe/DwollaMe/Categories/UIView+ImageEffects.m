//
//  UIView+ImageEffects.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/30/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "UIView+ImageEffects.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+Dwolla.h"

@implementation UIView (ImageEffects)

-(UIImage *)blurredSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *blurredImage = [snapshotImage applyTintEffectWithColor:[UIColor dwollaOrangeColor]];
    return blurredImage;
}

@end
