//
//  Piece.m
//  Puzzle
//
//  Created by Trinstan on 12/13/12.
//
//

#import "Piece.h"

@implementation Piece
@synthesize reference, selected, gridLocations;
@synthesize pieceArray;
//@synthesize worldPosition;


-(id)init{
    if (self = [super init]){
        selected = NO;
        gridLocations = [[NSMutableArray alloc] init];
        pieceArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)dealloc{
    [gridLocations release];
    gridLocations = nil;
    [pieceArray release];
    pieceArray = nil;
    [super dealloc];
}
@end
