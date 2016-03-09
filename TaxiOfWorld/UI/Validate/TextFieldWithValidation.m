//
//  TextFieldWithValidation.m
//  HushPuppies
//
//  Created by vladimir.lozhnikov on 09.08.13.
//  Copyright (c) 2013 intellectsoft. All rights reserved.
//

#import "TextFieldWithValidation.h"

@implementation TextFieldWithValidation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Public Methods

- (BOOL) validate
{
    if ([self.text length] == 0)
    {
        UIColor* currentColor = self.backgroundColor;
        CGFloat alpha = self.alpha;
        
        [UIView animateWithDuration:0.6 delay:0.0 options: 0 animations:^(void)
         {
             self.backgroundColor = [UIColor redColor];
             self.alpha = 0.1;
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.6 delay:0.6 options:0 animations:^(void)
              {
              } completion:^(BOOL finished)
              {
                  self.backgroundColor = currentColor;
                  self.alpha = alpha;
              }];
         }];
        
        return NO;
    }
    
    return YES;
}

@end
