//
//  ProjectHelper.m
//  EventBustMaster
//
//  Created by Vakul on 23/09/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "ProjectHelper.h"

@implementation ProjectHelper

+(ProjectHelper *)shared {
    static ProjectHelper *_helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _helper = [[ProjectHelper alloc] init];
        
        // Screen Size
        _helper.screenSize = [UIScreen mainScreen].bounds.size;
        
        // iosVersion
        _helper.iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        // Device Type
        switch ((NSInteger)(_helper.screenSize.height)) {
            case 480:
                _helper.device = iPHONE_4;
                break;
            case 568:
                _helper.device = iPHONE_5;
                break;
            case 667:
                _helper.device = iPHONE_6;
                break;
            case 736:
                _helper.device = iPHONE_6Plus;
                break;
            default:
                break;
        }
    });
    
    return _helper;
}


#pragma mark - ----------- Availability ----------
#pragma mark - Internet
+(BOOL)internetAvailable {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *) &zeroAddress);
    
    if(reachability != NULL)
    {
        // NetworkStatus retVal = NotReachable
        SCNetworkReachabilityFlags flags;
        
        if(SCNetworkReachabilityGetFlags(reachability, &flags))
        {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                // then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;

}


#pragma mark - Photo Gallery + Camera
+(BOOL)photoGalleryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+(BOOL)cameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


#pragma mark - Font Size
-(UIFont *)applicationFontWithSize:(CGFloat)fontSize bold:(BOOL)bold {
    if (bold)
        return [UIFont boldSystemFontOfSize:fontSize];
    else
        return [UIFont systemFontOfSize:fontSize];
}


@end
