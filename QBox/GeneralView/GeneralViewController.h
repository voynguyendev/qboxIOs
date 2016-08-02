//
//  GeneralViewController.h
//  QBox
//
//  Created by iapp1 on 7/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerViewDelegate.h"

@class GADBannerView, GADRequest;
@interface GeneralViewController : UIViewController<GADBannerViewDelegate>

@property(strong,nonatomic) NSString *totalQuesString;
@property(nonatomic,retain) NSString *callFromView;
@property(strong, nonatomic) GADBannerView *adBanner;
- (GADRequest *)createRequest;

@end
