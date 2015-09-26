//
//  SPHBubbleCell.h
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPHChatData.h"

@interface SPHBubbleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Avatar_Image;

@property (weak, nonatomic) IBOutlet UILabel *time_Label;

@property (strong,nonatomic) IBOutlet UILabel *date_Label;

@property (strong,nonatomic) IBOutlet UILabel *name_Label;

@property(strong,nonatomic) IBOutlet UIImageView *timeImageView;

@property(strong,nonatomic) IBOutlet UIImageView *dateImageView;

-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;

@end
