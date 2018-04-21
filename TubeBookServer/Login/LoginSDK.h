//
//  LoginSDK.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/2.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerSocketSDK.h"

@interface LoginSDK : NSObject

- (instancetype)initLoginSDK:(TubeServerSocketSDK *)tubeServerSocketSDK;
- (void)openListenerData;
- (void)closeListenerData;
// 获取某用户socket
- (GCDAsyncSocket *)getSocketByUserid:(NSString *)uid;
- (NSString *)getUserIdBySocket:(GCDAsyncSocket *)socket;
    
@end
