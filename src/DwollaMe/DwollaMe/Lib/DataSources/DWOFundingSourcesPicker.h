//
//  DWOFundingSourcesPicker.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/3/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import <Foundation/Foundation.h>
// models
#import "DWOFundingSource.h"
#import "DWODestination.h"

@protocol DWOFundingSourcesPickerDelegate;

@interface DWOFundingSourcesPicker : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<DWOFundingSourcesPickerDelegate> delegate;
@property (nonatomic, strong) DWODestination *destination;

- (void)beginLoading;
- (DWOFundingSource *)fundingSourceForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

@protocol DWOFundingSourcesPickerDelegate <NSObject>

@optional

- (void)fundingSourcesPickerDidBeginLoading:(DWOFundingSourcesPicker *)fundingSourcesPicker;
- (void)fundingSourcesPickerDidFinishLoading:(DWOFundingSourcesPicker *)fundingSourcesPicker;
- (void)fundingSourcesPicker:(DWOFundingSourcesPicker *)fundingSourcesPicker didSelectFundingSource:(DWOFundingSource *)fundingSource;
- (BOOL)fundingSourcesPicker:(DWOFundingSourcesPicker *)fundingSourcesPicker shouldIncludeFundingSource:(DWOFundingSource *)fundingSource;

@end
