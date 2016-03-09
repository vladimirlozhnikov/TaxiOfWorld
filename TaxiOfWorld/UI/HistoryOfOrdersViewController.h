//
//  HistoryOfOrdersViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.h"

@interface HistoryOfOrdersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RateProtocol, UIAlertViewDelegate>
{
    IBOutlet UIImageView* background;
    IBOutlet UIImageView* tableBackground;
    IBOutlet UILabel* titleLabel;
    IBOutlet UITableView* table;
    IBOutlet UIButton* closeButton;
    
    NSMutableArray* content;
    int userRate;
    User* driver;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIImageView* tableBackground;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UIButton* closeButton;

- (IBAction) closeButtonClicked:(id)sender;

@end
