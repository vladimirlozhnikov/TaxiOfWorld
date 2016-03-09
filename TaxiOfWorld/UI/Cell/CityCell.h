//
//  CityCell.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.h"

@interface CityCell : UITableViewCell
{
    IBOutlet UIImageView* background;
    IBOutlet UILabel* titleLabel;
    
    BOOL choosed;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;

@property (assign) BOOL choosed;

@end
