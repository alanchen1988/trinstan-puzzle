    ////  PuzzleMainViewController.m//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import "PuzzleMainViewController.h"#import "UIImage+Category.h"@interface PuzzleMainViewController()@property CGSize pieceSize;@property BOOL accelerationEnabled;@property (nonatomic, retain) PuzzleGameModel *model;@property (nonatomic, retain) NSMutableArray *puzzlePieces;@property (nonatomic) NSInteger numberSelected;@property (nonatomic, retain) UIAlertView *userWonAlertView;@property (nonatomic, retain) UIPopoverController *popController;- (UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)itemSize;- (void)resetTimer;@end@implementation PuzzleMainViewController@synthesize thumbnailImageView,timeLabel;@synthesize mainImage,number_of_rows,number_of_columns;@synthesize startDate,mainTimer;@synthesize puzzlePieces = _puzzlePieces;@synthesize model = _model;@synthesize userWonAlertView;@synthesize popController;@synthesize pieceSize,accelerationEnabled;@synthesize numberSelected;;#pragma mark -#pragma mark LifyCycle// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.- (void)viewDidLoad {	NSLog(@"viewDidLoad");    [super viewDidLoad];	//load the thumbnail image	self.thumbnailImageView.image = self.mainImage;		/* setting up accelerator */    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0/40.0)];    [[UIAccelerometer sharedAccelerometer] setDelegate:self];    accelerationEnabled = YES;		/* settings button */    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:nil action:nil];    self.navigationItem.rightBarButtonItem.target = self;    self.navigationItem.rightBarButtonItem.action = @selector(popupSetting);		/* view controller and popover for settings button */    SettingViewController *settings = [[SettingViewController alloc] init];    settings.delegate = self;    self.popController = [[[UIPopoverController alloc] initWithContentViewController:settings] autorelease];    [settings release];    self.popController.popoverContentSize = CGSizeMake(230,60);		/* default image */    NSLog(@"number_of_row=%d, number_of_columns=%d, mainImage=%@",number_of_rows,number_of_columns,mainImage);		self.mainImage = [self scaleImage:self.mainImage ToSize:CGSizeMake(640, 450)];	    NSArray *imageArray = [self.mainImage getRectangularPuzzlePiecesWithRows:number_of_rows andColumns:number_of_columns];        pieceSize = CGSizeMake(self.mainImage.size.width / ((CGFloat)number_of_columns),                           self.mainImage.size.height / ((CGFloat)number_of_rows));    self.model.pieceSize = pieceSize;        int i=0, j;    NSMutableArray *pieces = [[NSMutableArray alloc] initWithCapacity:number_of_rows*number_of_columns];    for(NSArray *row in imageArray)    {        j=0;        for(UIImage *image in row)         {            const CGFloat X = arc4random() % (int)(self.view.frame.size.width - image.size.width / 2.0);            const CGFloat Y = arc4random() % (int)(self.view.frame.size.height - image.size.height / 2.0);            CGRect frame = CGRectMake(X, Y, image.size.width, image.size.height);			            PuzzleGameImageView *view = [[PuzzleGameImageView alloc] initWithFrame:frame];            view.image = image;            view.grid_x = i;            view.grid_y = j;            [view setDelegate:self];                        [pieces addObject:view];            [self.view addSubview:view];            [self.model setGamePiece:view atGridPosition:CGPointMake(view.grid_x,view.grid_y)];            [view release];            j++;        }        i++;    }	    self.puzzlePieces = pieces;		//timer and date	[self resetTimer];}-(void)viewDidAppear:(BOOL)animated{    [self becomeFirstResponder];}- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {    // Overriden to allow any orientation.    return [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||	[UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight;}#pragma mark -  Model Delegate methods-(void)combinePiece:(PuzzleGameImageView*)one withOther:(PuzzleGameImageView*)two{    NSLog(@"Implementing %s", __FUNCTION__);        if (self.numberSelected <= 0)    {        NSLog(@"Nope, number selected is %d", numberSelected);        self.numberSelected = 0;    }    else if (ABS([one adjustToNearestDesiredAngle] - [two adjustToNearestDesiredAngle]) > .1)     {        NSLog(@"Bad angle");        return;    }    else    {         NSLog(@"Good angle");		        if (CGRectIntersectsRect(one.frame, two.frame))            [UIView animateWithDuration:0.5 animations:^{                NSLog(@"They are intersecting");                self.numberSelected = 0;				                PuzzleGameImageView *view = [[PuzzleGameImageView alloc] initByCombining:one andOther:two withRegularSize:pieceSize];                //view.delegate = self;				[view setDelegate:self];				                [self.model combinePieces:one andOther:two intoNew:view];                [one removeFromSuperview];                [two removeFromSuperview];                [self.puzzlePieces removeObject:one];                [self.puzzlePieces removeObject:two];				                [self.puzzlePieces addObject:view];                [self.view addSubview:view];                                [view release];            }];        else NSLog(@"Not intersecting");    }        }-(void)userDidSolvePuzzle{    NSLog(@"Need to implement %s", __FUNCTION__);    [userWonAlertView show];}#pragma mark - Gesture Recognizer methods-(void)tapToMatchGesture:(UITapGestureRecognizer*)gesture{	NSLog(@"tap To Match Gesture ---- ");    if (gesture.state == UIGestureRecognizerStateEnded)    {        PuzzleGameImageView *view = (PuzzleGameImageView*)gesture.view;                if (!view.selected && self.numberSelected <= 1)        {            CGAffineTransform scale = CGAffineTransformMakeScale(2.0, 2.0);            CGAffineTransform transform = CGAffineTransformConcat(scale, view.previousRotation);            [UIView animateWithDuration:0.5 animations:^(void){ view.transform = transform; }];            self.numberSelected += 1;        }        else if (view.selected)        {            [UIView animateWithDuration:0.5 animations:^(void){ view.transform = view.previousRotation; }];            self.numberSelected -= 1;        }                view.selected = !view.selected;        [self.model updateWithView:view andSelected:view.selected];    }}-(void)panToMatchGesture:(UIPanGestureRecognizer*)gesture{    PuzzleGameImageView *view = (PuzzleGameImageView*)gesture.view;    switch(gesture.state)    {        case UIGestureRecognizerStateBegan:                        NSLog(@"Pan Began");            [self.view bringSubviewToFront:view]; //might also want this in StateEnded. gameplay decison.                    case UIGestureRecognizerStateChanged:        {            //obtain translation (since last call to function)            CGPoint translation = [gesture translationInView:view.superview];                        //change the center (similar to view.center += translation)            view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);                        //reset the translation to 0            [gesture setTranslation:CGPointZero inView:view.superview];                        break;        }        case UIGestureRecognizerStateEnded:        {            [self.model setGamePiece:view atWorldPosition:view.center];            NSLog(@"Number selected is %d", numberSelected);        }                    case UIGestureRecognizerStateCancelled:        case UIGestureRecognizerStatePossible:        case UIGestureRecognizerStateFailed:               break;    }}-(void)rotateToMatchGesture:(UIRotationGestureRecognizer*)gesture{	NSLog(@"rotate To MatchGesture");    PuzzleGameImageView *view = (PuzzleGameImageView*)gesture.view;        switch(gesture.state)    {        case UIGestureRecognizerStateBegan:        case UIGestureRecognizerStateChanged:        {            CGAffineTransform transform = CGAffineTransformMakeRotation(gesture.rotation * 1.5); //makes it feel faster            transform = CGAffineTransformConcat(view.previousRotation, transform);            view.transform = transform;            break;        }        case UIGestureRecognizerStateCancelled:        case UIGestureRecognizerStateFailed:        case UIGestureRecognizerStateEnded:        {            [UIView animateWithDuration:0.5 animations:^{                 CGFloat angle = [view adjustToNearestDesiredAngle];                view.transform = CGAffineTransformMakeRotation(angle);                view.previousRotation = view.transform;            }];        }                    case UIGestureRecognizerStatePossible:            break;    }        if (view.selected) view.transform = CGAffineTransformConcat(view.transform, CGAffineTransformMakeScale(2.0, 2.0));}#pragma mark -#pragma mark - Accelerometer, Shake-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{    if (!accelerationEnabled) return;    static const float sensitivity = 10.0f;            float xDistance=acceleration.x*sensitivity;    float yDistance=acceleration.y*(0-sensitivity);        //NSLog(@"sf %f", acceleration.x);    if(fabsf(acceleration.x)<0.01||fabsf(acceleration.y)<0.01)    {        xDistance=0;        yDistance=0;    }    else for(PuzzleGameImageView *view in self.puzzlePieces)    {        CGPoint newCenter = [view center];        newCenter.x += xDistance;        newCenter.y += yDistance;                if(newCenter.x<50.0)            newCenter.x=50.0;        else if(newCenter.x>700.0)            newCenter.x=700.0;                if (newCenter.y<50.0)            newCenter.y=50.0;        else if(newCenter.y>950.0)            newCenter.y=950.0;                [view setCenter:newCenter];    }}-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{    if(motion == UIEventSubtypeMotionShake)        [[[[UIAlertView alloc] initWithTitle:@"You shook the puzzle!"                                      message:@"Would you like to reset the puzzle pieces?"                                    delegate:self                            cancelButtonTitle:@"Cancel"                           otherButtonTitles:@"Yes", nil]           autorelease] show];}-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    if (alertView == userWonAlertView)    {        if (buttonIndex == 0)            [self.navigationController popViewControllerAnimated:YES];        else			[self resetTimer];    }    else 		if (buttonIndex==1) 		{			[self resetTimer];						[UIView animateWithDuration:0.5 animations:^{				for (PuzzleGameImageView *view in self.puzzlePieces) 				{					view.center = CGPointMake(arc4random() % 768, arc4random() % 1024);					view.previousRotation = view.transform = CGAffineTransformMakeRotation(arc4random());				}			}];		}}#pragma mark -#pragma mark Private methods-(id)init{    if (self = [super init])    {        _puzzlePieces = [[NSMutableArray alloc] init];        _model = [[PuzzleGameModel alloc] init];        _model.delegate = self;        numberSelected = 0;        userWonAlertView = [[UIAlertView alloc] initWithTitle:@"You beat the game!"                                                       message:@"Would you like to play again?"                                                     delegate:self                                            cancelButtonTitle:@"No"                                            otherButtonTitles:@"Yes", nil];    }    return self;}-(void)enableAcceleration:(BOOL)enable{    accelerationEnabled = enable;}-(void)popupSetting{    [self.popController presentPopoverFromRect:CGRectMake(960,0,0,0)								  inView:self.view                 permittedArrowDirections:UIPopoverArrowDirectionUp                                 animated:YES];}-(void) updateTimer{    NSDate *currentDate = [NSDate date];    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    [dateFormatter setDateFormat:@"mm:ss:SS"];    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];    NSString *timeString = [dateFormatter stringFromDate:timerDate];    self.timeLabel.text = [NSString stringWithFormat:@"%@", timeString];    [dateFormatter release];    }-(BOOL)canBecomeFirstResponder{    return YES;}//set the image to limited size-(UIImage *)scaleImage:(UIImage *)img ToSize:(CGSize)itemSize{    UIImage *i;    UIGraphicsBeginImageContext(itemSize);    CGRect imageRect=CGRectMake(0, 0, itemSize.width, itemSize.height);    [img drawInRect:imageRect];    i=UIGraphicsGetImageFromCurrentImageContext();    UIGraphicsEndImageContext();    return i;}- (void)resetTimer{	self.startDate = [NSDate date];	self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];}#pragma mark - Gesture Delegate methods-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{    NSLog(@"%s",__FUNCTION__);}-(void)touchesChanged:(NSSet *)touches withEvent:(UIEvent *)event{    NSLog(@"%s",__FUNCTION__);	}-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{    NSLog(@"%s",__FUNCTION__);}-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{    NSLog(@"%s",__FUNCTION__);}-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{    return YES;}#pragma mark -#pragma mark MemoryWarning- (void)didReceiveMemoryWarning {    // Releases the view if it doesn't have a superview.    [super didReceiveMemoryWarning];        // Release any cached data, images, etc. that aren't in use.}- (void)viewDidUnload {    [super viewDidUnload];    // Release any retained subviews of the main view.    // e.g. self.myOutlet = nil;	self.thumbnailImageView = nil;	self.timeLabel = nil;}- (void)dealloc {	[mainImage release];	self.mainImage = nil;	[startDate release];	self.startDate = nil;	[mainTimer release];	self.mainTimer = nil;    [super dealloc];}@end