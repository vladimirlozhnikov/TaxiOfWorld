//
//  Helper.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 19.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (void)processImageDataWithURLString:(NSURL *)url andBlock:(void (^)(NSData *imageData))processImage;
+ (UIImage*)getCropImage:(UIImage*)image frame:(CGRect)frame;

@end
