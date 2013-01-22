    ////  PuzzleGameImageView.m//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import "PuzzleGameImageView.h"#import "UIImage+Category.h"#import "Grid.h"@interface PuzzleGameImageView()@property (nonatomic) float padding;@end@implementation PuzzleGameImageView@synthesize previousRotation;@synthesize selected;@synthesize grid_x, grid_y;@synthesize isUp, isDown, isLeft, isRight;@synthesize isCombined;//@synthesize locations = _locations;@synthesize padding;//@synthesize edges = _edges;//@synthesize image;#pragma mark - Initialization-(id)init{    return nil;}-(id)initWithFrame:(CGRect)frame{    if (self = [super initWithFrame:frame])    {        self.userInteractionEnabled = YES;        self.multipleTouchEnabled   = YES;        //self.transform = CGAffineTransformMakeRotation(arc4random());        [self adjustToNearestDesiredAngle];        previousRotation = self.transform;        self.selected = NO;//        _locations = [[NSMutableArray alloc] initWithCapacity:20];//        _edges = [[NSArray alloc] init];    }    return self;}- (void)dealloc{    [super dealloc];}#define WIDTH 160#define HEIGHT  150#define TempTap 60- (CGRect)rectForView:(PuzzleGameImageView *)one{    CGRect rect2x = CGRectZero;    int row = one.grid_y+1;    int colunm = one.grid_x+1;        if (row == 1 && colunm == 1) rect2x = CGRectMake(0, 0, WIDTH + TempTap, HEIGHT);    else if (row == 1 && colunm == 2) rect2x = CGRectMake(WIDTH, 0, WIDTH, HEIGHT + TempTap);    else if (row == 1 && colunm == 3) rect2x = CGRectMake(WIDTH * 2 - TempTap, 0, WIDTH + TempTap * 2, HEIGHT);    else if (row == 1 && colunm == 4) rect2x = CGRectMake(WIDTH * 3, 0, WIDTH, HEIGHT + TempTap);    else if (row == 2 && colunm == 1) rect2x = CGRectMake(0, HEIGHT - TempTap, WIDTH, HEIGHT + TempTap * 2);    else if (row == 2 && colunm == 2) rect2x = CGRectMake(WIDTH - TempTap, HEIGHT, WIDTH + TempTap * 2, HEIGHT);    else if (row == 2 && colunm == 3) rect2x = CGRectMake(WIDTH * 2, HEIGHT - TempTap, WIDTH, HEIGHT + TempTap * 2);    else if (row == 2 && colunm == 4) rect2x = CGRectMake(WIDTH * 3 - TempTap, HEIGHT, WIDTH + TempTap, HEIGHT);    else if (row == 3 && colunm == 1) rect2x = CGRectMake(0, HEIGHT * 2, WIDTH + TempTap, HEIGHT);    else if (row == 3 && colunm == 2) rect2x = CGRectMake(WIDTH, HEIGHT * 2 - TempTap, WIDTH, HEIGHT + TempTap *2);    else if (row == 3 && colunm == 3) rect2x = CGRectMake(WIDTH * 2 - TempTap, HEIGHT * 2, WIDTH + TempTap * 2, HEIGHT);    else if (row == 3 && colunm == 4) rect2x = CGRectMake(WIDTH * 3, HEIGHT * 2 - TempTap, WIDTH, HEIGHT + TempTap * 2);    else if (row == 4 && colunm == 1) rect2x = CGRectMake(0, HEIGHT * 3 - TempTap, WIDTH, HEIGHT + TempTap);    else if (row == 4 && colunm == 2) rect2x = CGRectMake(WIDTH - TempTap, HEIGHT * 3, WIDTH + TempTap * 2, HEIGHT);    else if (row == 4 && colunm == 3) rect2x = CGRectMake(WIDTH * 2, HEIGHT * 3 - TempTap, WIDTH, HEIGHT + TempTap);    else if (row == 4 && colunm == 4) rect2x = CGRectMake(WIDTH * 3 - TempTap, HEIGHT * 3, WIDTH + TempTap, HEIGHT);        return rect2x;}#define TEMP_NEW    50-(id)initByCombining:(id)oneView andOther:(id)twoView withRegularSize:(CGSize)pieceSize;{    PuzzleGameImageView *one = oneView;//[oneView copy]; //should probably copy here!    PuzzleGameImageView *two = twoView;//[twoView copy];            CGAffineTransform incomingTransform = one.transform;    one.transform = CGAffineTransformIdentity;    two.transform = CGAffineTransformIdentity;            CGRect oneframe = CGRectMake([self rectForView:one].origin.x, [self rectForView:one].origin.y, one.frame.size.width, one.frame.size.height);    CGRect twoframe = CGRectMake([self rectForView:two].origin.x, [self rectForView:two].origin.y, two.frame.size.width, two.frame.size.height);        CGPoint onepoint, twopoint;    //for x    if (oneframe.origin.x < twoframe.origin.x)    {        onepoint.x = 0;        //for same rows and different columns        if (one.isRight == YES && two.isLeft == NO) twopoint.x = twoframe.origin.x - oneframe.origin.x - TEMP_NEW;        if (one.isRight == NO && two.isLeft == YES) twopoint.x = twoframe.origin.x - oneframe.origin.x - 10;                //for same columns and different rows        if (one.isDown == NO && two.isUp == YES)        {            twopoint.x = TEMP_NEW;        }    }    else if (oneframe.origin.x > twoframe.origin.x)    {        twopoint.x = 0;        //for same rows and different columns        if (one.isLeft == YES && two.isRight == NO) onepoint.x = oneframe.origin.x - twoframe.origin.x - TEMP_NEW;        if (one.isLeft == NO && two.isRight == YES) onepoint.x = oneframe.origin.x - twoframe.origin.x - 10;                //for same columns and different rows        if (one.isUp == YES && two.isDown == NO)        {            onepoint.x = TEMP_NEW;        }            }    else    {        onepoint.x = 0;        twopoint.x = 0;    }        //for Y    if (oneframe.origin.y < twoframe.origin.y)    {        onepoint.y = 0;        //for same rows and different columns        if (one.isUp == YES && two.isUp == NO)        {            twopoint.y = TEMP_NEW;        }                //for different rows and same columns        if (one.isDown == NO && two.isUp == YES) twopoint.y = twoframe.origin.y - oneframe.origin.y;        if (one.isDown == YES && two.isUp == NO) twopoint.y = twoframe.origin.y - oneframe.origin.y - 20;    }    else if (oneframe.origin.y > twoframe.origin.y)    {                twopoint.y = 0;        //for same rows and different columns        if (one.isUp == NO && two.isUp == YES)        {            twopoint.y = TEMP_NEW;        }                //for different rows and same columns        if (one.isUp == YES && two.isDown == NO) onepoint.y = oneframe.origin.y - twoframe.origin.y;        if (one.isUp == NO && two.isDown == YES) onepoint.y = oneframe.origin.y - twoframe.origin.y - 20;            }    else    {        onepoint.y = 0;        twopoint.y = 0;    }            CGRect frame;    frame.origin      = CGPointZero;    frame.size.width  = MAX(onepoint.x + oneframe.size.width, twopoint.x + twoframe.size.width);    frame.size.height = MAX(onepoint.y + oneframe.size.height,twopoint.y + twoframe.size.height);        if (self = [self initWithFrame:frame])    {        UIGraphicsPushContext(UIGraphicsGetCurrentContext());        UIGraphicsBeginImageContext(frame.size);                [one.image drawAtPoint:onepoint];        [two.image drawAtPoint:twopoint];        self.image = UIGraphicsGetImageFromCurrentImageContext();                UIGraphicsEndImageContext();        UIGraphicsPopContext();                self.isCombined = YES;		         self.grid_x = MIN(one.grid_x, two.grid_x);        self.grid_y = MIN(one.grid_y, two.grid_y);                if (one.grid_x > two.grid_x) self.isRight = one.isRight;        else self.isRight = two.isRight;                if (one.grid_x > two.grid_x) self.isLeft = two.isLeft;        else self.isLeft = one.isLeft;                if (one.grid_y > two.grid_y) self.isDown = one.isDown;        else self.isDown = two.isDown;                if (one.grid_y > two.grid_y) self.isUp = two.isUp;        else self.isUp = one.isUp;                self.center = one.center;        self.transform = CGAffineTransformScale(incomingTransform, 0.5, 0.5);        self.previousRotation = self.transform;    }        //[one release]; //should release here after copy!    //[two release];    return self;}#pragma mark - Miscellaneous-(void)setDelegate:(id<PuzzleGestureDelegate, UIGestureRecognizerDelegate>)delegate{    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:delegate action:@selector(panToMatchGesture:)];    [panner setDelegate:delegate];    [self addGestureRecognizer:panner];    [panner release];        UIRotationGestureRecognizer *rotater = [[UIRotationGestureRecognizer alloc] initWithTarget:delegate action:@selector(rotateToMatchGesture:)];    [rotater setDelegate:delegate];    [self addGestureRecognizer:rotater];    [rotater release];        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(tapToMatchGesture:)];    [tapper setDelegate:delegate];    [tapper setNumberOfTapsRequired:2];    [self addGestureRecognizer:tapper];    [tapper release];}-(id)copyWithZone:(NSZone *)zone{    PuzzleGameImageView *copy = [[PuzzleGameImageView alloc] init];    copy.previousRotation = self.previousRotation;    copy.selected = self.selected;    copy.grid_x = self.grid_x;    copy.grid_y = self.grid_y;    return copy;}-(CGFloat)adjustToNearestDesiredAngle{    static const CGFloat DESIRED_ANGLE = 3.14159 / 4.0;    const CGFloat angle = atan2(self.transform.b, self.transform.a);    const CGFloat thefloat = (NSInteger)round(angle / DESIRED_ANGLE);    return thefloat * DESIRED_ANGLE;}- (void)drawRect:(CGRect)rect{    NSLog(@"draw rect");}#pragma mark -#pragma mark Draw#define CO_PADDING 0/*- (CGPoint)sum:(CGPoint)a plus:(CGPoint)b firstWeight:(float)f{    return CGPointMake(f*a.x+(1-f)*b.x, f*a.y+(1-f)*b.y);}- (CGPoint)sum:(CGPoint)a plus:(CGPoint)b{    return CGPointMake(a.x+b.x, a.y+b.y);}- (void)drawEdgeNumber:(int)n ofType:(int)type inContext:(CGContextRef)ctx {        float x = self.bounds.size.width;    float y = self.bounds.size.height;    float l;    float p = self.padding;        BOOL vertical = NO;    int sign = 1;        CGPoint a = CGPointZero;    CGPoint b = CGPointZero;        switch (n) {        case 1:            a = CGPointMake(p, p);            b = CGPointMake(x-p, p);            vertical = YES;            sign = -1;            break;        case 2:            a = CGPointMake(x-p, p);            b = CGPointMake(x-p, y-p);            sign = 1;            break;        case 3:            a = CGPointMake(x-p, y-p);            b = CGPointMake(p, y-p);            vertical = YES;            sign = 1;            break;        case 4:            a = CGPointMake(p, y-p);            b = CGPointMake(p, p);            sign = -1;            break;                    default:            break;    }        if (type<0) {        sign *= -1;    }        if (vertical) {        l = y;    } else {        l = x;    }        float l3 = (l-2*p)/3;        CGPoint point = [self sum:a plus:b firstWeight:2.0/3.0];    CGContextAddLineToPoint(ctx, point.x, point.y);        if (abs(type)==1) { //Triangolino                CGPoint p2 = [self sum:a plus:b firstWeight:1.0/2.0];                if (!vertical) {            p2 = [self sum:p2 plus:CGPointMake(sign*(p-CO_PADDING), 0)];        } else {            p2 = [self sum:p2 plus:CGPointMake(0, sign*(p-CO_PADDING))];        }                CGContextAddLineToPoint(ctx, p2.x, p2.y);                        CGPoint p3 = [self sum:a plus:b firstWeight:1.0/3.0];        CGContextAddLineToPoint(ctx, p3.x, p3.y);            } else if (abs(type)==2) { //Cerchietto                CGPoint p2 = [self sum:a plus:b firstWeight:1.0/2.0];                switch (n) {            case 1:                CGContextAddArc(ctx, p2.x, p2.y, (l-2*p)/6, M_PI, 0, sign+1);                break;            case 2:                CGContextAddArc(ctx, p2.x, p2.y, (l-2*p)/6, M_PI*3/2, M_PI/2, sign-1);                break;            case 3:                CGContextAddArc(ctx, p2.x, p2.y, (l-2*p)/6, 0, M_PI, sign-1);                break;            case 4:                CGContextAddArc(ctx, p2.x, p2.y, (l-2*p)/6, M_PI/2, M_PI*3/2, sign+1);                break;            default:                break;        }            } else if (abs(type)==3) { //Quadratino                CGPoint p2 = point;        CGPoint p3 = point;        CGPoint p4 = point;                switch (n) {            case 1:                p2 = [self sum:p2 plus:CGPointMake(0, sign*(p-CO_PADDING))];                p3 = [self sum:p2 plus:CGPointMake(l3, 0)];                p4 = [self sum:point plus:CGPointMake(l3, 0)];                break;            case 2:                p2 = [self sum:p2 plus:CGPointMake(sign*(p-CO_PADDING), 0)];                p3 = [self sum:p2 plus:CGPointMake(0, l3)];                p4 = [self sum:point plus:CGPointMake(0 , l3)];                break;            case 3:                p2 = [self sum:p2 plus:CGPointMake(0, sign*(p-CO_PADDING))];                p3 = [self sum:p2 plus:CGPointMake(-l3, 0)];                p4 = [self sum:point plus:CGPointMake(-l3, 0)];                break;            case 4:                p2 = [self sum:p2 plus:CGPointMake(sign*(p-CO_PADDING), 0)];                p3 = [self sum:p2 plus:CGPointMake(0, -l3)];                p4 = [self sum:point plus:CGPointMake(0 , -l3)];                break;            default:                break;        }                CGContextAddLineToPoint(ctx, p2.x, p2.y);        CGContextAddLineToPoint(ctx, p3.x, p3.y);        CGContextAddLineToPoint(ctx, p4.x, p4.y);                            } else {                point = [self sum:a plus:b firstWeight:1.0/3.0];        CGContextAddLineToPoint(ctx, point.x, point.y);            }        CGContextAddLineToPoint(ctx, b.x, b.y);                //UIGraphicsPopContext();    }- (void)drawRect:(CGRect)rect {        //return;    padding = self.bounds.size.width*0.15;    //float LINE_WIDTH = self.bounds.size.width*0.005;        CGContextRef ctx = UIGraphicsGetCurrentContext();                CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.1);    //CGContextSetLineWidth(ctx, LINE_WIDTH);    CGContextSetLineJoin(ctx, kCGLineJoinRound);            CGContextBeginPath(ctx);    CGContextMoveToPoint(ctx, self.padding, self.padding);        if (self.edges.count > 0) {        for (int i=1; i<5; i++) {            int e = [[self.edges objectAtIndex:i-1] intValue];            [self drawEdgeNumber:i ofType:e inContext:ctx];        }    }            CGContextClip(ctx);    [image drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];            CGContextBeginPath(ctx);    CGContextMoveToPoint(ctx, self.padding, self.padding);        if (self.edges.count > 0) {    for (int i=1; i<5; i++) {        int e = [[self.edges objectAtIndex:i-1] intValue];        [self drawEdgeNumber:i ofType:e inContext:ctx];    }}    CGContextClosePath(ctx);    CGContextDrawPath(ctx, kCGPathStroke);    }*/@end