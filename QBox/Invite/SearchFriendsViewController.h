//
//  SearchFriendsViewController.h
//  QBox
//
//  Created by iApp on 6/23/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriendsViewController : UIViewController

@property(strong,nonatomic) NSArray *UserDetailArray;
@property(strong,nonatomic) NSMutableArray *searchData;
@property(nonatomic) int friendsValue;

@property(strong,nonatomic) NSString *searchvalue;

-(void) viewFriends;

@end
