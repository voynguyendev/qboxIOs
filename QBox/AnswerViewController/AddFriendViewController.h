//
//  AddFriendViewController.h
//  QBox
//
//  Created by iApp1 on 16/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) IBOutlet UIView *contentView;
@property(strong,nonatomic) IBOutlet UITableView *contentTableView;

@property(strong,nonatomic) IBOutlet UIImageView *userImageView;
@property(strong,nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong,nonatomic) IBOutlet UILabel *userStatusLabel;
@property(strong,nonatomic) IBOutlet UILabel *numberOfFollowLabel;
@property(strong,nonatomic) IBOutlet UILabel *numberOfFollowersLabel;

@property(strong,nonatomic) IBOutlet UIButton *postsButton;
@property(strong,nonatomic) IBOutlet UIButton *acceptedAnswersButton;
@property(strong,nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *btmessage;

@property (weak, nonatomic) IBOutlet UIButton *btfollow;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;


@property(strong,nonatomic) NSString *friendUserId;
@property (strong, nonatomic) IBOutlet UILabel *lbltitle;

@end
