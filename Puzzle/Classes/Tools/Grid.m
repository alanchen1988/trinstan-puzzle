//
//  Grid.m
//  Puzzle
//
//  Created by Trinstan on 12/12/12.
//
//

#import "Grid.h"

@implementation Grid
@synthesize x, y;
+(Grid*)gridWith:(NSInteger)x and:(NSInteger)y
{
    Grid *grid = [[Grid alloc] init];
    grid.x = x; grid.y = y;
    return [grid autorelease];
}
@end
