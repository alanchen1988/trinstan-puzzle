    ////  MenuViewController.m//  Puzzle////  Created by Trinstan on 12/4/12.//  Copyright 2012 __MyCompanyName__. All rights reserved.//#import "MenuViewController.h"#import "PuzzleMainViewController.h"#import <MediaPlayer/MediaPlayer.h>#import <QuartzCore/QuartzCore.h>//test the Normal Puzzle#import "NormalPuzzleViewController.h"@interface MenuViewController()@property (nonatomic, retain) NormalPuzzleViewController *normalPuzzleViewController;@end@implementation MenuViewController@synthesize normalPuzzleViewController = _normalPuzzleViewController;@synthesize puzzleViewController = _puzzleViewController;@synthesize popController  = _popController;@synthesize selectedImage;@synthesize puzzleSliderRows,puzzleSliderColumns;@synthesize puzzleLabelRows,puzzleLabelColumns;#pragma mark -#pragma mark LifeCycle/*// Implement loadView to create a view hierarchy programmatically, without using a nib.- (void)loadView {}*/// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.- (void)viewDidLoad {    [super viewDidLoad];	NSLog(@"viewDidLoad");		self.title = @"MultiJig";	self.selectedImage.image = [UIImage imageNamed:@"puppy.jpg"];	[self.selectedImage.layer setMasksToBounds:YES];	[self.selectedImage.layer setCornerRadius:5.0];        UIImagePickerController *picker = [[UIImagePickerController alloc] init];    picker.delegate  = self;    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;        self.popController = [[UIPopoverController alloc] initWithContentViewController:picker];    [picker release];        //if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])}#pragma mark -#pragma mark IBAction Methods-(IBAction)puzzleImageSelected:(id)sender{		UIButton *button = (UIButton *)sender;	self.popController.popoverContentSize = CGSizeMake(0,0);    [self.popController presentPopoverFromRect:CGRectMake(button.frame.origin.x + button.frame.size.width/2, 														  button.frame.origin.y + button.frame.size.height*3/2, 														  0, 0)                                  inView:self.view                 permittedArrowDirections:UIPopoverArrowDirectionDown                                 animated:YES]; 	//Returns the currently playing media item, or nil if none is playing.	// Setting the nowPlayingItem to an item in the current queue will begin playback at that item.	/*	MPMusicPlayerController* player = [MPMusicPlayerController iPodMusicPlayer];	MPMediaItem *item = [player nowPlayingItem];	MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];	UIImage *albumCoverArt = [artwork imageWithSize:self.selectedImage.bounds.size];	if(albumCoverArt!=nil) {		// use the album images		self.selectedImage.image = albumCoverArt;	}	else {		// if the ipod does not play or the artwork is empty, use the default image		self.selectedImage.image = [UIImage imageNamed:@"puppy.jpg"];	}*/}-(IBAction)startGame:(id)sender{	NSLog(@"start Game");	#if 1	//_normalPuzzleViewController = [[[NormalPuzzleViewController alloc] initWithNibName:@"NormalPuzzleViewController" bundle:nil] autorelease];	_normalPuzzleViewController = [[NormalPuzzleViewController alloc] init];		self.normalPuzzleViewController.gambar = self.selectedImage.image;	self.normalPuzzleViewController.number_of_count = self.puzzleSliderRows.value;	[self.navigationController pushViewController:self.normalPuzzleViewController animated:YES];	#elif 0		_puzzleViewController = [[PuzzleMainViewController alloc] init];		self.puzzleViewController.mainImage = self.selectedImage.image;	self.puzzleViewController.number_of_rows = self.puzzleSliderRows.value;	self.puzzleViewController.number_of_columns = self.puzzleSliderColumns.value;		[self.navigationController pushViewController:self.puzzleViewController animated:YES];	#endif}-(IBAction)puzzleChangedForRow:(id)sender{	puzzleLabelRows.text = [NSString stringWithFormat:@"There will be %.0f rows",                                 round(puzzleSliderRows.value)];}-(IBAction)puzzleChangesDidEndForRow:(id)sender{	puzzleSliderRows.value = round(puzzleSliderRows.value);    [self puzzleChangedForRow:sender];}-(IBAction)puzzleChangedForColumns:(id)sender{	puzzleLabelColumns.text = [NSString stringWithFormat:@"There will be %.0f columns",                                    round(puzzleSliderColumns.value)];}-(IBAction)puzzleChangesDidEndForColumn:(id)sender{	puzzleSliderColumns.value = round(puzzleSliderColumns.value);    [self puzzleChangedForColumns:sender];}#pragma mark -#pragma mark Delegate//TODO: Get the image from the iPod album-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{	}-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{    self.selectedImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];    [self dismissModalViewControllerAnimated:YES];}#pragma mark -- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {    // Overriden to allow any orientation.    return [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||	[UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight;}- (void)didReceiveMemoryWarning {    // Releases the view if it doesn't have a superview.    [super didReceiveMemoryWarning];        // Release any cached data, images, etc. that aren't in use.}- (void)viewDidUnload {    [super viewDidUnload];    // Release any retained subviews of the main view.    // e.g. self.myOutlet = nil;	self.selectedImage = nil;	self.puzzleLabelRows = nil;	self.puzzleLabelColumns = nil;	self.puzzleSliderRows = nil;	self.puzzleSliderColumns = nil;}- (void)dealloc {	//[_popoverController release];	//[_puzzleViewController release];		[selectedImage release];	[puzzleSliderRows release];	[puzzleSliderColumns release];	[puzzleLabelRows release];	[puzzleLabelColumns release];    [super dealloc];}@end