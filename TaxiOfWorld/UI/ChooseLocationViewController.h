//
//  ChooseLocationViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSCombobox.h"
#import "Protocol.h"
#import <CoreLocation/CoreLocation.h>
#import "Pin+Category.h"
#import "BSKeyboardControls.h"

@interface ChooseLocationViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate, iOSComboboxDelegate, BSKeyboardControlsDelegate>
{
    IBOutlet UIImageView* background;
    IBOutlet UIImageView* centerImageView;
    IBOutlet UIImageView* logoImageView;
    IBOutlet UILabel* groupsLabel;
    
    iOSCombobox* groupsDropDown;
    CLLocationManager* locationManager;
    
    Pin* pin;
    NSString* phoneNumber;
    UIAlertView* alert;
    BOOL alertVisibled;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIImageView* centerImageView;
@property (nonatomic, retain) IBOutlet UIImageView* logoImageView;
@property (nonatomic, retain) IBOutlet UILabel* groupsLabel;

@end
