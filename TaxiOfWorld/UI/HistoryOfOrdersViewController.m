//
//  HistoryOfOrdersViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "HistoryOfOrdersViewController.h"
#import "KGModal.h"
#import "BaseTableCell.h"
#import "HistoryCell.h"
#import "Car+Category.h"
#import "Attachment+Category.h"
#import "Helper.h"
#import "PPDbManager.h"
#import "Rating+Category.h"

@interface HistoryOfOrdersViewController ()

@end

@implementation HistoryOfOrdersViewController
@synthesize background, tableBackground, titleLabel, table, closeButton;

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
    [content release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // resize table background image
    UIImage* tableBackgroundImage = [UIImage imageNamed:@"InPopUpScroll.png"];
    UIImage* resizeTableBackgroundImage = [tableBackgroundImage stretchableImageWithLeftCapWidth:17.0 topCapHeight:20.0];
    tableBackground.image = resizeTableBackgroundImage;
    
    content = [[NSMutableArray alloc] init];
    
    // get orders
    NSArray* messages = [PPDbManager loadAllItemsForName:@"Message" withCriteria:nil];
    for (Message* m in messages)
    {
        [content addObject:m];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handlers

- (IBAction) closeButtonClicked:(id)sender
{
    [[KGModal sharedInstance] hideAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell* cell = (HistoryCell*)[tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    if (cell == nil)
    {
        cell = [BaseTableCell cellFromNibNamed:@"HistoryCell" owner:self];
    }
    
    Message* message = [content objectAtIndex:[indexPath row]];
    cell.delegate = self;
    cell.driver = message.from;
    
    //cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", message.from.surName, message.from.name];
    cell.nameLabel.text = message.from.name;
    
    NSString* beginPoint = message.beginPoint;
    NSString* endPoint = message.endPoint;
    
    NSRegularExpression* regexDisplayAddressFrom = [NSRegularExpression regularExpressionWithPattern:@"displayAddress:(.*?)]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression* regexDisplayAddressTo = [NSRegularExpression regularExpressionWithPattern:@"displayAddress:(.*?)]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult* textCheckingResultFrom = nil;
    NSTextCheckingResult* textCheckingResultTo = nil;
    if (beginPoint)
    {
        textCheckingResultFrom = [regexDisplayAddressFrom firstMatchInString:beginPoint options:0 range:NSMakeRange(0, beginPoint.length)];
    }
    if (endPoint)
    {
        textCheckingResultTo = [regexDisplayAddressTo firstMatchInString:endPoint options:0 range:NSMakeRange(0, endPoint.length)];
    }
    
    if (textCheckingResultFrom)
    {
        NSRange matchRange = [textCheckingResultFrom rangeAtIndex:1];
        NSString* match = [beginPoint substringWithRange:matchRange];
        
        cell.fromLabel.text = match;
    }
    if (textCheckingResultTo)
    {
        NSRange matchRange = [textCheckingResultTo rangeAtIndex:1];
        NSString* match = [endPoint substringWithRange:matchRange];
        
        cell.toLabel.text = match;
    }
    
    if ([message.from.car.photos count] > 0)
    {
        Attachment* photo = [[message.from.car.photos allObjects] objectAtIndex:0];
        //NSLog(@"%@", photo);
        if (photo.data)
        {
            UIImage* image = [UIImage imageWithData:photo.data];
            cell.photo.image = image;
        }
    }
    
    // calculate rating
    float r = 0.0;
    for (Rating* rating in message.from.ratings)
    {
        float rate = [rating.rate floatValue];
        r += rate;
    }
    
    if ([message.from.ratings count] > 0)
    {
        r = r / [message.from.ratings count];
    }
    
    // show rating
    NSInteger intRate = (NSInteger)r;
    NSInteger floatRate = r * 10 - intRate * 10;
    
    if (intRate >= 1)
    {
        cell.rate1.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 2)
    {
        cell.rate2.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 3)
    {
        cell.rate3.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 4)
    {
        cell.rate4.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    if (intRate >= 5)
    {
        cell.rate5.image = [UIImage imageNamed:@"StarFilled@2x.png"];
    }
    
    if (floatRate > 0)
    {
        UIImage* starImage = [UIImage imageNamed:@"StarFilled.png"];
        CGSize starSize = starImage.size;
        CGRect cropRect = CGRectMake(0.0, 0.0, starSize.width * 2 * floatRate * 10 / 100, starSize.height * 2);
        
        UIImage* cropImage = [Helper getCropImage:starImage frame:cropRect];
        starSize = cropImage.size;
        UIImageView* cropImageView = [[[UIImageView alloc] initWithImage:cropImage] autorelease];
        
        switch (intRate)
        {
            case 1:
                [cell.rate2 addSubview:cropImageView];
                break;
            case 2:
                [cell.rate3 addSubview:cropImageView];
                break;
            case 3:
                [cell.rate4 addSubview:cropImageView];
                break;
            case 4:
                [cell.rate5 addSubview:cropImageView];
                break;
                
            default:
                break;
        }
    }
    
	return cell;
}

#pragma mark - RateProtocol Methods

- (void) didChooseRate:(NSNumber*)rate driver:(User*)theDriver
{
    userRate = [rate integerValue];
    driver = theDriver;
    NSString* title = [NSString stringWithFormat:NSLocalizedString(@"MESSAGE_24", @""), rate];
    
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"MESSAGE_4", @"") otherButtonTitles:@"OK", nil] autorelease];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField* text = [alertView textFieldAtIndex:0];
        
        [DELEGATE showActivity];
        
        Rating* rating = [[Rating alloc] initWithEntity:[NSEntityDescription entityForName:@"Rating" inManagedObjectContext:DELEGATE.managedObjectContext] insertIntoManagedObjectContext:DELEGATE.managedObjectContext];
        rating.message = text.text;
        rating.rate = [NSString stringWithFormat:@"%d", userRate];
        rating.userId = DELEGATE.me.index;
        
        NetworkManager* networkManager = DELEGATE.networkManager;
        [networkManager pushRate:driver rate:rating success:^{
            [DELEGATE hideActivity];
        } onError:^(NSString *error) {
            [DELEGATE hideActivity];
        }];
    }
}

@end
