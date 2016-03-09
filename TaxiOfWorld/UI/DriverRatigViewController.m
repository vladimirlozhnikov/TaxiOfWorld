//
//  DriverRatigViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 01.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "DriverRatigViewController.h"
#import "KGModal.h"
#import "BaseTableCell.h"
#import "RatingCell.h"
#import "DriverInfoViewController.h"
#import "PPDbManager.h"
#import "Rating+Category.h"
#import "Helper.h"

@interface DriverRatigViewController ()

@end

@implementation DriverRatigViewController
@synthesize background, photo, closeButton, firstNameLabel, lastNameLabel, surNameLabel, rate1Image, rate2Image, rate3Image, rate4Image, rate5Image, tableBackground, table, user;
@synthesize delegate;

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
    [users release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // resize table background image
    UIImage* tableImage = [UIImage imageNamed:@"InPopUpScroll@2x.png"];
    UIImage* resizeTableImage = [tableImage stretchableImageWithLeftCapWidth:25.0 topCapHeight:0.0];
    tableBackground.image = resizeTableImage;
    
    // show name
    if (user)
    {
        firstNameLabel.text = user.name;
        lastNameLabel.text = user.surName;
        surNameLabel.text = [NSString stringWithFormat:@"(%@)", user.nickName];
    }
    
    users = [[PPDbManager loadAllItemsForName:@"User" withCriteria:nil] retain];
    
    // show rating
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handlers

- (IBAction)closeButtonClicked:(id)sender
{
    DriverInfoViewController* driverInfoController = [[[DriverInfoViewController alloc] initWithNibName:@"DriverInfoViewController" bundle:nil] autorelease];
    driverInfoController.user = user;
    driverInfoController.delegate = delegate;
    
    [[KGModal sharedInstance] showWithContentViewController:driverInfoController andAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [user.ratings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatingCell* cell = (RatingCell*)[tableView dequeueReusableCellWithIdentifier:@"RatingCell"];
    if (cell == nil)
    {
        cell = [BaseTableCell cellFromNibNamed:@"RatingCell" owner:self];
    }
    
    Rating* rating = [[user.ratings allObjects] objectAtIndex:[indexPath row]];
    for (User* from in users)
    {
        if ([[from.index lowercaseString] isEqualToString:[rating.userId lowercaseString]])
        {
            NSMutableString* phone = [NSMutableString stringWithString:from.phone];
            if ([phone length] > 3)
            {
                NSRange r = NSMakeRange(phone.length - 3, 3);
                [phone deleteCharactersInRange:r];
                [phone appendString:@"***"];
            }
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", phone];
            cell.messageLabel.text = rating.message;
            
            // show rating
            float r = [rating.rate integerValue];
            
            NSInteger intRate = (NSInteger)r;
            NSInteger floatRate = r * 10 - intRate * 10;
            
            if (intRate >= 1)
            {
                cell.rate1Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
            }
            if (intRate >= 2)
            {
                cell.rate2Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
            }
            if (intRate >= 3)
            {
                cell.rate3Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
            }
            if (intRate >= 4)
            {
                cell.rate4Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
            }
            if (intRate >= 5)
            {
                cell.rate5Image.image = [UIImage imageNamed:@"StarFilled@2x.png"];
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
                        [cell.rate2Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                        break;
                    case 2:
                        [cell.rate3Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                        break;
                    case 3:
                        [cell.rate4Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                        break;
                    case 4:
                        [cell.rate5Image addSubview:[[[UIImageView alloc] initWithImage:cropImage] autorelease]];
                        break;
                        
                    default:
                        break;
                }
            }
            
            break;
        }
    }
    
	return cell;
}

@end
