//
//  FindCarViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "FindCarViewController.h"
#import "KGModal.h"
#import "NetworkManager.h"
#import "PPDbManager.h"
#import "Tariff+Category.h"
#import "DropDownItem.h"
#import "BSKeyboardControls.h"

@interface FindCarViewController ()
- (void) initDropDowns;
- (void) showMarkerPlace:(GMSMarker*)marker;
- (void) getAddresses:(GMSMarker*)marker success:(void(^)(NSArray* addresses))onSuccess onError:(void(^)(NSString* error))onError;

@end

@implementation FindCarViewController
@synthesize background, closeButton, scrollView, mapBackground, nameBackground, phoneBackground, fromBackground, toBackground,  makeOrderButton;
@synthesize nameField, phoneField, fromField, toField;
@synthesize tariffDayCityLabel, /*tariffNightCityLabel, */tariffDayOutCityLabel, /*tariffNightOutCityLabel, */tariffSeatLabel, tariffTimeLabel;
@synthesize fromButton, toButton, smokeSwitch, smokeLabel, yesLabel, noLabel;
@synthesize googleMapView, user, delegate;
@synthesize marker_from, marker_to;
@synthesize tariffDayCityDropDown, tariffDayOutCityDropDown, /*tariffDowntimeDropDown, tariffHolidayDropDown, tariffNightCityDropDown, tariffNightOutCityDropDown, */tariffSeatDropDown, tariffTimeDropDown;

- (void) dealloc
{
    [tariffDayCityDropDown release];
    //[tariffNightCityDropDown release];
    [tariffDayOutCityDropDown release];
    //[tariffNightOutCityDropDown release];
    //[tariffHolidayDropDown release];
    [tariffSeatDropDown release];
    [tariffTimeDropDown release];
    //[tariffDowntimeDropDown release];
    [locationManager release];
    [timer invalidate];
    
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
    if (user)
    {
        // hide all fields excepts name, phone, addresses and make order button
        tariffDayCityDropDown.hidden = YES;
        tariffDayOutCityDropDown.hidden = YES;
        tariffTimeDropDown.hidden = YES;
        tariffSeatDropDown.hidden = YES;
        
        /*tariffNightCityDropDown.hidden = YES;
        tariffNightOutCityDropDown.hidden = YES;
        tariffHolidayDropDown.hidden = YES;
        tariffDowntimeDropDown.hidden = YES;*/
        smokeSwitch.hidden = YES;
        
        tariffDayCityLabel.hidden = YES;
        tariffDayOutCityLabel.hidden = YES;
        tariffTimeLabel.hidden = YES;
        tariffSeatLabel.hidden = YES;
        
        /*tariffNightCityLabel.hidden = YES;
        tariffNightOutCityLabel.hidden = YES;*/
        
        smokeLabel.hidden = YES;
        yesLabel.hidden = YES;
        noLabel.hidden = YES;
        
        CGRect orderFrame = CGRectMake(22.0, 200.0, 248.0, 48.0);
        makeOrderButton.frame = orderFrame;
        
        scrollView.contentSize = CGSizeMake(293.0, 270.0);
    }
    
    nameField.text = DELEGATE.me.name;
    phoneField.text = DELEGATE.me.phone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // resize background image
    UIImage* backgroundImage = [UIImage imageNamed:@"PopUp@2x.png"];
    UIImage* resizeBackgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:20.0];
    background.image = resizeBackgroundImage;
    
    // resize name image
    UIImage* nameImage = [UIImage imageNamed:@"InPopUpForm.png"];
    UIImage* resizeNameImage = [nameImage stretchableImageWithLeftCapWidth:9.0 topCapHeight:20.0];
    nameBackground.image = resizeNameImage;
    
    // resize phone image
    phoneBackground.image = resizeNameImage;
    
    // resize from image
    fromBackground.image = resizeNameImage;
    
    // resize to image
    toBackground.image = resizeNameImage;
    
    // resize make order button image
    UIImage* makeOrderImage = [UIImage imageNamed:@"MainBtn@2x.png"];
    UIImage* resizeMakeOrderImage = [makeOrderImage stretchableImageWithLeftCapWidth:18.0 topCapHeight:0.0];
    [makeOrderButton setBackgroundImage:resizeMakeOrderImage forState:UIControlStateNormal];
    
    scrollView.contentSize = CGSizeMake(293.0, 920.0);
    
    googleMapView.trafficEnabled = YES;
    googleMapView.delegate = self;
    googleMapView.settings.rotateGestures = NO;
    [googleMapView animateToZoom:13.0];
    
    [self initDropDowns];
    [self startLocationManager];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:scrollView selector:@selector(flashScrollIndicators) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handlers

- (IBAction)closeButtonClicked:(id)sender
{
    [timer invalidate];
    timer = nil;
    
    tariffDayCityDropDown.delegate = nil;
    tariffDayOutCityDropDown.delegate = nil;
    tariffTimeDropDown.delegate = nil;
    tariffSeatDropDown.delegate = nil;
    
    /*tariffNightCityDropDown.delegate = nil;
    tariffNightOutCityDropDown.delegate = nil;
    tariffHolidayDropDown.delegate = nil;*/
    
    [[KGModal sharedInstance] hideAnimated:YES];
}

- (IBAction)makeOrderButtonClicked:(id)sender
{
    // validate fields
    BOOL valide1 = [nameField validate];
    BOOL valide2 = [phoneField validate];
    BOOL valide3 = [fromField validate];
    BOOL valide4 = marker_from ? YES : NO;
    
    if (!valide1)
    {
        [scrollView scrollRectToVisible:nameField.frame animated:YES];
    }
    else if (!valide2)
    {
        [scrollView scrollRectToVisible:phoneField.frame animated:YES];

    }
    else if (!valide3)
    {
        [scrollView scrollRectToVisible:fromField.frame animated:YES];

    }
    
    if (valide1 && valide2 && valide3 && valide4)
    {
        DELEGATE.me.name = nameField.text;
        DELEGATE.me.phone = phoneField.text;
        [delegate performSelector:@selector(didMakeOrder:) withObject:self];
    }
    
    if (!valide4)
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_6", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (IBAction)fromButtonClicked:(id)sender
{
    fromButton.selected = YES;
    toButton.selected = NO;
}

- (IBAction)toButtonClicked:(id)sender
{
    fromButton.selected = NO;
    toButton.selected = YES;
}

#pragma mark UITextFieldDelegate

-(void)didShowKeyboard:(NSNotification *)notification
{
    UIScrollView* scroll = (UIScrollView*)self.view;
    scroll.scrollEnabled = YES;
    scroll.contentSize = CGSizeMake(320.0, 600.0);
    [scroll scrollRectToVisible:CGRectMake(0.0, 100.0, 320.0, 457.0) animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    UIScrollView* scroll = (UIScrollView*)self.view;
    scroll.scrollEnabled = YES;
    scroll.contentSize = CGSizeMake(320.0, 457.0);
    [scroll scrollRectToVisible:CGRectMake(0.0, 0.0, 320.0, 457.0) animated:YES];
    
	[textField resignFirstResponder];
	return YES;
}

#pragma mark CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations count] > 0)
    {
        CLLocation* newLocation = [locations lastObject];
        
        if (!marker_from)
        {
            marker_from = [GMSMarker markerWithPosition:newLocation.coordinate];
            marker_from.icon = [UIImage imageNamed:@"IcnMap.png"];
            marker_from.map = googleMapView;
            
            [googleMapView animateToLocation:newLocation.coordinate];
            
            [self showMarkerPlace:marker_from];
        }
    }
    
    [self performSelectorOnMainThread:@selector(stopLocationManagerWithDelay) withObject:nil waitUntilDone:NO];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!marker_from)
    {
        marker_from = [GMSMarker markerWithPosition:newLocation.coordinate];
        marker_from.icon = [UIImage imageNamed:@"IcnMap.png"];
        marker_from.map = googleMapView;
        
        [googleMapView animateToLocation:newLocation.coordinate];
        
        [self showMarkerPlace:marker_from];
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

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (fromButton.selected)
    {
        marker_from.position = coordinate;
        [self showMarkerPlace:marker_from];
    }
    else if (toButton.selected)
    {
        if (!marker_to)
        {
            marker_to = [GMSMarker markerWithPosition:coordinate];
            marker_to.icon = [UIImage imageNamed:@"IcnMap.png"];
            marker_to.map = googleMapView;
        }
        
        marker_to.position = coordinate;
        [self showMarkerPlace:marker_to];
    }
    
    [googleMapView animateToLocation:coordinate];
}

#pragma mark - Private Methods

- (void) initDropDowns
{
    if (!user)
    {
        tariffDayCityDropDown = [[[iOSCombobox alloc] initWithFrame:CGRectMake(21.0f, 208.0f, 248.f, 56.0f)] autorelease];
        [scrollView addSubview:tariffDayCityDropDown];
        
        BSKeyboardControls* bsControl1 = [[[BSKeyboardControls alloc] initWithFields:@[tariffDayCityDropDown]] autorelease];
        bsControl1.doneTitle = NSLocalizedString(@"MESSAGE_26", @"");
        bsControl1.hideCancel = YES;
        [bsControl1 setDelegate:self];
        
        /*tariffNightCityDropDown = [[[iOSCombobox alloc] initWithFrame:CGRectMake(21.0f, 292.0f, 248.f, 56.0f)] autorelease];
        [tariffNightCityDropDown setDelegate:self];
        [scrollView addSubview:tariffNightCityDropDown];
        
        BSKeyboardControls* bsControl2 = [[[BSKeyboardControls alloc] initWithFields:@[tariffNightCityDropDown]] autorelease];
        bsControl2.doneTitle = NSLocalizedString(@"MESSAGE_26", @"");
        bsControl2.hideCancel = YES;
        [bsControl2 setDelegate:self];*/
        
        tariffDayOutCityDropDown = [[[iOSCombobox alloc] initWithFrame:CGRectMake(21.0f, 375.0f, 248.f, 56.0f)] autorelease];
        [tariffDayOutCityDropDown setDelegate:self];
        [scrollView addSubview:tariffDayOutCityDropDown];
        
        BSKeyboardControls* bsControl3 = [[[BSKeyboardControls alloc] initWithFields:@[tariffDayOutCityDropDown]] autorelease];
        bsControl3.doneTitle = NSLocalizedString(@"MESSAGE_26", @"");
        bsControl3.hideCancel = YES;
        [bsControl3 setDelegate:self];
        
        /*tariffNightOutCityDropDown = [[[iOSCombobox alloc] initWithFrame:CGRectMake(21.0f, 459.0f, 248.f, 56.0f)] autorelease];
        [tariffNightOutCityDropDown setDelegate:self];
        [scrollView addSubview:tariffNightOutCityDropDown];
        
        BSKeyboardControls* bsControl4 = [[[BSKeyboardControls alloc] initWithFields:@[tariffNightOutCityDropDown]] autorelease];
        bsControl4.doneTitle = NSLocalizedString(@"MESSAGE_26", @"");
        bsControl4.hideCancel = YES;
        [bsControl4 setDelegate:self];*/
        
        /*tariffHolidayDropDown = [[[iOSCombobox alloc] initWithFrame:CGRectMake(21.0f, 545.0f, 248.f, 56.0f)] autorelease];
        [tariffHolidayDropDown setDelegate:self];
        [scrollView addSubview:tariffHolidayDropDown];
        
        BSKeyboardControls* bsControl5 = [[[BSKeyboardControls alloc] initWithFields:@[tariffHolidayDropDown]] autorelease];
        bsControl5.doneTitle = NSLocalizedString(@"MESSAGE_26", @"");
        bsControl5.hideCancel = YES;
        [bsControl5 setDelegate:self];*/
        
        tariffSeatDropDown = [[[iOSCombobox alloc] initWithFrame:CGRectMake(21.0f, 630.0f, 248.f, 56.0f)] autorelease];
        [tariffSeatDropDown setDelegate:self];
        [scrollView addSubview:tariffSeatDropDown];
        
        BSKeyboardControls* bsControl6 = [[[BSKeyboardControls alloc] initWithFields:@[tariffSeatDropDown]] autorelease];
        bsControl6.doneTitle = NSLocalizedString(@"MESSAGE_26", @"");
        bsControl6.hideCancel = YES;
        [bsControl6 setDelegate:self];
        
        tariffTimeDropDown = [[[iOSCombobox alloc] initWithFrame:CGRectMake(21.0f, 719.0f, 248.f, 56.0f)] autorelease];
        [tariffTimeDropDown setDelegate:self];
        [scrollView addSubview:tariffTimeDropDown];
        
        BSKeyboardControls* bsControl7 = [[[BSKeyboardControls alloc] initWithFields:@[tariffTimeDropDown]] autorelease];
        bsControl7.doneTitle = @"Выбрать";
        bsControl7.hideCancel = YES;
        [bsControl7 setDelegate:self];
        
        // calculate tariff
        NSArray* tariffArray = [PPDbManager loadAllItemsForName:@"Tariff" withCriteria:nil];
        
        float tariffDayCityMin = 0;
        float tariffDayCityMax = 0;
        
        //float tariffNightCityMin = 0;
        //float tariffNightCityMax = 0;
        
        float tariffDayOutCityMin = 0;
        float tariffDayOutCityMax = 0;
        
        //float tariffNightOutCityMin = 0;
        //float tariffNightOutCityMax = 0;
        
        //float tariffHolidayMin = 0;
        //float tariffHolidayMax = 0;
        
        float tariffSeatMin = 0;
        float tariffSeatMax = 0;
        
        float tariffTimeMin = 0;
        float tariffTimeMax = 0;
        
        for (Tariff* t in tariffArray)
        {
            NSUInteger index = [tariffArray indexOfObject:t];
            if (index == 0)
            {
                tariffDayCityMin = [t.tariffDayCity floatValue];
                //tariffNightCityMin = [t.tariffNightCity floatValue];
                tariffDayOutCityMin = [t.tariffDayOutCity floatValue];
                //tariffNightOutCityMin = [t.tariffNightOutCity floatValue];
                //tariffHolidayMin = [t.tariffHoliday floatValue];
                tariffSeatMin = [t.tariffSeat floatValue];
                tariffTimeMin = [t.tariffTime floatValue];
            }
            
            if (tariffDayCityMin > [t.tariffDayCity floatValue])
            {
                tariffDayCityMin = [t.tariffDayCity floatValue];
            }
            if (tariffDayCityMax < [t.tariffDayCity floatValue])
            {
                tariffDayCityMax = [t.tariffDayCity floatValue];
            }
            
            /*if (tariffNightCityMin > [t.tariffNightCity floatValue])
            {
                tariffNightCityMin = [t.tariffNightCity floatValue];
            }
            if (tariffNightCityMax < [t.tariffNightCity floatValue])
            {
                tariffNightCityMax = [t.tariffNightCity floatValue];
            }*/
            
            if (tariffDayOutCityMin > [t.tariffDayOutCity floatValue])
            {
                tariffDayOutCityMin = [t.tariffDayOutCity floatValue];
            }
            if (tariffDayOutCityMax < [t.tariffDayOutCity floatValue])
            {
                tariffDayOutCityMax = [t.tariffDayOutCity floatValue];
            }
            
            /*if (tariffNightOutCityMin > [t.tariffNightOutCity floatValue])
            {
                tariffNightOutCityMin = [t.tariffNightOutCity floatValue];
            }
            if (tariffNightOutCityMax < [t.tariffNightOutCity floatValue])
            {
                tariffNightOutCityMax = [t.tariffNightOutCity floatValue];
            }
            
            if (tariffHolidayMin > [t.tariffHoliday floatValue])
            {
                tariffHolidayMin = [t.tariffHoliday floatValue];
            }
            if (tariffHolidayMax < [t.tariffHoliday floatValue])
            {
                tariffHolidayMax = [t.tariffHoliday floatValue];
            }*/
            
            if (tariffSeatMin > [t.tariffSeat floatValue])
            {
                tariffSeatMin = [t.tariffSeat floatValue];
            }
            if (tariffSeatMax < [t.tariffSeat floatValue])
            {
                tariffSeatMax = [t.tariffSeat floatValue];
            }
            
            if (tariffTimeMin > [t.tariffTime floatValue])
            {
                tariffTimeMin = [t.tariffTime floatValue];
            }
            if (tariffTimeMax < [t.tariffTime floatValue])
            {
                tariffTimeMax = [t.tariffTime floatValue];
            }
        }
        
        // devide tariff on 5 blocks
        float tariffDayCityStaff = (tariffDayCityMax - tariffDayCityMin) / 3;
        //float tariffNightCityStaff = (tariffNightCityMax - tariffNightCityMin) / 3;
        float tariffDayOutCityStaff = (tariffDayOutCityMax - tariffDayOutCityMin) / 3;
        //float tariffNightOutCityStaff = (tariffNightOutCityMax - tariffNightOutCityMin) / 3;
        //float tariffHolidayStaff = (tariffHolidayMax - tariffHolidayMin) / 3;
        float tariffSeatStaff = (tariffSeatMax - tariffSeatMin) / 3;
        float tariffTimeStaff = (tariffTimeMax - tariffTimeMin) / 3;
        
        // init tariffDayCityDropDown dropdown
        NSMutableArray* tariffDayCityContent = [NSMutableArray array];
        DropDownItem* empty1 = [[[DropDownItem alloc] init] autorelease];
        [tariffDayCityContent addObject:empty1];
        if (tariffDayCityStaff > 0)
        {
            for (float v = tariffDayCityMin; v < tariffDayCityMax; v += tariffDayCityStaff)
            {
                NSMutableString* m = [NSMutableString stringWithFormat:NSLocalizedString(@"MESSAGE_27", @""), v, v + tariffDayCityStaff];
                
                DropDownItem* item = [[[DropDownItem alloc] init] autorelease];
                item.object1 = [NSNumber numberWithFloat:v];
                item.object2 = [NSNumber numberWithFloat:v + tariffDayCityStaff];
                item.displayName = m;
                [tariffDayCityContent addObject:item];
            }
        }
        [tariffDayCityDropDown setValues:tariffDayCityContent];
        
        // init tariffNightCityDropDown dropdown
        /*NSMutableArray* tariffNightCityContent = [NSMutableArray array];
        DropDownItem* empty2 = [[[DropDownItem alloc] init] autorelease];
        [tariffNightCityContent addObject:empty2];
        if (tariffNightCityStaff > 0)
        {
            for (float v = tariffNightCityMin; v < tariffNightCityMax; v += tariffNightCityStaff)
            {
                NSMutableString* m = [NSMutableString stringWithFormat:NSLocalizedString(@"MESSAGE_27", @""), v, v + tariffNightCityStaff];
                
                DropDownItem* item = [[[DropDownItem alloc] init] autorelease];
                item.object1 = [NSNumber numberWithFloat:v];
                item.object2 = [NSNumber numberWithFloat:v + tariffNightCityStaff];
                item.displayName = m;
                [tariffNightCityContent addObject:item];
            }
        }
        [tariffNightCityDropDown setValues:tariffNightCityContent];*/
        
        // init tariffDayOutCityDropDown dropdown
        NSMutableArray* tariffDayOutCityContent = [NSMutableArray array];
        DropDownItem* empty3 = [[[DropDownItem alloc] init] autorelease];
        [tariffDayOutCityContent addObject:empty3];
        if (tariffDayOutCityStaff > 0)
        {
            for (float v = tariffDayOutCityMin; v < tariffDayOutCityMax; v += tariffDayOutCityStaff)
            {
                NSMutableString* m = [NSMutableString stringWithFormat:NSLocalizedString(@"MESSAGE_27", @""), v, v + tariffDayOutCityStaff];
                
                DropDownItem* item = [[[DropDownItem alloc] init] autorelease];
                item.object1 = [NSNumber numberWithFloat:v];
                item.object2 = [NSNumber numberWithFloat:v + tariffDayOutCityStaff];
                item.displayName = m;
                [tariffDayOutCityContent addObject:item];
            }
        }
        [tariffDayOutCityDropDown setValues:tariffDayOutCityContent];
        
        // init tariffNightOutCityDropDown dropdown
        /*NSMutableArray* tariffNightOutCityContent = [NSMutableArray array];
        DropDownItem* empty4 = [[[DropDownItem alloc] init] autorelease];
        [tariffNightOutCityContent addObject:empty4];
        if (tariffNightOutCityStaff > 0)
        {
            for (float v = tariffNightOutCityMin; v < tariffNightOutCityMax; v += tariffNightOutCityStaff)
            {
                NSMutableString* m = [NSMutableString stringWithFormat:NSLocalizedString(@"MESSAGE_27", @""), v, v + tariffNightOutCityStaff];
                
                DropDownItem* item = [[[DropDownItem alloc] init] autorelease];
                item.object1 = [NSNumber numberWithFloat:v];
                item.object2 = [NSNumber numberWithFloat:v + tariffNightOutCityStaff];
                item.displayName = m;
                [tariffNightOutCityContent addObject:item];
            }
        }
        [tariffNightOutCityDropDown setValues:tariffNightOutCityContent];*/
        
        // init tariffHolidayDropDown dropdown
        /*NSMutableArray* tariffHolidayContent = [NSMutableArray array];
        DropDownItem* empty5 = [[[DropDownItem alloc] init] autorelease];
        [tariffHolidayContent addObject:empty5];
        if (tariffHolidayStaff > 0)
        {
            for (float v = tariffHolidayMin; v < tariffHolidayMax; v += tariffHolidayStaff)
            {
                NSMutableString* m = [NSMutableString stringWithFormat:NSLocalizedString(@"MESSAGE_27", @""), v, v + tariffHolidayStaff];
                
                DropDownItem* item = [[[DropDownItem alloc] init] autorelease];
                item.object1 = [NSNumber numberWithFloat:v];
                item.object2 = [NSNumber numberWithFloat:v + tariffHolidayStaff];
                item.displayName = m;
                [tariffHolidayContent addObject:item];
            }
        }
        [tariffHolidayDropDown setValues:tariffHolidayContent];*/
        
        // init tariffSeatDropDown dropdown
        NSMutableArray* tariffSeatContent = [NSMutableArray array];
        DropDownItem* empty6 = [[[DropDownItem alloc] init] autorelease];
        [tariffSeatContent addObject:empty6];
        if (tariffSeatStaff > 0)
        {
            for (float v = tariffSeatMin; v < tariffSeatMax; v += tariffSeatStaff)
            {
                NSMutableString* m = [NSMutableString stringWithFormat:NSLocalizedString(@"MESSAGE_27", @""), v, v + tariffSeatStaff];
                
                DropDownItem* item = [[[DropDownItem alloc] init] autorelease];
                item.object1 = [NSNumber numberWithFloat:v];
                item.object2 = [NSNumber numberWithFloat:v + tariffSeatStaff];
                item.displayName = m;
                [tariffSeatContent addObject:item];
            }
        }
        [tariffSeatDropDown setValues:tariffSeatContent];
        
        // init tariffTimeDropDown dropdown
        NSMutableArray* tariffTimeContent = [NSMutableArray array];
        DropDownItem* empty7 = [[[DropDownItem alloc] init] autorelease];
        [tariffTimeContent addObject:empty7];
        if (tariffTimeStaff > 0)
        {
            for (float v = tariffTimeMin; v < tariffTimeMax; v += tariffTimeStaff)
            {
                NSMutableString* m = [NSMutableString stringWithFormat:NSLocalizedString(@"MESSAGE_27", @""), v, v + tariffTimeStaff];
                
                DropDownItem* item = [[[DropDownItem alloc] init] autorelease];
                item.object1 = [NSNumber numberWithFloat:v];
                item.object2 = [NSNumber numberWithFloat:v + tariffTimeStaff];
                item.displayName = m;
                [tariffTimeContent addObject:item];
            }
        }
        [tariffTimeDropDown setValues:tariffTimeContent];
    }
}

- (void) showMarkerPlace:(GMSMarker*)marker
{
    [DELEGATE showActivity];
    [self getAddresses:marker success:^(NSArray *addresses) {
        [DELEGATE hideActivity];
        
        NSMutableString* address = [NSMutableString string];
        
        for (NSDictionary* a1 in addresses)
        {
            NSString* streetNumber = [NSString string];
            NSString* route = [NSString string];
            
            NSArray* addressComponents = [a1 objectForKey:@"address_components"];
            for (NSDictionary* a2 in addressComponents)
            {
                NSArray* types = [a2 objectForKey:@"types"];
                for (NSString* type in types)
                {
                    if ([type isEqualToString:@"street_number"])
                    {
                        streetNumber = [a2 objectForKey:@"long_name"];
                    }
                    if ([type isEqualToString:@"route"])
                    {
                        route = [a2 objectForKey:@"long_name"];
                    }
                }
            }
            
            [address appendFormat:@"%@, %@", route, streetNumber];
            
            if (marker == marker_from)
            {
                fromField.text = address;
            }
            else if (marker == marker_to)
            {
                toField.text = address;
            }
            
            break;
        }
    } onError:^(NSString *error) {
        [DELEGATE hideActivity];
    }];
}

- (void) getAddresses:(GMSMarker*)marker success:(void(^)(NSArray* addresses))onSuccess onError:(void(^)(NSString* error))onError
{
    [[DELEGATE networkManager] getAddresses:marker.position success:^(NSArray *addresses) {
        onSuccess(addresses);
    } onError:^(NSString *error) {
        [DELEGATE hideActivity];
        onError(error);
    }];
}

#pragma mark - BSKeyboardControlsDelegate

- (void)keyboardControlsCancelPressed:(BSKeyboardControls *)keyboardControls
{
    iOSCombobox* dropDown = [keyboardControls.fields objectAtIndex:0];
    [dropDown resignFirstResponder];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    iOSCombobox* dropDown = [keyboardControls.fields objectAtIndex:0];
    [dropDown resignFirstResponder];
}

@end
