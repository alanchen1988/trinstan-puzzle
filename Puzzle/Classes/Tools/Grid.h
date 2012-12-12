//
//  Grid.h
//  Puzzle
//
//  Created by Trinstan on 12/12/12.
//
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject
@property (nonatomic) NSInteger x, y;
+(Grid*)gridWith:(NSInteger)x and:(NSInteger)y;
@end
