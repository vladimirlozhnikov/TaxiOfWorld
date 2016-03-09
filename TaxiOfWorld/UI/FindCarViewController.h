//
//  FindCarViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.h"
#import "RCSwitch.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "User+Category.h"
#import "TextFieldWithValidation.h"
#import "iOSCombobox.h"

@interface FindCarViewController : UIViewController <UITextFieldDelegate, GMSMapViewDelegate, CLLocationManagerDelegate, iOSComboboxDelegate, BSKeyboardControlsDelegate>
{
    IBOutlet UIImageView* background;
    IBOutlet UIButton* closeButton;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIImageView* mapBackground;
    IBOutlet UIImageView* nameBackground;
    IBOutlet UIImageView* phoneBackground;
    IBOutlet UIImageView* fromBackground;
    IBOutlet UIImageView* toBackground;
    IBOutlet UIButton* makeOrderButton;
    
    IBOutlet TextFieldWithValidation* nameField;
    IBOutlet TextFieldWithValidation* phoneField;
    IBOutlet TextFieldWithValidation* fromField;
    IBOutlet UITextField* toField;
    
    IBOutlet UIButton* fromButton;
    IBOutlet UIButton* toButton;
    
    IBOutlet UILabel* tariffDayCityLabel;
    IBOutlet UILabel* tariffDayOutCityLabel;
    IBOutlet UILabel* tariffTimeLabel;
    IBOutlet UILabel* tariffSeatLabel;
    
    //IBOutlet UILabel* tariffNightCityLabel;
    //IBOutlet UILabel* tariffNightOutCityLabel;
    
    IBOutlet UILabel* smokeLabel;
    IBOutlet UILabel* yesLabel;
    IBOutlet UILabel* noLabel;
    IBOutlet RCSwitch* smokeSwitch;
    
    iOSCombobox* tariffDayCityDropDown;
    iOSCombobox* tariffDayOutCityDropDown;
    iOSCombobox* tariffTimeDropDown;
    iOSCombobox* tariffSeatDropDown;
    
    /*iOSCombobox* tariffNightCityDropDown;
    iOSCombobox* tariffNightOutCityDropDown;
    iOSCombobox* tariffHolidayDropDown;*/
    
    IBOutlet GMSMapView* googleMapView;
    
    CLLocationManager* locationManager;
    GMSMarker* marker_from;
    GMSMarker* marker_to;
    NSTimer* timer;
    
    User* user;
    id <MapViewControllerProtocol> delegate;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIButton* closeButton;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIImageView* mapBackground;
@property (nonatomic, retain) IBOutlet UIImageView* nameBackground;
@property (nonatomic, retain) IBOutlet UIImageView* phoneBackground;
@property (nonatomic, retain) IBOutlet UIImageView* fromBackground;
@property (nonatomic, retain) IBOutlet UIImageView* toBackground;
@property (nonatomic, retain) IBOutlet UIButton* makeOrderButton;

@property (nonatomic, retain) IBOutlet UILabel* tariffDayCityLabel;
@property (nonatomic, retain) IBOutlet UILabel* tariffDayOutCityLabel;
@property (nonatomic, retain) IBOutlet UILabel* tariffTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel* tariffSeatLabel;

//@property (nonatomic, retain) IBOutlet UILabel* tariffNightCityLabel;
//@property (nonatomic, retain) IBOutlet UILabel* tariffNightOutCityLabel;

@property (nonatomic, retain) IBOutlet TextFieldWithValidation* nameField;
@property (nonatomic, retain) IBOutlet TextFieldWithValidation* phoneField;
@property (nonatomic, retain) IBOutlet TextFieldWithValidation* fromField;
@property (nonatomic, retain) IBOutlet UITextField* toField;

@property (nonatomic, retain) IBOutlet UIButton* fromButton;
@property (nonatomic, retain) IBOutlet UIButton* toButton;

@property (nonatomic, retain) IBOutlet UILabel* smokeLabel;
@property (nonatomic, retain) IBOutlet UILabel* yesLabel;
@property (nonatomic, retain) IBOutlet UILabel* noLabel;
@property (nonatomic, retain) IBOutlet RCSwitch* smokeSwitch;

@property (readonly) iOSCombobox* tariffDayCityDropDown;
@property (readonly) iOSCombobox* tariffDayOutCityDropDown;
@property (readonly) iOSCombobox* tariffTimeDropDown;
@property (readonly) iOSCombobox* tariffSeatDropDown;

/*@property (readonly) iOSCombobox* tariffNightCityDropDown;
@property (readonly) iOSCombobox* tariffNightOutCityDropDown;
@property (readonly) iOSCombobox* tariffHolidayDropDown;
@property (readonly) iOSCombobox* tariffDowntimeDropDown;*/

@property (readonly) GMSMarker* marker_from;
@property (readonly) GMSMarker* marker_to;

@property (nonatomic, retain) IBOutlet GMSMapView* googleMapView;
@property (assign) User* user;
@property (assign) id <MapViewControllerProtocol> delegate;

- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)makeOrderButtonClicked:(id)sender;
- (IBAction)fromButtonClicked:(id)sender;
- (IBAction)toButtonClicked:(id)sender;

@end
