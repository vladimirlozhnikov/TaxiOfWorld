//
//  Helper.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 19.08.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (void)processImageDataWithURLString:(NSURL *)url andBlock:(void (^)(NSData *imageData))processImage
{
    dispatch_queue_t callerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(callerQueue, ^{
        //NSLog(@"%@", url);
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        processImage(imageData);
    });
}

+ (UIImage*)getCropImage:(UIImage*)theImage frame:(CGRect)frame
{
    CGImageRef image = CGImageCreateWithImageInRect([theImage CGImage], frame);
    UIImage* cropedImage = [UIImage imageWithCGImage:image scale:2.0 orientation:UIImageOrientationUp];
    CGImageRelease(image);
    return cropedImage;
}

@end
