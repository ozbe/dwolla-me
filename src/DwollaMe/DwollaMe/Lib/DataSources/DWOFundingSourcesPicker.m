//
//  DWOFundingSourcesPicker.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/3/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOFundingSourcesPicker.h"
// data access
#import "DWOFundingSourcesClient.h"

@interface DWOFundingSourcesPicker ()
@property (nonatomic, strong) DWOFundingSourcesClient *fundingSourcesClient;
@property (nonatomic, strong) NSArray *fundingSources;
@property (nonatomic, strong) NSArray *filteredFundingSources;
@property (nonatomic, strong) NSOperationQueue *fundingSourcesQueue;
@end

@implementation DWOFundingSourcesPicker

#pragma mark - Properties

- (DWOFundingSourcesClient *)fundingSourcesClient {
    if (!_fundingSourcesClient) {
        _fundingSourcesClient = [[DWOFundingSourcesClient alloc] init];
    }
    return _fundingSourcesClient;
}

- (NSOperationQueue *)fundingSourcesQueue {
    if (!_fundingSourcesQueue) {
        _fundingSourcesQueue = [[NSOperationQueue alloc] init];
        _fundingSourcesQueue.name = @"Funding Sources Queue";
        _fundingSourcesQueue.maxConcurrentOperationCount = 1;
    }
    return _fundingSourcesQueue;
}

- (void)setFundingSources:(NSArray *)fundingSources {
    _fundingSources = fundingSources;
    _filteredFundingSources = nil;
}

- (NSArray *)filteredFundingSources {
    if (!_filteredFundingSources) {
        _filteredFundingSources = [self filterFundingSourcesOrReturnFundingSources];
    }
    return _filteredFundingSources;
}

#pragma mark - Public

- (DWOFundingSource *)fundingSourceForRow:(NSInteger)row forComponent:(NSInteger)component {
    return (row >= 0 && row < self.fundingSources.count) ? [self.filteredFundingSources objectAtIndex:row] : nil;
}

- (void)beginLoading {
    [self fetchAndSetFundingSources];
}

#pragma mark - Private

- (NSArray *)filterFundingSourcesOrReturnFundingSources {
    if ([self.delegate respondsToSelector:@selector(fundingSourcesPicker:shouldIncludeFundingSource:)]) {
        return [self filterFundingSources];
    } else {
        return [self.fundingSources copy];
    }
}

- (NSArray *)filterFundingSources {
    NSMutableArray *filteredFundingSources = [NSMutableArray array];
    
    for (DWOFundingSource *fundingSource in self.fundingSources) {
        if ([self delegateShouldIncludeFundingSource:fundingSource]) {
            [filteredFundingSources addObject:fundingSource];
        }
    }
    
    return filteredFundingSources;
}

- (BOOL)delegateShouldIncludeFundingSource:(DWOFundingSource *)fundingSource {
    return [self.delegate fundingSourcesPicker:self shouldIncludeFundingSource:fundingSource];
}

- (void)fetchAndSetFundingSources {
    [self.fundingSourcesQueue cancelAllOperations];
    
    __weak DWOFundingSourcesPicker *self_weak = self;
    
    [self notifyDelegateDidBeginLoading];
    
    [self.fundingSourcesQueue addOperationWithBlock:^{
        NSArray *fundingSources = [self_weak fetchFundingSources];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self_weak setFundingSourcesAndNotifyDelegate:fundingSources];
        }];
    }];
}

- (NSArray *)fetchFundingSources {
    NSError *error;
    return (self.destination) ?
        [self.fundingSourcesClient fundingSourcesForDestination:self.destination error:&error] :
        [self.fundingSourcesClient fundingSourcesOrError:&error];
}

- (void)setFundingSourcesAndNotifyDelegate:(NSArray *)fundingSources {
    self.fundingSources = fundingSources;
    [self notifyDelegateDidFinishLoading];
}

- (void)notifyDelegateDidBeginLoading {
    if ([self.delegate respondsToSelector:@selector(fundingSourcesPickerDidBeginLoading:)]) {
        [self.delegate fundingSourcesPickerDidBeginLoading:self];
    }
}

- (void)notifyDelegateDidFinishLoading {
    if ([self.delegate respondsToSelector:@selector(fundingSourcesPickerDidFinishLoading:)]) {
        [self.delegate fundingSourcesPickerDidFinishLoading:self];
    }
}

- (void)notifyDelegateDidSelectFundingSource:(DWOFundingSource *)fundingSource {
    if ([self.delegate respondsToSelector:@selector(fundingSourcesPicker:didSelectFundingSource:)]) {
        [self.delegate fundingSourcesPicker:self didSelectFundingSource:fundingSource];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.filteredFundingSources.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    DWOFundingSource *fundingSource = [self fundingSourceForRow:row forComponent:component];
    return fundingSource.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self notifyDelegateDidSelectFundingSource:[self fundingSourceForRow:row forComponent:component]];
}

@end
