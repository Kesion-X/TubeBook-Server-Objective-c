//
//  TubeServerSocketSDK.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketManager.h"
#import "GCDAsyncSocket.h"

@protocol TubeServerDeletage <SocketBaseDelegate>

@end

@interface TubeServerSocketSDK : NSObject
    
- (instancetype)initTubeServerSocketSDK;
- (void)acceptClient:(uint16_t)port;
- (void)addProcotolListener:(id<SocketBaseDelegate>) delegate;
- (void)removeProcotolListener:(id<SocketBaseDelegate>) delegate;
- (void)sendData:(GCDAsyncSocket *)sock data:(NSData *)data;
    
@end
