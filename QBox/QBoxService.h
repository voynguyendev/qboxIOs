//
//  QBoxService.h
//  QBox
//
//  Created by Tony Truong on 4/2/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface QBoxService : NSObject

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSInteger errorCode, NSString *errorMessage))failure;

@end
