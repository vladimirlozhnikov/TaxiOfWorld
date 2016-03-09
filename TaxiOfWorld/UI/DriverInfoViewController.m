//
//  DriverInfoViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 01.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "DriverInfoViewController.h"
#import "KGModal.h"
#import "DriverRatigViewController.h"
#import "Car+Category.h"
#import "Attachment+Category.h"
#import "Helper.h"
#import "Tariff.h"
#import "Rating+Category.h"
#import "FindCarViewController.h"

@interface DriverInfoViewController ()
- (void) addImageOnMainThread:(UIImageView*)photo;

@end

@implementation DriverInfoViewController
@synthesize background, photo, closeButton, firstNameLabel, lastNameLabel, surNameLabel, statusButton, rate1Image, rate2Image, rate3Image, rate4Image, rate5Image, photosScroll, scrollBackground, infoBackground, infoTextView, makeOrderButton, showRatingButton, user, delegate;

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
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    __block NSInteger x = 0;
    __block NSInteger y = 2;
    __block NSInteger dx = 90;
    __block NSInteger dy = 60;
    
    // download and save photos
    for (Attachment* a in user.car.photos)
    {
        if ([a.data length] == 0)
        {
            [Helper processImageDataWithURLString:[NSURL URLWithString:a.url] andBlock:^(NSData *imageData) {
                
                a.data = imageData;
                
                UIImageView* photoView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:a.data]] autorelease];
                photoView.frame = CGRectMake(x, y, dx, dy);
                [self performSelectorOnMainThread:@selector(addImageOnMainThread:) withObject:photoView waitUntilDone:NO];
                
                x += dx;
            }];
        }
        else
        {
            UIImageView* photoView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:a.data]] autorelease];
            photoView.frame = CGRectMake(x, y, dx, dy);
            [self performSelectorOnMainThread:@selector(addImageOnMainThread:) withObject:photoView waitUntilDone:NO];
            
            x += dx;
        }
    }
    
    photosScroll.contentSize = CGSizeMake(90 * [user.car.photos count], 64.0);
    
    // show info
    NSInteger status = [user.status integerValue];
    float r = 0.0;
    for (Rating* rating in user.ratings)
    {
        float rate = [rating.rate floatValue];
        r += rate;
    }
    
    if ([user.ratings count] > 0)
    {
        r = r / [user.ratings count];
    }
    
    NSString* name = user.name;
    NSString* license = user.license;
    NSString* numberOfService = user.numberOfService;
    NSString* tariffDayCity = user.tariff.tariffDayCity;
    NSString* tariffNightCity = user.tariff.tariffNightCity;
    NSString* tariffDayOutCity = user.tariff.tariffDayOutCity;
    NSString* tariffNightOutCity = user.tariff.tariffNightOutCity;
    NSString* tariffWeekend = user.tariff.tariffWeekend;
    NSString* tariffHoliday = user.tariff.tariffHoliday;
    NSString* tariffSeat = user.tariff.tariffSeat;
    NSString* tariffTime = user.tariff.tariffTime;
    NSString* tariffDowntime = user.tariff.tariffDowntime;
    NSString* desc = user.desc;
    
    NSString* info = [NSString stringWithFormat:NSLocalizedString(@"MESSAGE_21", @""), name, status == 0 ? NSLocalizedString(@"MESSAGE_22", @"") : NSLocalizedString(@"MESSAGE_23", @""), r, license, numberOfService, tariffDayCity, tariffNightCity, tariffDayOutCity, tariffNightOutCity, tariffWeekend, tariffHoliday, tariffSeat, tariffTime, tariffDowntime, desc];
    infoTextView.text = info;
    
    // show name
    if (user)
    {
        firstNameLabel.text = user.name;
        lastNameLabel.text = user.surName;
        surNameLabel.text = [NSString stringWithFormat:@"(%@)", user.nickName];
    }
    
    // show rating
    NSInteger intRate = (NSInteger)r;
    NSInteger floatRate = r * 10 - intRate * 10;
    
    if (intRate >= 1)
    {
        rate1Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 2)
    {
        rate2Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 3)
    {
        rate3Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 4)
    {
        rate4Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 5)
    {
        rate5Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    
    if (floatRate > 0)
    {
        UIImage* starImage = [UIImage imageNamed:@"StarFilled.png"];
        CGSize starSize = starImage.size;
        CGRect cropRect = CGRectMake(0.0, 0.0, starSize.width * 2 * floatRate * 10 / 100, starSize.height * 2);
        UIImage* cropImage = [Helper getCropImage:starImage frame:cropRect];
        
        switch (intRate)
        {
            case 1:
                [rate2Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                break;
            case 2:
                [rate3Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                break;
            case 3:
                [rate4Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                break;
            case 4:
                [rate5Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                break;
                
            default:
                break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // resize find car button image
    UIImage* makeOrderImage = [UIImage imageNamed:@"MainBtn@2x.png"];
    UIImage* resizeMakeOrderImage = [makeOrderImage stretchableImageWithLeftCapWidth:17.0 topCapHeight:20.0];
    [makeOrderButton setBackgroundImage:resizeMakeOrderImage forState:UIControlStateNormal];
    
    // resize driver info background image
    UIImage* infoImage = [UIImage imageNamed:@"InPopUpScroll@2x.png"];
    UIImage* resizeInfoImage = [infoImage stretchableImageWithLeftCapWidth:25.0 topCapHeight:0.0];
    infoBackground.image = resizeInfoImage;
    
    // resize scroll background
    UIImage* scrollImage = [UIImage imageNamed:@"InPopUpScrollSmall@2x.png"];
    UIImage* resizeScrollImage = [scrollImage stretchableImageWithLeftCapWidth:25.0 topCapHeight:0.0];
    scrollBackground.frame = CGRectMake(0.0, 0.0, 90 * 5, 64.0);
    scrollBackground.image = resizeScrollImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handlers

- (IBAction)closeButtonClicked:(id)sender
{
    [[KGModal sharedInstance] hideAnimated:YES];
}

- (IBAction)makeOrderButtonClicked:(id)sender
{
    FindCarViewController* findCarController = [[[FindCarViewController alloc] initWithNibName:@"FindCarViewController" bundle:nil] autorelease];
    findCarController.user = user;
    findCarController.delegate = delegate;
    
    [[KGModal sharedInstance] showWithContentViewController:findCarController andAnimated:YES];
}

- (IBAction)showRatingButtonClicked:(id)sender
{
    DriverRatigViewController* driverRatingController = [[[DriverRatigViewController alloc] initWithNibName:@"DriverRatigViewController" bundle:nil] autorelease];
    driverRatingController.user = user;
    driverRatingController.delegate = delegate;
    
    [[KGModal sharedInstance] showWithContentViewController:driverRatingController andAnimated:YES];
}

#pragma mark - Private Methods

- (void) addImageOnMainThread:(UIImageView*)thePhoto
{
    NSError* error = nil;
    [DELEGATE.managedObjectContext save:&error];
    
    [photosScroll addSubview:thePhoto];
}

@end
