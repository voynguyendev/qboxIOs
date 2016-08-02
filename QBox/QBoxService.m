//
//  QBoxService.m
//  QBox
//
//  Created by Tony Truong on 4/2/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "QBoxService.h"

@implementation QBoxService


+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSInteger errorCode, NSString *errorMessage))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BOOL status = NO;
        
        if (responseObject[@"success"]) {
            status = [responseObject[@"success"] boolValue];
        } else if (responseObject[@"status"]) {
            status = [responseObject[@"status"] boolValue];
        }
                    
        if (status) {
            success(responseObject);
        } else {
            NSString *errorMessage = responseObject[@"message"];
            errorMessage = errorMessage ? errorMessage : @"Invalid JSON format";
            failure(operation, 10000, errorMessage);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error.code, [error localizedDescription]);
    }];
}

@end
