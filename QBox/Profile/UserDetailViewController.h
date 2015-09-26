//
//  UserDetailViewController.h
//  QBox
//
//  Created by iApp on 6/20/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"


#define TEXTCOLOR [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0f]

@class ChatController;

@interface UserDetailViewController : UIViewController<ChatControllerDelegate>

@property(strong,nonatomic) NSArray *personalDetailarray;
@property(strong,nonatomic) ChatController *chatController;

@property(strong,nonatomic) NSString *senderId;
@property(strong,nonatomic) NSString *receiverId;
@property(nonatomic) int  messageValue;

@property(strong,nonatomic) NSString *user_id;

-(void) receiveMessage;

@end
