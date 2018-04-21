//
//  TubeSDK.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerSocketSDK.h"
#import "LoginSDK.h"

@interface TubeSDK : NSObject

@property (nonatomic, strong) TubeServerSocketSDK *tubeServerSocketSDK;
@property (nonatomic, strong) LoginSDK *loginSDK;

+ (instancetype)sharedInstance;
    
@end
