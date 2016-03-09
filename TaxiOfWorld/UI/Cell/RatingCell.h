//
//  RatingCell.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 02.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingCell : UITableViewCell
{
    IBOutlet UILabel* nameLabel;
    IBOutlet UIImageView* rate1Image;
    IBOutlet UIImageView* rate2Image;
    IBOutlet UIImageView* rate3Image;
    IBOutlet UIImageView* rate4Image;
    IBOutlet UIImageView* rate5Image;
    IBOutlet UILabel* messageLabel;
}

@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView* rate1Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate2Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate3Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate4Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate5Image;
@property (nonatomic, retain) IBOutlet UILabel* messageLabel;

@end
