//
//  QboxData.h
//  QBox
//
//  Created by iApp on 6/27/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QboxData : NSManagedObject

@property (nonatomic, retain) NSString * receiverId;
@property (nonatomic, retain) NSString * senderId;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * status;

@end
