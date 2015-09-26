//
//  SPHBubbleCellOther.h
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPHChatData.h"


@interface SPHBubbleCellOther : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Avatar_Image;
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusindicator;

@property(strong,nonatomic) IBOutlet UILabel *date_Label;
@property(strong,nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;



-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;

@end
