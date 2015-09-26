//
//  AppDelegate.m
//  QBox
//
//  Created by iapp on 22/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstScreenViewController.h"
#import "NotificationsData.h"
#import <RevMobAds/RevMobAds.h>
#import "WebServiceSingleton.h"
#import "LoginViewController_iPhone.h"
#import "AddFriendViewController.h"
#import "UpdatesViewController.h"


typedef void (^ACTIVITY_BLOCK)(void);

@interface AppDelegate()
@property (strong, nonatomic) ACTIVITY_BLOCK activityBlock;
@end

@implementation AppDelegate
@synthesize TabBarView;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
  // Google Api key  AIzaSyAHyjU2LmJtbW57KOlO_43yQ4_YpHmai5k
    
  //  NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
   // NSString *userId=[NSString stringWithFormat:@"%@",[userData valueForKey:@"id"]];
   
    
    
    
  

   
    [RevMobAds startSessionWithAppID:@"53fd85475270d0d348aafa64" andDelegate:self];

    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
       if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userid"])
     {
//         AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//         [self.navController pushViewController:addFriend animated:NO];
//         self.navController=[[UINavigationController alloc]initWithRootViewController:addFriend];
         
//         HomeViewController *homeView=[[HomeViewController alloc]init];
//         self.navController=[[UINavigationController alloc]initWithRootViewController:homeView];
         
         TabBarView=[[TaBBarViewController alloc]init];
         //TabBarView.notificationViewValue=0;
         self.navController=[[UINavigationController alloc]initWithRootViewController:TabBarView];
         
         self.navController.navigationBarHidden = YES;
    }
    else
    {
        //self._firstScreen=[[FirstScreenViewController alloc]init];
        LoginViewController_iPhone *loginView=[[LoginViewController_iPhone alloc]init];
       self.navController=[[UINavigationController alloc]initWithRootViewController:loginView];
    
    }
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    if (ver_float>=7.0f)
    {
         self.navController.navigationBar.barTintColor=[UIColor colorWithRed:228.0/255.0f green:194.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
    }
    else
    {
     self.navController.navigationBar.tintColor=[UIColor colorWithRed:228.0/255.0f green:194.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
    
    }
   
     self.window.rootViewController=self.navController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    }
    else
    {
        UIRemoteNotificationType myTypes =  UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
     //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    

    
  
    
    
  
 
    [NSThread sleepForTimeInterval:3.0];
    
      return YES;
    
    [self clearNotifications];
    
    
    
   
}

-(void)revmobSessionIsStarted {
    NSLog(@"[RevMob Sample App] Session is started.");
}

- (void)revmobSessionNotStartedWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Session failed to start: %@", error);
}

- (void)revmobAdDidFailWithError:(NSError *)error {
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

-(void) performSelectorInBackground:(SEL)aSelector withObject:(id)arg
{
    
}

-(void) pushNotificationData
{
    /*NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
    NSString *userId=[[userData valueForKey:@"id"]objectAtIndex:0];
    NSArray *pushNotificationData=[[WebServiceSingleton sharedMySingleton]pushNotificationData:userId];
    
    NSString *success=[[pushNotificationData valueForKey:@"success"]objectAtIndex:0];
    int sucessVal=[success intValue];
    if (sucessVal==1)
    {
        

    
    NSMutableArray *alldateArray=[[NSMutableArray alloc]init];
    
    NSMutableArray *messageNotification=[[pushNotificationData valueForKey:@"message_data"]objectAtIndex:0];
        
        if (![messageNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:messageNotification]mutableCopy];
        }
        
       NSMutableArray *addAnswerNotification=[[pushNotificationData valueForKey:@"add_answer_data"]objectAtIndex:0];
        
        if (![addAnswerNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:addAnswerNotification]mutableCopy];
        }
        
    NSMutableArray *acceptAnswersNotification=[[pushNotificationData valueForKey:@"accept_answer_data"]objectAtIndex:0];
        
        if (![acceptAnswersNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:acceptAnswersNotification]mutableCopy];
        }
    NSMutableArray *friendsNotification=[[pushNotificationData valueForKey:@"friend_data"]objectAtIndex:0];
        if (![friendsNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:friendsNotification]mutableCopy];
        }
        
        NSMutableArray *newArray = [[NSMutableArray alloc] init];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        for (id obj in alldateArray) {
            
            NSMutableDictionary *dict = [obj mutableCopy];
            NSDate *date = [df dateFromString:[dict objectForKey:@"date"]];
            NSTimeInterval interval = [date timeIntervalSince1970];
            [dict setObject:@(interval) forKey:@"date"];
            [newArray addObject:dict];
        }
        

        
   
   // alldateArray=[[NSMutableArray alloc]initWithArray:messageNotification];
//    alldateArray=[[alldateArray arrayByAddingObjectsFromArray:addAnswerNotification]mutableCopy];
//    alldateArray=[[alldateArray arrayByAddingObjectsFromArray:acceptAnswersNotification]mutableCopy];
//    alldateArray=[[alldateArray arrayByAddingObjectsFromArray:friendsNotification]mutableCopy];
    
    
    NSMutableArray *sortedArray;
    NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    sortedArray=[[newArray sortedArrayUsingDescriptors:@[descriptor]]mutableCopy];
  
    
    
    NSMutableArray *notificationArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[sortedArray count]; i++)
    {
        [notificationArray insertObject:[sortedArray objectAtIndex:i] atIndex:i];
        if (notificationArray.count==10)
        {
            break;
        }
    }
    
   
    
    
    
    NSString *messageData;
    NSString *questionId;
    NSString *value=@"0";
    NSManagedObject *message;
   
    
    for (int i=0; i<[notificationArray count]; i++)
    {
    NSString *category=[[notificationArray valueForKey:@"type"]objectAtIndex:i];
    NSArray *notifyArray=[notificationArray objectAtIndex:i];
    if ([category isEqualToString:@"message_data"])
    {
         NSString *userName=[notifyArray valueForKey:@"sender_name"];
         messageData=[NSString stringWithFormat:@"%@ sent you a message",userName];
         questionId=[notifyArray valueForKey:@"sender_id"];
    }
    else if ([category isEqualToString:@"accept_answer_data"])
    {
        NSString *userName=[notifyArray valueForKey:@"name"];
        questionId=[notifyArray valueForKey:@"questionId"];
        messageData=[NSString stringWithFormat:@"%@ your answer accepted",userName];
       
    }
    else if ([category isEqualToString:@"add_answer_data"])
    {
        NSString *userName=[notifyArray valueForKey:@"who_answer_name"];
        questionId=[notifyArray valueForKey:@"questionId"];
        messageData=[NSString stringWithFormat:@"%@ answered a question",userName];
    }
    else if ([category isEqualToString:@"friend_request_data"])
    {
        questionId=[notifyArray valueForKey:@"receiver_id"];
        NSString *userName=[notifyArray valueForKey:@"name"];
        NSString *status=[notifyArray valueForKey:@"status "];
        if ([status isEqualToString:@"0"])
        {
             messageData=[NSString stringWithFormat:@"%@  you have one friend request",userName];
        }
        else
        {
              messageData=[NSString stringWithFormat:@"%@  your friend request accepted",userName];
        }
        
       
    }
        
   
    
        
     NSManagedObjectContext *context = [self managedObjectContext];
     message = [NSEntityDescription insertNewObjectForEntityForName:@"NotificationsData" inManagedObjectContext:context];
        
    [message setValue:messageData forKeyPath:@"message"];
    [message setValue:questionId forKeyPath:@"questionId"];
    [message setValue:value forKeyPath:@"status"];

     NSError *error;
     [context save:&error];
}
    }
    else
    {
        
    }
*/

}




#pragma mark PushNotification


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *deviceTokenValue = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenValue = [deviceTokenValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"%@",deviceTokenValue);
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:deviceTokenValue forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	//NSLog(@"Failed to get token, error: %@", error);
    
     NSString *deviceTokenValue=error.description;
    [[NSUserDefaults standardUserDefaults]setObject:deviceTokenValue forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void) clearNotifications
{
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
 
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     TabBarView=[[TaBBarViewController alloc]init];
     self.navController=[[UINavigationController alloc]initWithRootViewController:TabBarView];
     self.navController.navigationBarHidden = YES;
    
     TabBarView.questionId=@"1";
     TabBarView.notificationViewValue=4;
   // TabBarView.
    
    
    //UpdatesViewController *loginView=[[UpdatesViewController alloc]init];
    
    //self.navController=[[UINavigationController alloc]initWithRootViewController:loginView];
    // self.window.rootViewController=self.navController;

    
  //
   // UpdatesViewController *updatesView=[[UpdatesViewController alloc]init];
    //updatesView.friendID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    //[self.window.rootViewController.navigationController pushViewController:updatesView animated:NO];

    
    self.window.rootViewController=TabBarView;
    //
     //UpdatesViewController *updatesView=[[UpdatesViewController alloc]init];
     //updatesView.friendID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    //[TabBarView.userDetail.navigationController pushViewController:updatesView animated:NO];
   // [TabBarView.userDetail.ContainerRecentCount  ];
    

  

    
    
 
    
    
}
#pragma mark Core Data Methods
- (void)saveContext
{
    NSError *error = nil;
    managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}





- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QboxData" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    return managedObjectModel;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    //return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    // NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"woodyweedsapp.sqlite"];
    NSString *storePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"QboxData.sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    NSError *error = nil;
    
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storePath])
    {
        NSString *defaultStorePath = [[NSBundle mainBundle]
                                      pathForResource:@"QboxData" ofType:@"sqlite"];
        if (defaultStorePath)
        {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    
    
    //
    
    //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil] error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    
    
    
    return persistentStoreCoordinator;
}








- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    NSArray *userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    if (userData)
    {
        if (![[AppDelegate sharedDelegate] pushNotificationFetching])
            [self pushNotificationData];
    }
    
    [self clearNotifications];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(AppDelegate *)sharedDelegate
{
    return  (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(CAKeyframeAnimation *)popupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.2;
    return animation;
}



NSDateFormatter *sDF = nil;
-(NSDateFormatter *)serverDateFormatter
{
    // Date Formatter - with server side date format and server time zone
    
    if (sDF == nil) {
        sDF = [[NSDateFormatter alloc] init];
    }
    
    // 2014-08-22 11:09:46 AM
    
    [sDF setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    [sDF setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Kolkata"]];
    
    return sDF;
}

NSCalendar *clndr = nil;
-(NSCalendar *)calendar
{
    // Curent Calendar Refrence
    if (clndr == nil) {
        clndr = [NSCalendar currentCalendar];
    }
    
    return clndr;
}

-(NSString *)localDateFromDate:(NSString *)serverDate
{
    // Instance of server dateformatter
    NSDateFormatter *dF = [self serverDateFormatter];
    
    
    // Converting string to NSDate object
    NSDate *date = [self getLocalTimeFrom:[dF dateFromString:serverDate]];
    
    
    // Today - Current Date
    NSDate *today = [NSDate date];
    today = [dF dateFromString:[dF stringFromDate:today]];
    
    
    NSString *localDateString = nil;
    [dF setDateFormat:@"dd/MM/yyyy hh:mm a"];
    localDateString=[dF stringFromDate:[self getDateBack:date]];
    
    
//    if ([self compareDateOnly:[self getDateBack:date] otherDate:today] == NSOrderedSame)
//    {
//        // Today's comment
//        // Show it in hourly/min or seconds bases
//        
//        [dF setDateFormat:@"hh:mm a"];
//        localDateString = [dF stringFromDate:[self getDateBack:date]];
//    }
//    else
//    {
//        // Comment was of old day
//        // It might be of Yesterday or Before Yesterday
//        // If day difference is 1 - Yesterday else Before Yesterday
//        
//        [dF setDateFormat:@"dd-MM-yyyy"];
//        localDateString = [dF stringFromDate:date];
//    }
    
    return localDateString;
}

-(NSDate *)getLocalTimeFrom:(NSDate *)GMTTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: GMTTime];
    return [NSDate dateWithTimeInterval: seconds sinceDate: GMTTime];
}

-(NSDate *)getDateBack:(NSDate *)GMTTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: GMTTime];
    return [NSDate dateWithTimeInterval: -seconds sinceDate: GMTTime];
}





- (NSComparisonResult)compareDateOnly:(NSDate *)date otherDate:(NSDate *)otherDate
{
    
    NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *selfComponents = [gregorianCalendar components:dateFlags fromDate:date];
    NSDate *selfDateOnly = [gregorianCalendar dateFromComponents:selfComponents];
    
    NSDateComponents *otherCompents = [gregorianCalendar components:dateFlags fromDate:otherDate];
    NSDate *otherDateOnly = [gregorianCalendar dateFromComponents:otherCompents];
    
    gregorianCalendar = nil;
    
    return [selfDateOnly compare:otherDateOnly];
}

-(UIFont*) fontWithName:(CGFloat)size
{
    return [UIFont fontWithName:@"Avenir" size:size];
}

- (NSString *)statusTextWithStatusID:(NSInteger)statusID{
    switch (statusID) {
        case 0:
            return @"this status text is hardcode";
            break;
        case 1:
            return @"this status text is hardcode";
            break;
        case 2:
            return @"this status text is hardcode";
            break;
        case 3:
            return @"this status text is hardcode";
            break;
        default:
            break;
    }
    
    return @"this status text is hardcode";
}




#pragma mark Activity View
static UIView *activityView = nil;
-(void)showActivityInView:(UIView *)view withBlock:(void (^) (void))successBlock
{
    
    self.activityBlock = successBlock;
    
    if (!self.activityText)
        self.activityText = @"Loading...";
    
    if (activityView == nil) {
        
        // BackgroundView
        activityView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 82.0)];
        [activityView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [[activityView layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[activityView layer] setBorderWidth:1.0];
        [[activityView layer] setCornerRadius:10.0];
        [activityView setClipsToBounds:YES];
        
        // ActivityIndicator
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicator setTag:1];
        [activityView addSubview:indicator];
        
        CGRect rect   = indicator.frame;
        rect.origin.x = (activityView.frame.size.width - rect.size.width)/2.0;
        rect.origin.y = 15.0;
        indicator.frame = rect;
        
        
        rect.size.width  = 100.0;
        rect.size.height = 40.0;
        rect.origin.x    = 0.0;
        rect.origin.y    = CGRectGetHeight(activityView.frame) - (rect.size.height + 5.0);
        
        // Label
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        [label setTag:2];
        [label setText:self.activityText];
        [label setNumberOfLines:0];
        [label setFont:[UIFont boldSystemFontOfSize:13.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [activityView addSubview:label];
    }
    
    
    UILabel *label = (UILabel *)[activityView viewWithTag:2];
    [label setText:self.activityText];
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[activityView viewWithTag:1];
    [indicator startAnimating];
    
    activityView.center = view.center;
    if ([view isKindOfClass:[UITableView class]]) {
        CGRect rect = activityView.frame;
        rect.origin.y -= 60.0;
        activityView.frame = rect;
    }
    
    [view addSubview:activityView];
    [view bringSubviewToFront:activityView];
    
    [self performSelector:@selector(activityDidAppear) withObject:nil afterDelay:0.2];
    
}
-(void)hideActivity {
    
    self.activityText = @"Loading...";
    self.activityBlock = nil;
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[activityView viewWithTag:1];
    [indicator stopAnimating];
    
    [activityView removeFromSuperview];
}

-(void)activityDidAppear {
    if (self.activityBlock) {
        self.activityBlock();
    }
}


@end
