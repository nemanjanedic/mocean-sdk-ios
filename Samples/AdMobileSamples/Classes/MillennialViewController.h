//
//  MillennialViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 4/4/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"


@interface MillennialViewController : UIViewController <AdViewDelegate> {
	AdView* _adView;
}

@end
