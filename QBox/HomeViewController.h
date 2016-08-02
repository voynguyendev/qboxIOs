//
//  HomeViewController.h
//  QBox
//
//  Created by iapp on 26/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic) int nameValue;
@property(nonatomic) int notificationsViewValue;
@property(strong,nonatomic) NSString *notificationQuesId;
@property(strong,nonatomic) NSString *friendID;

-(void)navigateToGenralQuestion;
@end
