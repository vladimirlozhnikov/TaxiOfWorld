//
//  DriverInfoViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 01.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Category.h"

@interface DriverInfoViewController : UIViewController
{
    IBOutlet UIImageView* background;
    IBOutlet UIImageView* photo;
    IBOutlet UIButton* closeButton;
    IBOutlet UILabel* firstNameLabel;
    IBOutlet UILabel* lastNameLabel;
    IBOutlet UILabel* surNameLabel;
    IBOutlet UIButton* statusButton;
    IBOutlet UIImageView* rate1Image;
    IBOutlet UIImageView* rate2Image;
    IBOutlet UIImageView* rate3Image;
    IBOutlet UIImageView* rate4Image;
    IBOutlet UIImageView* rate5Image;
    IBOutlet UIScrollView* photosScroll;
    IBOutlet UIImageView* scrollBackground;
    IBOutlet UIImageView* infoBackground;
    IBOutlet UITextView* infoTextView;
    IBOutlet UIButton* makeOrderButton;
    IBOutlet UIButton* showRatingButton;
    
    User* user;
    id <MapViewControllerProtocol> delegate;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIImageView* photo;
@property (nonatomic, retain) IBOutlet UIButton* closeButton;
@property (nonatomic, retain) IBOutlet UILabel* firstNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* lastNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* surNameLabel;
@property (nonatomic, retain) IBOutlet UIButton* statusButton;
@property (nonatomic, retain) IBOutlet UIImageView* rate1Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate2Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate3Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate4Image;
@property (nonatomic, retain) IBOutlet UIImageView* rate5Image;
@property (nonatomic, retain) IBOutlet UIScrollView* photosScroll;
@property (nonatomic, retain) IBOutlet UIImageView* scrollBackground;
@property (nonatomic, retain) IBOutlet UIImageView* infoBackground;
@property (nonatomic, retain) IBOutlet UITextView* infoTextView;
@property (nonatomic, retain) IBOutlet UIButton* makeOrderButton;
@property (nonatomic, retain) IBOutlet UIButton* showRatingButton;

@property (assign) User* user;
@property (assign) id <MapViewControllerProtocol> delegate;

- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)makeOrderButtonClicked:(id)sender;
- (IBAction)showRatingButtonClicked:(id)sender;

@end
