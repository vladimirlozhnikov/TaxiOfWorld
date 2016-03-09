//
//  BSKeyboardControls.m
//  Example
//
//  Created by Simon B. Støvring on 11/01/13.
//  Copyright (c) 2013 simonbs. All rights reserved.
//

#import "BSKeyboardControls.h"
#import "iOSCombobox.h"

@interface BSKeyboardControls ()
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@end

@implementation BSKeyboardControls

#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    return [self initWithFields:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFields:nil];
}

- (id)initWithFields:(NSArray *)fields
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)])
    {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:self.frame]];
        [self.toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [self.toolbar setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth)];
        [self addSubview:self.toolbar];
        
        [self setCancelButton:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"MESSAGE_4", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)]];
        
        [self setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"Войти" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)]];
        
        [self.toolbar setItems:[self toolbarItems]];
        [self setFields:fields];
    }
    
    return self;
}

- (void)dealloc
{
    [self setFields:nil];
    [self setSegmentedControlTintControl:nil];
    [self setBarTintColor:nil];
    [self setCancelTitle:nil];
    [self setDoneTitle:nil];
    [self setDoneTintColor:nil];
    [self setActiveField:nil];
    [self setToolbar:nil];
    [self setDoneButton:nil];
}

#pragma mark -
#pragma mark Public Methods

- (BOOL) hideCancel
{
    return _hideCancel;
}

- (void) setHideCancel:(BOOL)hideCancel
{
    _hideCancel = hideCancel;
    [self.toolbar setItems:[self toolbarItems]];
}

- (void)setActiveField:(id)activeField
{
    if (activeField != _activeField)
    {
        if ([self.fields containsObject:activeField])
        {
            _activeField = activeField;
        
            if (![activeField isFirstResponder])
            {
                [activeField becomeFirstResponder];
            }
        }
    }
}

- (void)setFields:(NSArray *)fields
{
    if (fields != _fields)
    {
        for (UIView *field in fields)
        {
            if ([field isKindOfClass:[UITextField class]])
            {
                [(UITextField *)field setInputAccessoryView:self];
            }
            else if ([field isKindOfClass:[UITextView class]])
            {
                [(UITextView *)field setInputAccessoryView:self];
            }
            else if ([field isKindOfClass:[iOSCombobox class]])
            {
                [(iOSCombobox *)field setInputAccessoryView:self];
            }
        }
        
        _fields = fields;
    }
}

- (void)setBarStyle:(UIBarStyle)barStyle
{
    if (barStyle != _barStyle)
    {
        [self.toolbar setBarStyle:barStyle];
        
        _barStyle = barStyle;
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    if (barTintColor != _barTintColor)
    {
        [self.toolbar setTintColor:barTintColor];
        
        _barTintColor = barTintColor;
    }
}

- (void)setDoneTitle:(NSString *)doneTitle
{
    if (![doneTitle isEqualToString:_doneTitle])
    {
        [self.doneButton setTitle:doneTitle];
        
        _doneTitle = doneTitle;
    }
}

- (void)setDoneTintColor:(UIColor *)doneTintColor
{
    if (doneTintColor != _doneTintColor)
    {
        [self.doneButton setTintColor:doneTintColor];
        
        _doneTintColor = doneTintColor;
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)cancelButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsCancelPressed:)])
    {
        [self.delegate keyboardControlsCancelPressed:self];
    }
}

- (void)doneButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsDonePressed:)])
    {
        [self.delegate keyboardControlsDonePressed:self];
    }
}

- (NSArray *)toolbarItems
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:2];
    
    //if (self.visibleControls)
    {
        [items addObject:self.doneButton];
        if (!_hideCancel)
        {
            [items addObject:self.cancelButton];
        }
    }
    
    return items;
}

@end
