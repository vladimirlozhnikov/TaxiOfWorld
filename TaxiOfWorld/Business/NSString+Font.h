//
//  NSString+Font.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 29.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Font)

-(UIFont*)getFontToFitInRect:(CGRect)rect seedFont:(UIFont*)seedFont;

@end
