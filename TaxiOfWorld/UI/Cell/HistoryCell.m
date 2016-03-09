//
//  HistoryCell.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell
@synthesize nameLabel, fromLabel, toLabel, photo, rate1, rate2, rate3, rate4, rate5;
@synthesize rate1Button, rate2Button, rate3Button, rate4Button, rate5Button;
@synthesize delegate, driver;

- (IBAction)rateButtonClicked:(id)sender
{
    NSNumber* rate = nil;
    if (sender == rate1Button)
        rate = [NSNumber numberWithInt:1];
    else if (sender == rate2Button)
        rate = [NSNumber numberWithInt:2];
    else if (sender == rate3Button)
        rate = [NSNumber numberWithInt:3];
    else if (sender == rate4Button)
        rate = [NSNumber numberWithInt:4];
    else if (sender == rate5Button)
        rate = [NSNumber numberWithInt:5];
    
    if (rate)
        [delegate didChooseRate:rate driver:self.driver];
}

@end
