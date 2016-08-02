//
//  CustomTableViewCell.h
//  QBox
//
//  Created by iApp1 on 09/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushTableViewCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UIImageView *questionImageView;
@property(strong,nonatomic) IBOutlet UILabel *questionLabel;
@property(strong,nonatomic) IBOutlet UIButton *userNameBtn;
@property(strong,nonatomic) IBOutlet UILabel *dateLabel;
@property(strong,nonatomic) IBOutlet UILabel *timeLabel;

@property(strong,nonatomic) IBOutlet UIImageView *dateImageView;
@property(strong,nonatomic) IBOutlet UIImageView *timeImageView;
@property(strong,nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *ReliesLabel;

@property (weak, nonatomic) IBOutlet UIButton *btAccept;

@property (weak, nonatomic) IBOutlet UIButton *btReject;

@property (weak, nonatomic) IBOutlet UILabel *totalAnswersLabel;
@end
