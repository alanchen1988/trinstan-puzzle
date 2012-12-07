////  MenuViewController.h//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import <UIKit/UIKit.h>@class PuzzleMainViewController;@interface MenuViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{}@property (nonatomic, retain) PuzzleMainViewController *puzzleViewController;@property (nonatomic, retain) UIPopoverController *popController;/*images*/@property (nonatomic, retain) IBOutlet UIImageView *selectedImage;/*sliders*/@property (nonatomic, retain) IBOutlet UISlider *puzzleSliderRows;@property (nonatomic, retain) IBOutlet UISlider *puzzleSliderColumns;/*labels*/@property (nonatomic, retain) IBOutlet UILabel *puzzleLabelRows;@property (nonatomic, retain) IBOutlet UILabel *puzzleLabelColumns;/* Segment*/@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;- (IBAction)puzzleImageSelected:(id)sender;- (IBAction)startGame:(id)sender;- (IBAction)puzzleChangedForRow:(id)sender;- (IBAction)puzzleChangesDidEndForRow:(id)sender;- (IBAction)puzzleChangedForColumns:(id)sender;- (IBAction)puzzleChangesDidEndForColumn:(id)sender;@end