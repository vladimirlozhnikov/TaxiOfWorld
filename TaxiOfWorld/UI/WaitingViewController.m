//
//  WaitingViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 05.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "WaitingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WaitingViewController ()

@end

@implementation WaitingViewController
@synthesize background, closeButton, titleLabel, waitingImage, delegate, object, timerLabel;

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

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
    [orderTimer invalidate];
    orderTimer = nil;
    
    [super dealloc];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self spinWithOptions:UIViewAnimationOptionCurveLinear];
    
    orderTimerCounter = 180;
    orderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(orderTimerFire:) userInfo:nil repeats:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) spinWithOptions: (UIViewAnimationOptions) options
{
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration:0.5f delay: 0.0f options:options animations:^{
                         waitingImage.transform = CGAffineTransformRotate(waitingImage.transform, -M_PI / 2);
                     }
                     completion: ^(BOOL finished){
                         if (finished)
                         {
                             [self spinWithOptions:UIViewAnimationOptionCurveLinear];
                         }
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handlers

- (IBAction)closeButtonClicked:(id)sender
{
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"MESSAGE_13", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"MESSAGE_28", @"") otherButtonTitles:NSLocalizedString(@"MESSAGE_25", @""), nil] autorelease];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [delegate performSelector:@selector(didCancelOrder:) withObject:self];
    }
}

#pragma mark - Timer Methods

- (void) orderTimerFire:(id)sender
{
    if (orderTimerCounter >= 0)
    {
        timerLabel.text = [NSString stringWithFormat:@"%d", orderTimerCounter];
    }
    else
    {
        [orderTimer invalidate];
        orderTimer = nil;
        
        [delegate performSelector:@selector(didWaitingTimeOut:) withObject:self];
    }
    
    orderTimerCounter -= 1;
}

@end
