//
//  HistoryCell.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface HistoryCell : UITableViewCell
{
    IBOutlet UILabel* nameLabel;
    IBOutlet UILabel* fromLabel;
    IBOutlet UILabel* toLabel;
    IBOutlet UIImageView* photo;
    IBOutlet UIImageView* rate1;
    IBOutlet UIImageView* rate2;
    IBOutlet UIImageView* rate3;
    IBOutlet UIImageView* rate4;
    IBOutlet UIImageView* rate5;
    
    IBOutlet UIButton* rate1Button;
    IBOutlet UIButton* rate2Button;
    IBOutlet UIButton* rate3Button;
    IBOutlet UIButton* rate4Button;
    IBOutlet UIButton* rate5Button;
    
    id<RateProtocol> delegate;
    User* driver;
}

@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* fromLabel;
@property (nonatomic, retain) IBOutlet UILabel* toLabel;
@property (nonatomic, retain) IBOutlet UIImageView* photo;
@property (nonatomic, retain) IBOutlet UIImageView* rate1;
@property (nonatomic, retain) IBOutlet UIImageView* rate2;
@property (nonatomic, retain) IBOutlet UIImageView* rate3;
@property (nonatomic, retain) IBOutlet UIImageView* rate4;
@property (nonatomic, retain) IBOutlet UIImageView* rate5;
@property (nonatomic, retain) IBOutlet UIButton* rate1Button;
@property (nonatomic, retain) IBOutlet UIButton* rate2Button;
@property (nonatomic, retain) IBOutlet UIButton* rate3Button;
@property (nonatomic, retain) IBOutlet UIButton* rate4Button;
@property (nonatomic, retain) IBOutlet UIButton* rate5Button;

@property (assign) id<RateProtocol> delegate;
@property (assign) User* driver;

- (IBAction)rateButtonClicked:(id)sender;

@end
