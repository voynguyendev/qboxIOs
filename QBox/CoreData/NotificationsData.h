//
//  NotificationsData.h
//  QBox
//
//  Created by iApp on 28/07/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NotificationsData : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * questionId;
@property (nonatomic, retain) NSString * status;

@end
