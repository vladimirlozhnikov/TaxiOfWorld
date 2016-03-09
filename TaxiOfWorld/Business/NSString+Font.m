//
//  NSString+Font.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "NSString+Font.h"

@implementation NSString (Font)

-(UIFont*)getFontToFitInRect:(CGRect)rect seedFont:(UIFont*)seedFont
{
    UIFont* returnFont = seedFont;
    CGSize stringSize = [self sizeWithFont:returnFont];
    
    while(stringSize.width > rect.size.width)
    {
        returnFont = [UIFont systemFontOfSize:returnFont.pointSize - 1];
        stringSize = [self sizeWithFont:returnFont];
    }
    
    return returnFont;
}

@end
