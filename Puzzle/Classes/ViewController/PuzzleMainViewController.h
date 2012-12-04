////  PuzzleMainViewController.h//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import <UIKit/UIKit.h>#import "PuzzleGameModel.h"#import "PuzzleGameImageView.h"#import "SettingViewController.h"@interface PuzzleMainViewController : UIViewController <UIAlertViewDelegate, UIAccelerometerDelegate, UIGestureRecognizerDelegate, PuzzleGameModelDelegate,PuzzleGestureDelegate,PuzzleSettingsDelegate >{}/* IBOutlet */@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;@property (nonatomic, retain) IBOutlet UILabel *timeLabel;/* For data */@property (nonatomic, retain) UIImage *mainImage;@property (nonatomic) NSUInteger number_of_rows;@property (nonatomic) NSUInteger number_of_columns;/* Time and Date */@property (nonatomic, retain) NSDate *startDate;@property (nonatomic, retain) NSTimer *mainTimer;@end