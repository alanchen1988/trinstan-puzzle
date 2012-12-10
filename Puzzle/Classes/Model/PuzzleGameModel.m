////  PuzzleGameModel.m//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import "PuzzleGameModel.h"#pragma mark - Grid Class@interface Grid : NSObject@property (nonatomic) NSInteger x, y;+(Grid*)gridWith:(NSInteger)x and:(NSInteger)y;@end@implementation Grid@synthesize x, y;+(Grid*)gridWith:(NSInteger)x and:(NSInteger)y{    Grid *grid = [[Grid alloc] init];    grid.x = x; grid.y = y;    return [grid autorelease];}@end#pragma mark - Piece Class@interface Piece : NSObject@property (nonatomic, assign) id reference;@property (nonatomic, retain) NSMutableArray *gridLocations;//@property (nonatomic) CGPoint worldPosition;@property (nonatomic) BOOL selected;@end@implementation Piece@synthesize reference, selected, gridLocations;//@synthesize worldPosition;-(id)init{    if (self = [super init]){        selected = NO;        gridLocations = [[NSMutableArray alloc] init];    }    return self;}-(void)dealloc{    [super dealloc];    [gridLocations release];    gridLocations = nil;}@end#pragma mark - MJGameModel Class@interface PuzzleGameModel()@property (nonatomic, readonly) NSMutableArray *gamePieces;-(Piece*)pieceWithReference:(id)reference;-(NSArray*)selectedPieces;-(void)testSelectedPieces;@end@implementation PuzzleGameModel@synthesize pieceSize;@synthesize delegate;@synthesize gamePieces = _gamePieces;-(id)gamePieces{    if (_gamePieces == nil)        _gamePieces = [[NSMutableArray alloc] initWithCapacity:20];    return _gamePieces;}-(Piece*)pieceWithReference:(id)reference{    for(Piece *piece in self.gamePieces)        if (reference == piece.reference)            return piece;    return nil;}-(NSArray*)selectedPieces{    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];    for(Piece *piece in self.gamePieces)         if (piece.selected)             [array addObject:piece];    return array;}-(void)setGamePiece:(id)obj atGridPosition:(CGPoint)point{    Piece *piece = [self pieceWithReference:obj];        if (nil == piece) piece = [[[Piece alloc] init] autorelease];        piece.reference = obj;        [self.gamePieces addObject:piece];        [piece.gridLocations addObject:[Grid gridWith:point.x                                              and:point.y]];}-(void)setGamePiece:(id)obj atWorldPosition:(CGPoint)worldPosition{    Piece *piece = [self pieceWithReference:obj];	    if (nil == piece)        NSLog(@"Gotta do something about pieces not being in the model.");        [self testSelectedPieces];}-(void)updateWithView:(id)view andSelected:(BOOL)selected{    Piece *piece = [self pieceWithReference:view];    if (nil == piece) NSLog(@"Gotta do something about pieces not being in the model.");        piece.selected = selected;        [self testSelectedPieces];}-(void)combinePieces:(id)one andOther:(id)two intoNew:(id)newView{    Piece *onePiece = [self pieceWithReference:one];    Piece *twoPiece = [self pieceWithReference:two];    Piece *piece = [[Piece alloc] init];    piece.reference = newView;        for (Grid *one in onePiece.gridLocations)        [piece.gridLocations addObject:one];        for (Grid *two in twoPiece.gridLocations)        [piece.gridLocations addObject:two];		    [self.gamePieces removeObject:onePiece];    [self.gamePieces removeObject:twoPiece];    [self.gamePieces addObject:piece];        if (self.gamePieces.count == 1)        [self.delegate userDidSolvePuzzle];}-(void)testSelectedPieces{    NSArray *selectedPieces = [self selectedPieces];        if (selectedPieces.count < 2) return;        Piece *one = [selectedPieces objectAtIndex:0];    Piece *two = [selectedPieces objectAtIndex:1];            for(Grid *oneGrid in one.gridLocations)		for(Grid *twoGrid in two.gridLocations)			if (ABS(oneGrid.x - twoGrid.x) == 0 || ABS(oneGrid.y - twoGrid.y) == 0)				[self.delegate combinePiece:one.reference 								  withOther:two.reference];}-(void)dealloc{    [super dealloc];    [_gamePieces release];}@end