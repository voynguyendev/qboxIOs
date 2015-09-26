//
//  TaBBarViewController.h
//  QBox
//
//  Created by iapp on 26/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "PostQuestionDetailViewController.h"
#import "PostquestionViewController.h"
#import "InviteViewController.h"
#import "FriendListViewController.h"
#import "UserDetailViewController.h"
#import "SearchFriendsViewController.h"
#import "TopicViewController.h"
#import "UserProfileViewController.h"


@interface TaBBarViewController : UIViewController
@property(nonatomic,strong)TopicViewController *homeVC;
@property(nonatomic,strong)PostQuestionViewController  *postquestionVC;
@property(strong,nonatomic) PostQuestionDetailViewController *profileVC;
@property(strong,nonatomic) InviteViewController *inviteVC;
@property(strong,nonatomic) FriendListViewController *friendListVC;
@property(strong,nonatomic) UserProfileViewController *userDetail;
@property(strong,nonatomic) SearchFriendsViewController *searchFriends;
@property(nonatomic) int nameValue;
@property(nonatomic) int notificationViewValue;
@property(strong,nonatomic) NSString *questionId;

-(void)selectTab :(int)value;

- (void)gotoFriendProfileScreenWithFriendID:(NSString *)friendID;

@end
