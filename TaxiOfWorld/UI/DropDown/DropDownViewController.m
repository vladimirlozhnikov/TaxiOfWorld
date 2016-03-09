//
//  DropDownViewController.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 26.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "DropDownViewController.h"
#import "CityCell.h"
#import "BaseTableCell.h"

@interface DropDownViewController ()

@end

@implementation DropDownViewController
@synthesize background, dropDownButton, contentTable, delegate, content, arrow, titleLabel;

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
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.dropDownButton.frame.size.height);
    
    // find selected item
    for (id<DropDownItemProtocol> item in content)
    {
        if (item.selected)
        {
            titleLabel.text = item.displayName;
            break;
        }
    }
    
    originalFrame = self.view.frame;
    
    // resize background image
    UIImage* backgroundImage = [UIImage imageNamed:@"DropDownList.png"];
    UIImage* resizeBackgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:40.0 topCapHeight:20.0];
    background.image = resizeBackgroundImage;
    
    background.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityCell* cell = (CityCell*)[tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    if (cell == nil)
    {
        cell = [BaseTableCell cellFromNibNamed:@"CityCell" owner:self];
    }
    
    id <DropDownItemProtocol> item = [content objectAtIndex:[indexPath row]];
    cell.titleLabel.text = item.displayName;
    cell.choosed = item.selected;
    
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    contentTable.hidden = YES;
    background.hidden = YES;
    dropDownButton.hidden = NO;
    contentTable.userInteractionEnabled = YES;
    
    self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.dropDownButton.frame.size.height);
    id <DropDownItemProtocol> item = [content objectAtIndex:[indexPath row]];
    item.selected = YES;
    
    for (id <DropDownItemProtocol> i in content)
    {
        if (i != item)
        {
            i.selected = NO;
        }
    }
    
    if ([delegate respondsToSelector:@selector(didSelect:)])
    {
        [delegate performSelector:@selector(didSelect:) withObject:self];
    }
    
    titleLabel.hidden = NO;
    titleLabel.text = item.displayName;
    [contentTable reloadData];
}

#pragma mark - Event Handlers

- (IBAction) dropDownButtonClicked:(id)sender
{
    if ([content count] > 0)
    {
        contentTable.hidden = NO;
        contentTable.userInteractionEnabled = YES;
        
        self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 150.0);
        
        if ([delegate respondsToSelector:@selector(didExpand:)])
        {
            [delegate performSelector:@selector(didExpand:) withObject:self];
        }
        
        titleLabel.hidden = YES;
        //arrow.image = [UIImage imageNamed:@"DropDownArrowUp@2x.png"];
        arrow.image = nil;
        contentTable.frame = self.view.frame;
        [contentTable reloadData];
        
        background.hidden = NO;
        dropDownButton.hidden = YES;
    }
}

#pragma mark - Public Methods

- (id<DropDownItemProtocol>) selectedItem
{
    for (id <DropDownItemProtocol> item in content)
    {
        if (item.selected)
        {
            return item;
        }
    }
    
    return nil;
}

- (void) collaps
{
    contentTable.hidden = YES;
    background.hidden = YES;
    dropDownButton.hidden = NO;
    contentTable.userInteractionEnabled = YES;
    
    self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.dropDownButton.frame.size.height);
    
    if ([delegate respondsToSelector:@selector(didCollaps:)])
    {
        [delegate performSelector:@selector(didCollaps:) withObject:self];
    }
    
    titleLabel.hidden = NO;
    arrow.image = [UIImage imageNamed:@"DropDownArrowDown@2x.png"];
    contentTable.frame = self.view.frame;
    [contentTable reloadData];
}

@end
