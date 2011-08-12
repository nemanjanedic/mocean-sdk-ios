//
//  DelegateViewController.m
//  AdMobileSamples
//
//  Created by Constantine on 8/6/10.
//

#import "DelegateViewController.h"

@implementation DelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:35 /255.0f
                                                green:31 /255.0f
                                                 blue:32 /255.0f
                                                alpha:1.0];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imageView];
    [imageView release];
	
	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
	_adView.updateTimeInterval = 30;
	_adView.delegate = self;
	
	[self.view addSubview:_adView];
}

- (void) dealloc {
	_adView.delegate = nil;
	[_adView release];
	[super dealloc];
}

#pragma mark -
#pragma mark AdViewDelegate methodes

- (void) willReceiveAd:(id)sender {
	if (sender == _adView) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"willReceiveAd" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
}

- (void) didReceiveAd:(id)sender {
	if (sender == _adView) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didReceiveAd" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
	if (sender == _adView) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
}

- (void) adWillStartFullScreen:(id)sender {
	if (sender == _adView) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"adShouldStartFullScreen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
}

- (void) adDidEndFullScreen:(id)sender {
	if (sender == _adView) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"adDidEndFullScreen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
}

- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url {
    if (sender == _adView) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"adShouldOpen withUrl:%@", [url absoluteString]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
    
    return YES;
}

@end