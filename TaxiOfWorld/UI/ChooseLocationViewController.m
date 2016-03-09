//
//  ChooseLocationViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "MapViewController.h"
#import "NetworkManager.h"

@interface ChooseLocationViewController ()
- (void) preLogin;
- (void) login;

@end

@implementation ChooseLocationViewController
@synthesize background, centerImageView, logoImageView, groupsLabel;

- (void) dealloc
{
    [groupsDropDown release];
    [pin release];
    [phoneNumber release];
    [alert release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self preLogin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    groupsDropDown = [[iOSCombobox alloc] initWithFrame:CGRectMake(36.0f, 217.0f, 248.f, 56.0f)];
    [self.view addSubview:groupsDropDown];
    
    BSKeyboardControls* bsControl = [[[BSKeyboardControls alloc] initWithFields:@[groupsDropDown]] autorelease];
    [bsControl setDelegate:self];
    
    [self preLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) preLogin
{
    [self startLocationManager];
}

- (void) login
{
    NSString* login = [NSString stringWithFormat:@"taxiofworldclient%@", phoneNumber];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phoneNumber forKey:@"phoneNumber"];
    [defaults synchronize];
    
    [DELEGATE showActivity];
    
    NSData* deviceToken = DELEGATE.deviceToken;
    [DELEGATE.networkManager login:login password:@"" pin:pin language:0 version:@"1" deviceToken:deviceToken success:^(NSString *session, User *user, NSArray *groups) {
        [DELEGATE hideActivity];
        
        DELEGATE.me = user;
        [DELEGATE.managedObjectContext save:nil];
        [groupsDropDown setValues:groups];
    } onError:^(NSString *error) {
        [DELEGATE hideActivity];
        
        //NSLog(@"%@", error);
        [alert release];
        alert = nil;
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MESSAGE_1", @"") message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        MapViewController* mapController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:mapController animated:YES];
    }];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied)
    {
        [DELEGATE hideActivity];
        
        UIAlertView* failAlert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_2", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [failAlert show];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations count] > 0)
    {
        CLLocation* newLocation = [locations lastObject];
        
        //NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:@"53.940345", @"latitude", @"27.597824", @"longitude", @"", @"index", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], @"time", @"Pin", @"class", nil];
        NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude], @"latitude", [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude], @"longitude", @"", @"index", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], @"time", @"Pin", @"class", nil];
        pin = [[Pin createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext] retain];
        
        [self performSelectorOnMainThread:@selector(stopLocationManagerWithDelay) withObject:nil waitUntilDone:YES];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:@"53.940345", @"latitude", @"27.597824", @"longitude", @"", @"index", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], @"time", @"Pin", @"class", nil];
    NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude], @"latitude", [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude], @"longitude", @"", @"index", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], @"time", @"Pin", @"class", nil];
    pin = [[Pin createManagedObjectFromDictionary:d inContext:DELEGATE.managedObjectContext] retain];
    
    [self performSelectorOnMainThread:@selector(stopLocationManagerWithDelay) withObject:nil waitUntilDone:YES];
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
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    [locationManager release];
    
    locationManager = nil;
    if (!alertVisibled)
    {
        alertVisibled = YES;
        [self performSelector:@selector(loginWithDelay) withObject:nil afterDelay:1.0];
    }
    else
    {
        [DELEGATE hideActivity];
    }
}

- (void) loginWithDelay
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    phoneNumber = [[defaults stringForKey:@"SBFormattedPhoneNumber"] retain];
    if ([phoneNumber length] == 0)
    {
        phoneNumber = [defaults objectForKey:@"phoneNumber"];
    }
    
    if ([phoneNumber length] > 0)
    {
        [self login];
    }
    else
    {
        [DELEGATE hideActivity];
        
        if (!alert && ([phoneNumber length] == 0))
        {
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MESSAGE_3", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"MESSAGE_4", @"") otherButtonTitles:@"OK", nil];
            alert.tag = 100;
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField* textField = [alert textFieldAtIndex:0];
            textField.keyboardType = UIKeyboardTypePhonePad;
            [alert show];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 100) && (buttonIndex == 1))
    {
        UITextField* textField = [alertView textFieldAtIndex:0];
        if ([textField.text length] > 0)
        {
            phoneNumber = [[NSString alloc] initWithString:textField.text];
            [self login];
            
            [alert release];
            alert = nil;
        }
        else
        {
            [alert release];
            alert = nil;
            
            alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"MESSAGE_4", @"") otherButtonTitles:@"OK", nil];
            alert.tag = 100;
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField* textField = [alert textFieldAtIndex:0];
            textField.placeholder = NSLocalizedString(@"MESSAGE_3", @"");
            [alert show];
        }
    }
}

#pragma mark - BSKeyboardControlsDelegate

- (void)keyboardControlsCancelPressed:(BSKeyboardControls *)keyboardControls
{
    [groupsDropDown resignFirstResponder];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [groupsDropDown resignFirstResponder];
    
    Group* group = [groupsDropDown currentValue];
    if (group)
    {
        [DELEGATE showActivity];
        
        // join to group
        NetworkManager* networkManager = DELEGATE.networkManager;
        [networkManager joinToGroup:group ticket:@"" success:^{
            [DELEGATE hideActivity];
            [DELEGATE.managedObjectContext save:nil];
            
            MapViewController* mapController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
            mapController.group = group;
            [self.navigationController pushViewController:mapController animated:YES];
        } onError:^(NSString *error) {
            [DELEGATE hideActivity];
            
            UIAlertView* errorAlert = [[[UIAlertView alloc] initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [errorAlert show];
        }];
    }
    else
    {
        [alert release];
        alert = nil;
        
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MESSAGE_1", @"") message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        MapViewController* mapController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:mapController animated:YES];
    }
}

@end
