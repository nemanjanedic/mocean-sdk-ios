//
//  InterstitialViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>
#import "AdInterstitialView.h"

@interface InterstitialViewController : UIViewController {
	AdInterstitialView* _adView;
}

- (id)initWithFrame:(CGRect)frame;

@end
