//
//  AppDelegate.h
//  QBox
//
//  Created by iapp on 22/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaBBarViewController.h"

#import <CoreData/CoreData.h>

#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>
@class FirstScreenViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate,RevMobAdsDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TaBBarViewController *TabBarView;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) FirstScreenViewController *_firstScreen;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic) NSArray *thumbnailImage;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(AppDelegate *)sharedDelegate;
+(CAKeyframeAnimation *)popupAnimation;
-(NSString *)localDateFromDate:(NSString *)serverDate;
@property (nonatomic) BOOL haveToStop;
@property (nonatomic) BOOL pushNotificationFetching;

@property(strong,nonatomic)UIImage *postedImage;
@property(strong,nonatomic)UIImage *answersPostImage;


@property(strong,nonatomic) id userDetail;
//Login Using Facebook Login id is 1
//Login Using Gmail Login Id is 2
//Login Using SignIn then login id is 3
@property(strong,nonatomic) id loginDetails;

@property(strong,nonatomic) NSString *activityText;
-(void)showActivityInView:(UIView *)view withBlock:(void (^) (void))successBlock;
-(void)hideActivity;
-(UIFont*) fontWithName:(CGFloat)size;
- (NSString *)statusTextWithStatusID:(NSInteger)statusID;

@end
