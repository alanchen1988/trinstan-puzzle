////  UIImage+Category.m//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import "UIImage+Category.h"@implementation UIImage (UIImageCategory)//written with help from http://stackoverflow.com/questions/679245/create-a-uiimage-from-two-other-uiimages-on-the-iphone+(UIImage*)imageByCombining:(UIImage*)one another:(UIImage*)two atOffset:(CGPoint)offset{    CGSize size = CGSizeMake(MAX(one.size.width,  two.size.width) + ABS(offset.x),                             MAX(one.size.height, two.size.height)+ ABS(offset.y));	    CGPoint onePoint, twoPoint;    if (offset.x < 0.0)        if (offset.y < 0.0){            onePoint = offset;            twoPoint = CGPointZero;        }        else{            onePoint = CGPointMake(0,offset.y);            twoPoint = CGPointMake(offset.x,0);        }		else			if (offset.y < 0.0){				onePoint = CGPointMake(offset.x,0);				twoPoint = CGPointMake(0,offset.y);			}			else{				onePoint = CGPointZero;				twoPoint = offset;			}            UIGraphicsBeginImageContext(size);    [one drawAtPoint:onePoint];    [two drawAtPoint:twoPoint];        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();  //returns autoreleased    UIGraphicsEndImageContext();        return result;}+(UIImage*)imageByCroppingImage:(UIImage*)image inRect:(CGRect)rect{    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);    UIImage *result             = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];    CGImageRelease(imageRef);        return result;}#define WIDTH 80#define HEIGHT  60-(NSMutableArray*)getRectangularPuzzlePiecesWithRows:(NSUInteger)rows andColumns:(NSUInteger)cols{    const CGFloat width = self.size.width  / ((CGFloat)cols);    const CGFloat height = self.size.height / ((CGFloat)rows);    NSMutableArray *array = [NSMutableArray arrayWithCapacity:rows];        int x = 1;    for(CGFloat i=0; i < self.size.width - 0.01; i += width)    {        int y = 1;        NSMutableArray *someRow = [NSMutableArray arrayWithCapacity:cols];        for(CGFloat j=0; j < self.size.height - 0.01; j += height)              {                        CGRect rect2x = CGRectMake(i, j, width+WIDTH, height+HEIGHT);            if (i == 0 && j != 0)                rect2x = CGRectMake(i, j - HEIGHT/3, width+WIDTH, height+HEIGHT);            else if (i != 0 && j == 0) {                rect2x = CGRectMake(i - WIDTH/3, j, width+WIDTH, height+HEIGHT);            }else if (i != 0 && j != 0){                rect2x = CGRectMake(i - WIDTH/3, j - HEIGHT/3, width+WIDTH, height+HEIGHT);            }                        //UIImage *orgImg = [UIImage imageNamed:@"main.png"];            UIImage *frmImg = [UIImage imageNamed:[NSString stringWithFormat:@"%d.%d.png",y,x]];            frmImg = [self scaleImage:frmImg ToSize:CGSizeMake(width, height)];            UIImage *cropImg = [self cropImage:self withRect:rect2x];            //frmImg = [self cropImage:frmImg withRect:rect2x];            UIImage *cropped = [self maskImage:cropImg withMaskImage:frmImg];                        //UIImage *cropped = [UIImage imageByCroppingImage:self inRect:CGRectMake(i, j, width, height)];            [someRow addObject:cropped];            y++;        }        [array addObject:someRow];        x++;    }        return array;}- (UIImage *) cropImage:(UIImage*)originalImage withRect:(CGRect)rect {    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect([originalImage CGImage], rect)];}//set the image to limited size-(UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)itemSize{    UIImage *i;    UIGraphicsBeginImageContext(itemSize);    CGRect imageRect=CGRectMake(0, 0, itemSize.width, itemSize.height);    [img drawInRect:imageRect];    i=UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();    return i;}-(UIImage*)subimageWithRect:(CGRect)rect{    	UIGraphicsBeginImageContextWithOptions(rect.size, YES, self.scale);    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();    CGContextRelease(UIGraphicsGetCurrentContext());        return image;    }#pragma mark Mask the image- (UIImage*) maskImage:(UIImage *)image withMaskImage:(UIImage*)maskImage {        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();    CGImageRef maskImageRef = [maskImage CGImage];        CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);        if (mainViewContentContext==NULL)        return NULL;        CGFloat ratio = 0;    ratio = maskImage.size.width/ image.size.width;    if(ratio * image.size.height < maskImage.size.height) {        ratio = maskImage.size.height/ image.size.height;    }        CGRect rect1 = {{0, 0}, {maskImage.size.width, maskImage.size.height}};    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2,-((image.size.height*ratio)-maskImage.size.height)/2},{image.size.width*ratio, image.size.height*ratio}};        CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);        CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);    CGContextRelease(mainViewContentContext);        UIImage *theImage = [UIImage imageWithCGImage:newImage];    CGImageRelease(newImage);    return theImage;}//for Normal Puzzle- (UIImage*)resizedImageWithSize:(CGSize)size {    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);    CGImageRef sourceImage = CGImageCreateCopy(self.CGImage);    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:0.0 orientation:self.imageOrientation];    [newImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];    CGImageRelease(sourceImage);    newImage = UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();        return newImage;}- (UIImage*)cropImageFromFrame:(CGRect)frame {    CGRect destFrame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);        CGFloat scale = 1.0;#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){        scale = [[UIScreen mainScreen] scale];    }#endif        CGRect sourceFrame = CGRectMake(frame.origin.x*scale, frame.origin.y*scale, frame.size.width*scale, frame.size.height*scale);        UIGraphicsBeginImageContextWithOptions(destFrame.size, NO, 0.0);    CGImageRef sourceImage = CGImageCreateWithImageInRect(self.CGImage, sourceFrame);    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:0.0 orientation:self.imageOrientation];    [newImage drawInRect:destFrame];    CGImageRelease(sourceImage);    newImage = UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();        return newImage;}@end