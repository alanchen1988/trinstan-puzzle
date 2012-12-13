//
//  Piece.h
//  Puzzle
//
//  Created by Trinstan on 12/13/12.
//
//

#import <Foundation/Foundation.h>

@interface Piece : NSObject
@property (nonatomic, assign) id reference;
@property (nonatomic, retain) NSMutableArray *gridLocations;
//@property (nonatomic) CGPoint worldPosition;
@property (nonatomic) BOOL selected;
@property (nonatomic, retain) NSMutableArray *pieceArray;

@end
