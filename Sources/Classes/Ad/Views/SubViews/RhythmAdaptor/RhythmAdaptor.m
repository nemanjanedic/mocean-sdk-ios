//
//  RhythmAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/12/11.
//

#import "RhythmAdaptor.h"



@implementation RhythmAdaptor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
#ifdef INCLUDE_RHYTHM
    [_appId release];
    [rhythmAdView cancel];
    [rhythmAdView removeFromSuperview];
    [rhythmAdView release];
#endif
    [super dealloc];
}

- (void) showWithAppID:(NSString*)appId {
#ifdef INCLUDE_RHYTHM
    _appId = [appId retain];
    
    rhythmAdView = [RhythmAdFactory displayAdViewWithDelegate:self adUnit:kInterstitial];
    [rhythmAdView retain];
    [self addSubview:rhythmAdView];
#endif
}

#ifdef INCLUDE_RHYTHM

#pragma mark 
#pragma mark Rhythm delegate

/*!
 A string uniquely identifying the application - provided by Rhythm
 */
-(NSString *)appId {
    return _appId;
}

//#ifdef ADMOBILE_RHYTHM

/*!
 Sent when an ad was successfully received and is ready
 to be displayed. This would be an appropriate time to add the view
 to your view hierarchy (if desired and you haven't already),
 or to call the showAsTakeover method if this was the result
 of an interstitial request.
 */
-(void)didReceiveAdForAdView:(UIView<RhythmAd> *)adView {
    if (self.superview) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

/*!
 Sent when an ad request failed to retrieve an ad.
 */
-(void)didNotReceiveAdForAdView:(UIView<RhythmAd> *)adView error:(NSError *)error {
    if (self.superview) {        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
}

/*!
 Sent when an ad is requesting to remain onscreen. If set, the adView's 
 desiredTTL property will indicate for how long the ad would like to be 
 pinned onscreen.
 
 Additionally, there is a pinned property of the adView that you may
 query to determine the pinned status of the ad.
 */
//-(void)adViewWouldLikeToRemainOnscreen:(UIView<RhythmAd> *)adView;

/*!
 Sent when an ad is indicating that it is okay to
 remove it from the screen.
 */
//-(void)adViewDidUnpin:(UIView<RhythmAd> *)adView;

/*!
 Sent when an ad is indicating that it would like to be dismissed,
 likely in response to a javascript action on the ad creative.
 */
//-(void)adViewDidRequestDismissal:(UIView<RhythmAd> *)adView;

/*!
 Background color of the ad view, visible before an ad is loaded,
 and also if the ad asset is smaller than the ad view.
 By default the background is transparent.
 */
//-(UIColor*)backgroundColorForAdView:(UIView<RhythmAd> *)adView;

/*!
 Case 1
 ------
 If your app already has location data and you would like to provide it
 to the ad server, you should
 - implement this method and return YES
 - implement locationForAdView: and return the user's location
 
 Case 2
 ------
 If your app does not have location data but you would like the Rhythm
 SDK to determine it and provide it to the ad server, you should:
 - implement this method and return YES
 - do not implement locationForAdView:
 
 Some notes concerning location:
 - the first ad request for which the Rhythm SDK will be asked
 to determine location information may not actually include location
 data, since it takes some time to retrieve that data from the OS
 - if the user has turned off location services for their device, the
 Rhythm SDK will not attempt to determine location data
 
 Case 3
 ------
 If you do not want to provide location data to the ad server, you
 should not implement this method (or you could have it return NO).
 */
-(BOOL)locationEnabledForAdView:(UIView<RhythmAd> *)adView {
    return YES;
}

/*!
 If locationEnabledForAdView: (above) is not implemented or returns NO, 
 this will not be called.
 
 if locationEnabledForAdView: is implemented and returns YES, this 
 will be called. You can:
 - implement this and return location data if you already have it
 - implement this and return nil if the user's location is unknown
 - do not implement this if you want the Rhythm SDK to determine 
 ths user's location
 */
#ifdef INCLUDE_LOCATION_MANAGER
-(CLLocation *)locationForAdView:(UIView<RhythmAd> *)adView {
    return [LocationManager sharedInstance].currentLocation;
}
#endif


// Comma-separated targeting parameters
//-(NSString *)targetingForAdView:(UIView<RhythmAd> *)adView;

// Common targeting parameters
//-(NSString *)postalCodeForAdView:(UIView<RhythmAd> *)adView; // zip code
//-(NSString *)areaCodeForAdView:(UIView<RhythmAd> *)adView; // phone area code
//-(NSDate *)dateOfBirthForAdView:(UIView<RhythmAd> *)adView; // user's date of birth
//-(NSString *)genderForAdView:(UIView<RhythmAd> *)adView; // "male" or "female"

// The return value will decide which side (either the application or the SDK) will present the landing page view.
// If this is implemented and returns YES then the SDK will call the method presentLandingPageForAdView:
// so that the app can present its own custom landing page view
// If it's not implemented or returns NO then the SDK will present the built-in landing page view.
-(BOOL)useCustomLandingPageForAdView:(UIView<RhythmAd> *)adView {
    return YES;
}

// Called when the ad is touched.
// This will be called only when useCustomLandingPageForAdView is implemented and returns YES.
// When this is called, the app should process the url and presents the landing page
-(void)presentLandingPageForAdView:(UIView<RhythmAd>  *)adView landingUrl:(NSURL *)landingUrl {
    if (self.superview) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.superview];
        
        // send callback
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSURLRequest requestWithURL:landingUrl], self.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"request", @"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenURLNotification object:info];
    }
}

// Notification methods in regards to the landing page presentation
// These methods will be called only when the built-in WebView is used.
// If the parameter animated is YES then it means the view will be presented in an animated fashion
// with the standard time interval used by the iPhone UI framework.
//-(void)willPresentLandingPageForAdView:(UIView<RhythmAd> *)adView animated:(BOOL)animated;
//-(void)didPresentLandingPageForAdView:(UIView<RhythmAd> *)adView animated:(BOOL)animated;
//-(void)willDismissLandingPageForAdView:(UIView<RhythmAd> *)adView animated:(BOOL)animated;
//-(void)didDismissLandingPageForAdView:(UIView<RhythmAd> *)adView animated:(BOOL)animated;

// Notification methods for interstitial takeover events.
//-(void)willPresentTakeoverForAdView:(UIView<RhythmInterstitialAd> *)adView animated:(BOOL)animated;
//-(void)didPresentTakeoverForAdView:(UIView<RhythmInterstitialAd> *)adView animated:(BOOL)animated;
//-(void)willDismissTakeoverForAdView:(UIView<RhythmInterstitialAd> *)adView animated:(BOOL)animated;
//-(void)didDismissTakeoverForAdView:(UIView<RhythmInterstitialAd> *)adView animated:(BOOL)animated;

//#endif

#pragma mark -
#pragma mark testing only

/*!
 If implemented and returns YES, ads from Rhythm's test ad server
 will be dislayed. Don't submit your app with this turned on!
 */
-(BOOL)testMode {
    return [_appId isEqualToString:@"testMode"];
}

/*!
 If implemented and returns non-nil, this is the URL string that will be
 used for ad click events. You can use this to test various click-through
 types, regardless of the click-through of the actual ad.
 This is only used if testMode is implemented and returns YES.
 */
//-(NSString *)clickURLForTestMode;

#endif

@end
