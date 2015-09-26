//
//  PostQuestionViewController.h
//  QBox
//
//  Created by iapp on 22/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

#import <CoreLocation/CoreLocation.h>



@interface PostQuestionViewController : UIViewController<RevMobAdsDelegate, CLLocationManagerDelegate>

@property(strong,nonatomic) NSMutableArray *categoryArray;

@property(strong,nonatomic) UIImage *postImage;

@property(strong,nonatomic) NSString *questionId;

@end
