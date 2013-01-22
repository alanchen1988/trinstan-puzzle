////  UIImage+Category.h//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import <Foundation/Foundation.h>@interface UIImage (UIImageCategory)//for Puzzle+(UIImage*)imageByCombining:(UIImage*)one another:(UIImage*)another atOffset:(CGPoint)point;+(UIImage*)imageByCroppingImage:(UIImage*)image inRect:(CGRect)rect;-(NSMutableArray*)getRectangularPuzzlePiecesWithRows:(NSUInteger)row andColumns:(NSUInteger)col;-(UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)itemSize;//for Normal Puzzle//resize the image's size- (UIImage*)resizedImageWithSize:(CGSize)size;- (UIImage*)cropImageFromFrame:(CGRect)frame;- (UIImage*)maskImage:(UIImage *)image withMaskImage:(UIImage*)maskImag;@end