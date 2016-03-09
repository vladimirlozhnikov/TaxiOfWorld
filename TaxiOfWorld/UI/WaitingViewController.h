//
//  WaitingViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 05.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.h"

@interface WaitingViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIImageView* background;
    IBOutlet UIButton* closeButton;
    IBOutlet UILabel* titleLabel;
    IBOutlet UIImageView* waitingImage;
    IBOutlet UILabel* timerLabel;
    
    id <MapViewControllerProtocol> delegate;
    id object;
    
    NSTimer* orderTimer;
    NSInteger orderTimerCounter;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIButton* closeButton;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView* waitingImage;
@property (nonatomic, retain) IBOutlet UILabel* timerLabel;

@property (assign) id <MapViewControllerProtocol> delegate;
@property (assign) id object;

- (IBAction)closeButtonClicked:(id)sender;

@end
