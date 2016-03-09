//
//  DropDownViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.h"

@interface DropDownViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIImageView* background;
    IBOutlet UIButton* dropDownButton;
    IBOutlet UITableView* contentTable;
    IBOutlet UIImageView* arrow;
    IBOutlet UILabel* title;
    
    CGRect originalFrame;
    id<DropDownProtocol> delegate;
    NSArray* content;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIButton* dropDownButton;
@property (nonatomic, retain) IBOutlet UITableView* contentTable;
@property (nonatomic, retain) IBOutlet UIImageView* arrow;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;

@property (assign) id<DropDownProtocol> delegate;
@property (nonatomic, retain) NSArray* content;

- (IBAction) dropDownButtonClicked:(id)sender;

- (id<DropDownItemProtocol>) selectedItem;
- (void) collaps;

@end
