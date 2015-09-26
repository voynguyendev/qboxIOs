//
//  TopicViewController.h
//  QBox
//
//  Created by iApp1 on 28/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMPullToRefreshManager.h"

@interface TopicViewController : UIViewController


@property(strong,nonatomic) NSString *Indexredirect;
@property (nonatomic, readwrite, strong) MNMPullToRefreshManager *pullToRefreshManager;
@end
