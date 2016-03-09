//
//  DriverRatigViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 01.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Category.h"

@interface DriverRatigViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIImageView* background;
    IBOutlet UIImageView* photo;
    IBOutlet UIButton* closeButton;
    IBOutlet UILabel* firstNameLabel;
    IBOutlet UILabel* lastNameLabel;
    IBOutlet UILabel* surNameLabel;
    IBOutlet UIImageView* rate1Image;
    IBOutlet UIImageView* rate2Image;
    IBOutlet UIImageView* rate3Image;
    IBOutlet UIImageView* rate4Image;
    IBOutlet UIImageView* rate5Image;
    IBOutlet UIImageView* tableBackground;
    IBOutlet UITableView* table;
    
    User* user;
    NSArray* users;
    id <MapViewControllerProtocol> delegate;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIImageView* photo;
@property (nonatomic, retain) IBOutlet UIButton* closeButton;
@property (nonatomic, retain) IBOutlet UILabel* firstNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* lastNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* surNameLabel;
@property (nonatomic, retain) IBOutlet UIImageView* rate1Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate2Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate3Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate4Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate5Image;
@property (nonatomic, retain) IBOutlet UIImageView* tableBackground;
@property (nonatomic, retain) IBOutlet UITableView* table;
@property (assign) id <MapViewControllerProtocol> delegate;

@property (assign) User* user;

- (IBAction)closeButtonClicked:(id)sender;

@end
