//
//  CityCell.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell
@synthesize background, titleLabel;

#pragma mark - Properties

- (BOOL) choosed
{
    return choosed;
}

- (void) setChoosed:(BOOL)theChoosed
{
    choosed = theChoosed;
    self.accessoryType = theChoosed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
