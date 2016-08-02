//
//  IndexBar.h
//  ShopFinder
//
//  Created by iApp1 on 09/10/14.
//  Copyright (c) 2014 iApp1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexBar : UIScrollView
@property(strong,nonatomic)UIButton *indexBarBtn;
@property(nonatomic)int warehouseValue;



-(id)initWithFrame:(CGRect)frame target:(id)target selector:(SEL)sel alphabetArray:(NSMutableArray*)array;



@end
