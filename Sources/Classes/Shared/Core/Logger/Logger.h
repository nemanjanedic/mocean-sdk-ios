//
//  Logger.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/19/10.
//

#import <Foundation/Foundation.h>

#import "LogBasicFormatter.h"
#import "NotificationCenter.h"
#import "AdView.h"
#import "AdView_Private.h"

@interface Logger : NSObject {
    NSMutableArray*     _ads;
}

+ (Logger*)sharedInstance;
+ (void)releaseSharedInstance;

@end
