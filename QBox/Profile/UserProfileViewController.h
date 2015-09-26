//
//  UserProfileViewController.h
//  QBox
//
//  Created by Tony Truong on 4/3/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextView *tvStatusText;

@property (strong, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *acceptedQuestionCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *recentQuestionCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *savedQuestionCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *postedQuestionCountLabel;
@property (weak, nonatomic) IBOutlet UIView *ContainerRecentCount;
@property (weak, nonatomic) IBOutlet UIView *ContainerSaveCount;
@property (weak, nonatomic) IBOutlet UIView *ContainerAcceptedCount;

@property(strong,nonatomic) NSString *Indexredirect;


@property (weak, nonatomic) IBOutlet UIView *ContainerMessageCount;

- (IBAction)settingButtonTapped:(id)sender;
- (IBAction)faqButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;
- (IBAction)recentQuestionsButtonTapped:(id)sender;
- (IBAction)savedQuestionsButtonTapped:(id)sender;
- (IBAction)acceptedQuestionsButtonTapped:(id)sender;
- (IBAction)postedQuestionsButtonTapped:(id)sender;
- (IBAction)chatButtonTapped:(id)sender;

- (IBAction)ViewProfile:(id)sender;


- (IBAction)SaveStatusText:(id)sender;

@end
