//
//  MapViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "MapViewController.h"
#import "HistoryOfOrdersViewController.h"
#import "KGModal.h"
#import "FindCarViewController.h"
#import "DriverInfoViewController.h"
#import "WaitingViewController.h"
#import "NetworkManager.h"
#import "Car+Category.h"
#import "Pin+Category.h"
#import "Message+Category.h"
#import "Tariff+Category.h"
#import "User+Category.h"
#import "Car+Category.h"

@interface MapViewController ()
- (void) findUsers;
- (void) showUsers;
- (void) getCoordinates;
- (void) timerFire:(id)sender;

@end

@implementation MapViewController
@synthesize headerView, logoView, historyOfOrdersButoon, footerView, findCarButton, googleMapView, group;
@synthesize freeCarsLabel, totalCarsLabel, distanceLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [locationManager release];
    [users release];
    [markers release];
    [timer invalidate];
    timer = nil;
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = idleTimerDisabled;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    users = [[NSMutableArray alloc] init];
    markers = [[NSMutableArray alloc] init];
    
    // resize history button image
    UIImage* historyOfOrdersImage = [UIImage imageNamed:@"MainBtn@2x.png"];
    UIImage* resizeHistoryOfOrdersImage = [historyOfOrdersImage stretchableImageWithLeftCapWidth:17.0 topCapHeight:20.0];
    [historyOfOrdersButoon setBackgroundImage:resizeHistoryOfOrdersImage forState:UIControlStateNormal];
    
    // resize find car button image
    UIImage* findCarImage = [UIImage imageNamed:@"MainBtn@2x.png"];
    UIImage* resizeFindCarImage = [findCarImage stretchableImageWithLeftCapWidth:17.0 topCapHeight:20.0];
    [findCarButton setBackgroundImage:resizeFindCarImage forState:UIControlStateNormal];
    
    googleMapView.trafficEnabled = YES;
    googleMapView.delegate = self;
    googleMapView.settings.rotateGestures = NO;
    [googleMapView animateToZoom:10.0];
    
    UITapGestureRecognizer* tapLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutClicked:)];
    tapLeftGesture.numberOfTapsRequired = 1;
    [logoView addGestureRecognizer:tapLeftGesture];
    [tapLeftGesture release];
    
    if (self.group)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        
        [self startLocationManager];
        [self findUsers];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handlers

- (IBAction)historyOfOrdersButoonClicked:(id)sender
{
    if (!driverOnWay)
    {
        HistoryOfOrdersViewController* historyController = [[[HistoryOfOrdersViewController alloc] initWithNibName:@"HistoryOfOrdersViewController" bundle:nil] autorelease];
        
        [[KGModal sharedInstance] showWithContentViewController:historyController andAnimated:YES];
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_7", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"MESSAGE_24", @"") otherButtonTitles:NSLocalizedString(@"MESSAGE_17", @""), NSLocalizedString(@"MESSAGE_18", @""), nil] autorelease];
        alert.tag = 2000;
        [alert show];
    }
}

- (IBAction)findCarButtonClicked:(id)sender
{
    if (!self.group)
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_5", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
        
        return;
    }
    
    if (!driverOnWay)
    {
        findCarController = [[[FindCarViewController alloc] initWithNibName:@"FindCarViewController" bundle:nil] autorelease];
        findCarController.delegate = self;
        
        [[KGModal sharedInstance] showWithContentViewController:findCarController andAnimated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", driverOnWay.phone]]];
    }
}

- (void)logoutClicked:(id)sender
{
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_8", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"MESSAGE_4", @"") otherButtonTitles:NSLocalizedString(@"MESSAGE_25", @""), nil] autorelease];
    [alert show];
}

#pragma mark CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations count] > 0)
    {
        CLLocation* newLocation = [locations lastObject];
        
        if (!me_marker)
        {
            /*CLLocationCoordinate2D coordinate;
            coordinate.latitude = 53.940345;
            coordinate.longitude = 27.597824;
            
            me_marker = [GMSMarker markerWithPosition:coordinate];*/
            me_marker = [GMSMarker markerWithPosition:newLocation.coordinate];
            me_marker.icon = [UIImage imageNamed:@"UserMarker.png"];
            me_marker.map = googleMapView;
            me_marker.userData = DELEGATE.me;
            [users addObject:DELEGATE.me];
            [markers addObject:me_marker];
            
            googleMapView.selectedMarker = me_marker;
            //[googleMapView animateToLocation:coordinate];
            [googleMapView animateToLocation:newLocation.coordinate];
        }
    }
    
    [self performSelectorOnMainThread:@selector(stopLocationManagerWithDelay) withObject:nil waitUntilDone:NO];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!me_marker)
    {
        /*CLLocationCoordinate2D coordinate;
        coordinate.latitude = 53.940345;
        coordinate.longitude = 27.597824;
        
        me_marker = [GMSMarker markerWithPosition:coordinate];*/
        me_marker = [GMSMarker markerWithPosition:newLocation.coordinate];
        me_marker.icon = [UIImage imageNamed:@"UserMarker.png"];
        me_marker.map = googleMapView;
        [users addObject:DELEGATE.me];
        [markers addObject:me_marker];
        
        googleMapView.selectedMarker = me_marker;
        //[googleMapView animateToLocation:coordinate];
        [googleMapView animateToLocation:newLocation.coordinate];
    }
    
    [self performSelectorOnMainThread:@selector(stopLocationManagerWithDelay) withObject:nil waitUntilDone:NO];
}

- (void) startLocationManager
{
    [DELEGATE showActivity];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void) stopLocationManagerWithDelay
{
    [DELEGATE hideActivity];
    
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    [locationManager release];
    
    locationManager = nil;
}

#pragma mark - GMSMapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    User* user = marker.userData;
    if ([[user.type lowercaseString] isEqualToString:@"taxist"])
    {
        DriverInfoViewController* driverImfoController = [[[DriverInfoViewController alloc] initWithNibName:@"DriverInfoViewController" bundle:nil] autorelease];
        driverImfoController.user = user;
        driverImfoController.delegate = self;
        
        [[KGModal sharedInstance] showWithContentViewController:driverImfoController andAnimated:YES];
    }
    
    [googleMapView animateToLocation:marker.position];
    
    return YES;
}

#pragma mark - MapViewControllerProtocol

- (void) didMakeOrder:(id)sender
{
    if ([sender isKindOfClass:[FindCarViewController class]])
    {
        findCarController = (FindCarViewController*)sender;
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_9", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"MESSAGE_4", @"") otherButtonTitles:@"OK", nil] autorelease];
        alert.tag = 1000;
        [alert show];
    }
}

- (void) showWaitingControllerOnMainThread:(Message*)message
{
    [[KGModal sharedInstance] hideAnimated:NO];
    
    WaitingViewController* waitingController = [[[WaitingViewController alloc] initWithNibName:@"WaitingViewController" bundle:nil] autorelease];
    waitingController.delegate = self;
    waitingController.object = message;
    
    [[KGModal sharedInstance] showWithContentViewController:waitingController andAnimated:YES];
    
    idleTimerDisabled = [UIApplication sharedApplication].idleTimerDisabled;
    
    // funny hack
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void) didCancelOrder:(id)sender
{
    NetworkManager* networkManager = DELEGATE.networkManager;
    
    WaitingViewController* waitingController = (WaitingViewController*)sender;
    Message* message = (Message*)waitingController.object;
    message.flag = @"0";
    
    [DELEGATE showActivity];
    [networkManager handleMessage:message success:^{
        [DELEGATE hideActivity];
       [[KGModal sharedInstance] hideAnimated:YES];
        [DELEGATE.managedObjectContext deleteObject:message];
    } onError:^(NSString *error) {
        [DELEGATE hideActivity];
        [DELEGATE.managedObjectContext deleteObject:message];
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    }];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = idleTimerDisabled;
}

- (void) didWaitingTimeOut:(id)sender
{
    NetworkManager* networkManager = DELEGATE.networkManager;
    
    WaitingViewController* waitingController = (WaitingViewController*)sender;
    Message* message = (Message*)waitingController.object;
    message.flag = @"0";
    
    [DELEGATE showActivity];
    [networkManager handleMessage:message success:^{
        [DELEGATE hideActivity];
        [[KGModal sharedInstance] hideAnimated:YES];
        [DELEGATE.managedObjectContext deleteObject:message];
        
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_10", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    } onError:^(NSString *error) {
        [DELEGATE hideActivity];
        [DELEGATE.managedObjectContext deleteObject:message];
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    }];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = idleTimerDisabled;
}

#pragma mark - Private Methods

- (void) findUsers
{
    [DELEGATE showActivity];
    
    NetworkManager* networkManager = DELEGATE.networkManager;
    [networkManager usersOfGroup:self.group fullInfo:YES success:^(NSArray *usersOrPins) {
        [DELEGATE.managedObjectContext save:nil];
        
        [users removeAllObjects];
        [users addObject:DELEGATE.me];

        for (User* u in usersOrPins)
        {
            if ([[u.type lowercaseString] isEqualToString:@"taxist"])
            {
                [users addObject:u];
            }
        }
        
        [self getCoordinates];
    } onError:^(NSString *error) {
        [DELEGATE hideActivity];
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    }];
}

- (void) getMessages:(NSInteger)messageQuantity onReturn:(void(^)(Message* message))onReturn
{
    NetworkManager* networkManager = DELEGATE.networkManager;
    [networkManager messages:messageQuantity success:^(NSArray *messages) {
        if (messages.count > 0)
        {
            WaitingViewController* waitingController = [[KGModal sharedInstance] contentViewController];
            Message* message = waitingController.object;
            
            Message* gotMessage = [messages objectAtIndex:0];
            message.flag = gotMessage.flag;
            message.from = gotMessage.from;
            
            //NSLog(@"%@", gotMessage.from.car);
            
            onReturn(message);
        }
        else
        {
            onReturn(nil);
        }
        
    } onError:^(NSString *error) {
        //NSLog(@"getMessages error: %@", error);
        
        onReturn(nil);
    }];
}

- (void) getCoordinates
{
    NetworkManager* networkManager = DELEGATE.networkManager;
    [networkManager usersOfGroup:self.group fullInfo:NO success:^(NSArray *usersOrPins) {
        [DELEGATE hideActivity];
        
        for (Pin* p in usersOrPins)
        {
            for (User* u in users)
            {
                if ([p.userId isEqualToString:u.index])
                {
                    u.pin = p;
                    break;
                }
            }
        }
        
        timerInProgress = NO;
        [self showUsers];
    } onError:^(NSString *error) {
        [DELEGATE hideActivity];
        timerInProgress = NO;
    }];
}

- (void) showUsers
{
    if ([users count] < [markers count])
    {
        NSMutableArray* tempContent = [[NSMutableArray alloc] init];
        
        // remove markers from the map
        for (GMSMarker* m in markers)
        {
            BOOL exists = NO;
            User* u = (User*)m.userData;
            for (User* user in users)
            {
                if ([[user.index lowercaseString] isEqualToString:[u.index lowercaseString]])
                {
                    exists = YES;
                    break;
                }
            }
            
            if (!exists)
            {
                m.map = nil;
                [tempContent addObject:m];
            }
        }
        
        while ([tempContent count] > 0)
        {
            for (GMSMarker* m1 in tempContent)
            {
                for (GMSMarker* m2 in markers)
                {
                    if (m1 == m2)
                    {
                        [markers removeObject:m1];
                        break;
                    }
                }
            }
        };
        
        [tempContent removeAllObjects];
        [tempContent release];
    }
    
    NSInteger totalCars = 0;
    NSInteger freeCars = 0;
    // update or add markers on the map
    for (User* user in users)
    {
        if ([[user.type lowercaseString] isEqualToString:@"taxist"])
        {
            totalCars++;
            GMSMarker* marker = nil;
            for (GMSMarker* m in markers)
            {
                User* u = (User*)m.userData;
                
                if ([[user.index lowercaseString] isEqualToString:[u.index lowercaseString]])
                {
                    marker = m;
                    break;
                }
            }
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [user.pin.latitude doubleValue];
            coordinate.longitude = [user.pin.longitude doubleValue];
            
            if (!marker)
            {
                marker = [GMSMarker markerWithPosition:coordinate];
                marker.userData = user;
                marker.title = user.car.licensePlate;
                marker.map = self.googleMapView;
                [markers addObject:marker];
            }
            else
            {
                marker.position = coordinate;
            }
            
            
            if ([driverIndex isEqualToString:user.index])
            {
                driverOnWay = user;
                marker.icon = [UIImage imageNamed:@"CabMarkerOnAWay.png"];
                [googleMapView animateToLocation:marker.position];
                
                // calculate distance
                CLLocation* meLocation = [[[CLLocation alloc] initWithLatitude:me_marker.position.latitude longitude:me_marker.position.longitude] autorelease];
                CLLocation* userLocation = [[[CLLocation alloc] initWithLatitude:[user.pin.latitude doubleValue] longitude:[user.pin.longitude doubleValue]] autorelease];
                
                CLLocationDistance distance = [meLocation distanceFromLocation:userLocation];
                
                NSString* distanceString = nil;
                if (distance < 1000.f)
                {
                    distanceString = [NSString stringWithFormat:@"%.1f meters", distance];
                }
                else
                {
                    distanceString = [NSString stringWithFormat:@"%.1f kilometers", distance / 1000.f];
                }
                
                distanceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MESSAGE_14", @""), distanceString];
            }
            else if ([user.status integerValue] == 1)
            {
                marker.icon = [UIImage imageNamed:@"CabMarkerBusy.png"];
            }
            else
            {
                freeCars++;
                marker.icon = [UIImage imageNamed:@"CabMarkerFree.png"];
            }
        }
    }
    
    totalCarsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MESSAGE_15", @""), totalCars];
    freeCarsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MESSAGE_16", @""), freeCars];
    
    if (driverOnWay)
    {
        [findCarButton setTitle:NSLocalizedString(@"MESSAGE_17", @"") forState:UIControlStateNormal];
        [findCarButton setTitle:NSLocalizedString(@"MESSAGE_17", @"") forState:UIControlStateSelected];
        
        [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_18", @"") forState:UIControlStateNormal];
        [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_18", @"") forState:UIControlStateSelected];
    }
    else
    {
        [findCarButton setTitle:NSLocalizedString(@"MESSAGE_19", @"") forState:UIControlStateNormal];
        [findCarButton setTitle:NSLocalizedString(@"MESSAGE_19", @"") forState:UIControlStateSelected];
        
        [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_20", @"") forState:UIControlStateNormal];
        [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_20", @"") forState:UIControlStateSelected];
    }
}

- (void) timerFire:(id)sender
{
    if (!timerInProgress)
    {
        timerInProgress = YES;
        NetworkManager* networkManager = DELEGATE.networkManager;
        [DELEGATE showActivity];
        
        // 1. ping server
        [networkManager ping:0 success:^(NSInteger messageQuantity, NSString *version, NSArray *leftUsers, NSArray *joinedUsers) {
            
            for (NSNumber* leftUser in leftUsers)
            {
                for (User* u in users)
                {
                    if ([leftUser integerValue] == [u.index integerValue])
                    {
                        [users removeObject:u];
                        break;
                    }
                }
            }
            
            for (User* joinedUser in joinedUsers)
            {
                BOOL exists = NO;
                
                for (User* u in users)
                {
                    if ([[joinedUser.index lowercaseString] isEqualToString:[u.index lowercaseString]])
                    {
                        exists = YES;
                        break;
                    }
                }
                
                if (!exists)
                {
                    if ([[joinedUser.type lowercaseString] isEqualToString:@"taxist"])
                    {
                        [users addObject:joinedUser];
                    }
                }
            }
            
            // 2. get messages
            if (messageQuantity > 0)
            {
                [self getMessages:messageQuantity onReturn:^(Message *message) {
                    if (message)
                    {
                        [[KGModal sharedInstance] hideAnimated:YES];
                        
                        if ([message.flag integerValue] == 20)
                        {
                            // order was canceled
                            
                            // cancel order
                            WaitingViewController* waitingController = [[KGModal sharedInstance] contentViewController];
                            Message* message = waitingController.object;
                            message.flag = @"0";
                            
                            [networkManager handleMessage:message success:^{
                                [[KGModal sharedInstance] hideAnimated:YES];
                                
                                // show alert
                                UIAlertView* errorAlert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_11", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                                [errorAlert show];
                            } onError:^(NSString *error) {
                            }];
                            
                            [driverIndex release];
                            driverIndex = nil;
                        }
                        else if ([message.flag integerValue] == 10)
                        {
                            // order was acceppted
                            [driverIndex release];
                            driverIndex = nil;
                            
                            // get driver's id
                            User* driver = message.from;
                            driverIndex = [[NSString alloc] initWithString:driver.index];
                            
                            //[DELEGATE.managedObjectContext insertObject:message];
                            [DELEGATE.managedObjectContext save:nil];
                            [[KGModal sharedInstance] hideAnimated:YES];
                            
                            NSString* text = message.text;
                            
                            NSRegularExpression* regexCost = [NSRegularExpression regularExpressionWithPattern:@"cost:(.*?)]" options:NSRegularExpressionCaseInsensitive error:nil];
                            NSRegularExpression* regexTime = [NSRegularExpression regularExpressionWithPattern:@"arrivetime:(.*?)]" options:NSRegularExpressionCaseInsensitive error:nil];
                            
                            NSTextCheckingResult* textCost = nil;
                            NSTextCheckingResult* textTime = nil;
                            if (text)
                            {
                                textCost = [regexCost firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
                                textTime = [regexTime firstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
                            }
                            
                            // show alert
                            NSString* message = [NSString stringWithFormat:NSLocalizedString(@"MESSAGE_12", @""), driver.car.licensePlate, driver.car.model, driver.name, textTime, textCost];
                            UIAlertView* errorAlert = [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                            [errorAlert show];
                        }
                    }
                    
                    // 3. update coordinates of taxists
                    [self getCoordinates];
                }];
            }
            else
            {
                // 3. update coordinates of taxists
                if (updateStatusCounter++ >= 10)
                {
                    updateStatusCounter = 0;
                    [self findUsers];
                }
                else
                {
                    [self getCoordinates];
                }
            }
        } onError:^(NSString *error) {
            [DELEGATE hideActivity];
        }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000)
    {
        if (buttonIndex == 1)
        {
            NetworkManager* networkManager = DELEGATE.networkManager;
            
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            //[params setObject:[NSString stringWithFormat:@"%d", [DELEGATE.me.messages count] + 1] forKey:@"index"];
            
            [params setObject:[NSString stringWithFormat:@"[latlon:%f,%f][displayAddress:%@]", findCarController.marker_from.position.latitude, findCarController.marker_from.position.longitude, findCarController.fromField.text] forKey:@"beginPoint"];
            if (findCarController.marker_to)
            {
                [params setObject:[NSString stringWithFormat:@"[latlon:%f,%f][displayAddress:%@]", findCarController.marker_to.position.latitude, findCarController.marker_to.position.longitude, findCarController.toField.text] forKey:@"endPoint"];
            }
            [params setObject:[DELEGATE.me toDictionary] forKey:@"from"];
            [params setObject:@"1" forKey:@"flag"];
            
            NSMutableString* criteria = [NSMutableString string];
            if (findCarController.user)
            {
                [criteria appendFormat:@"[to_user_id:%@]", findCarController.user.index];
            }
            else
            {
                id<DropDownItemProtocol> tariffDayCity = [findCarController.tariffDayCityDropDown currentValue];
                //id<DropDownItemProtocol> tariffNightCity = [findCarController.tariffNightCityDropDown currentValue];
                id<DropDownItemProtocol> tariffDayOutCity = [findCarController.tariffDayOutCityDropDown currentValue];
                //id<DropDownItemProtocol> tariffNightOutCity = [findCarController.tariffNightOutCityDropDown currentValue];
                //id<DropDownItemProtocol> tariffHoliday = [findCarController.tariffHolidayDropDown currentValue];
                id<DropDownItemProtocol> tariffSeat = [findCarController.tariffSeatDropDown currentValue];
                id<DropDownItemProtocol> tariffTime = [findCarController.tariffTimeDropDown currentValue];
                
                if (tariffDayCity.object1)
                {
                    [criteria appendFormat:@"[tariffDayCity>=%@]", tariffDayCity.object1];
                }
                if (tariffDayCity.object2)
                {
                    [criteria appendFormat:@"[tariffDayCity<=%@]", tariffDayCity.object2];
                }
                
                /*if (tariffNightCity.object1)
                {
                    [criteria appendFormat:@"[tariffNightCity>=%@]", tariffNightCity.object1];
                }
                if (tariffNightCity.object2)
                {
                    [criteria appendFormat:@"[tariffNightCity<=%@]", tariffNightCity.object2];
                }*/
                
                if (tariffDayOutCity.object1)
                {
                    [criteria appendFormat:@"[tariffDayOutCity>=%@]", tariffDayOutCity.object1];
                }
                if (tariffDayOutCity.object2)
                {
                    [criteria appendFormat:@"[tariffDayOutCity<=%@]", tariffDayOutCity.object2];
                }
                
                /*if (tariffNightOutCity.object1)
                {
                    [criteria appendFormat:@"[tariffNightOutCity>=%@]", tariffNightOutCity.object1];
                }
                if (tariffNightOutCity.object2)
                {
                    [criteria appendFormat:@"[tariffNightOutCity<=%@]", tariffNightOutCity.object2];
                }
                
                if (tariffHoliday.object1)
                {
                    [criteria appendFormat:@"[tariffHoliday>=%@]", tariffHoliday.object1];
                }
                if (tariffHoliday.object2)
                {
                    [criteria appendFormat:@"[tariffHoliday<=%@]", tariffHoliday.object2];
                }*/
                
                if (tariffSeat.object1)
                {
                    [criteria appendFormat:@"[tariffSeat>=%@]", tariffSeat.object1];
                }
                if (tariffSeat.object2)
                {
                    [criteria appendFormat:@"[tariffSeat<=%@]", tariffSeat.object2];
                }
                
                if (tariffTime.object1)
                {
                    [criteria appendFormat:@"[tariffTime>=%@]", tariffTime.object1];
                }
                if (tariffTime.object2)
                {
                    [criteria appendFormat:@"[tariffTime<=%@]", tariffTime.object2];
                }
                
                if (findCarController.smokeSwitch.on)
                {
                    [criteria appendString:@"[can_smoke:1]"];
                }
            }
            
            [criteria appendFormat:@"[name:%@][phone:%@]", findCarController.nameField.text, findCarController.phoneField.text];
            [params setObject:criteria forKey:@"text"];
            
            // create a message
            Message* message = [Message createManagedObjectFromDictionary:params inContext:DELEGATE.managedObjectContext];
            //[DELEGATE.me addMessagesObject:message];
            
            [DELEGATE showActivity];
            [networkManager handleMessage:message success:^{
                [DELEGATE hideActivity];
                [self performSelectorOnMainThread:@selector(showWaitingControllerOnMainThread:) withObject:message waitUntilDone:NO];
            } onError:^(NSString *error) {
                if ([error integerValue] == 14)
                {
                    // cancel the last order
                    message.flag = @"0";
                    [networkManager handleMessage:message success:^{
                        // repeir making of order
                        message.flag = @"1";
                        [networkManager handleMessage:message success:^{
                            [DELEGATE hideActivity];
                            [self performSelectorOnMainThread:@selector(showWaitingControllerOnMainThread:) withObject:message waitUntilDone:NO];
                        } onError:^(NSString *error) {
                            [DELEGATE hideActivity];
                            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                            [alert show];
                        }];
                    } onError:^(NSString *error) {
                        [DELEGATE hideActivity];
                        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                        [alert show];
                    }];
                }
                else
                {
                    [DELEGATE hideActivity];
                    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                    [alert show];
                }
            }];
        }
    }
    else if (alertView.tag == 2000)
    {
        if (buttonIndex == 1)
        {
            // reset
            driverIndex = @"-1";
            driverOnWay = nil;
            [findCarButton setTitle:NSLocalizedString(@"MESSAGE_19", @"") forState:UIControlStateNormal];
            [findCarButton setTitle:NSLocalizedString(@"MESSAGE_19", @"") forState:UIControlStateSelected];
            
            [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_20", @"") forState:UIControlStateNormal];
            [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_20", @"") forState:UIControlStateSelected];
            
            // call
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", driverOnWay.phone]]];
        }
        else if (buttonIndex == 2)
        {
            // reset
            driverIndex = @"-1";
            driverOnWay = nil;
            [findCarButton setTitle:NSLocalizedString(@"MESSAGE_19", @"") forState:UIControlStateNormal];
            [findCarButton setTitle:NSLocalizedString(@"MESSAGE_19", @"") forState:UIControlStateSelected];
            
            [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_20", @"") forState:UIControlStateNormal];
            [historyOfOrdersButoon setTitle:NSLocalizedString(@"MESSAGE_20", @"") forState:UIControlStateSelected];
        }
    }
    else if (buttonIndex == 1)
    {
        [timer invalidate];
        timer = nil;
        
        [DELEGATE showActivity];
        NetworkManager* networkManager = DELEGATE.networkManager;
        [networkManager leaveGroup:self.group success:^{
            [DELEGATE hideActivity];
            [self.navigationController popViewControllerAnimated:YES];
        } onError:^(NSString *error) {
            [DELEGATE hideActivity];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
