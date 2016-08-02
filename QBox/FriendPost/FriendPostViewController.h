//
//  FriendPostViewController.h
//  QBox
//
//  Created by iApp on 18/07/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"
@class GADBannerView, GADRequest;
@interface FriendPostViewController : UIViewController
@property(strong,nonatomic) NSString *totalQuesString;




@property(strong, nonatomic) GADBannerView *adBanner;
- (GADRequest *)createRequest;

@end
