//
//  MapViewController.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "Protocol.h"
#import "Group+Category.h"
#import "FindCarViewController.h"

@interface MapViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, MapViewControllerProtocol, UIAlertViewDelegate>
{
    IBOutlet UIImageView* headerView;
    IBOutlet UIImageView* logoView;
    IBOutlet UIButton* historyOfOrdersButoon;
    IBOutlet UIImageView* footerView;
    IBOutlet UIButton* findCarButton;
    IBOutlet GMSMapView* googleMapView;
    IBOutlet UILabel* freeCarsLabel;
    IBOutlet UILabel* totalCarsLabel;
    IBOutlet UILabel* distanceLabel;
    
    Group* group;
    CLLocationManager* locationManager;
    GMSMarker* me_marker;
    
    NSString* driverIndex;
    NSMutableArray* users;
    NSMutableArray* markers;
    BOOL idleTimerDisabled;
    
    User* driverOnWay;
    
    NSInteger updateStatusCounter;
    NSTimer* timer;
    BOOL timerInProgress;
    FindCarViewController* findCarController;
}

@property (nonatomic, retain) IBOutlet UIImageView* headerView;
@property (nonatomic, retain) IBOutlet UIImageView* logoView;
@property (nonatomic, retain) IBOutlet UIButton* historyOfOrdersButoon;
@property (nonatomic, retain) IBOutlet UIImageView* footerView;
@property (nonatomic, retain) IBOutlet UIButton* findCarButton;
@property (nonatomic, retain) IBOutlet GMSMapView* googleMapView;
@property (nonatomic, retain) IBOutlet UILabel* freeCarsLabel;
@property (nonatomic, retain) IBOutlet UILabel* totalCarsLabel;
@property (nonatomic, retain) IBOutlet UILabel* distanceLabel;

@property (assign) Group* group;

- (IBAction)historyOfOrdersButoonClicked:(id)sender;
- (IBAction)findCarButtonClicked:(id)sender;

@end
