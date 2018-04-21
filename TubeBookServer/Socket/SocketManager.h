//
//  SocketManager.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/2/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol SocketBaseDelegate <NSObject>

@optional
- (void)acceptNewClient:(GCDAsyncSocket *)sock;
- (void)didReadData:(GCDAsyncSocket *)sock didReadData:(NSData *)data protocolName:(NSString *)protocolName;
- (void)didWriteData:(GCDAsyncSocket *)sock;
- (void)clientDidDisconnect:(GCDAsyncSocket *)sock;

@end;

@interface SocketManager : NSObject
    
- (void)acceptClient:(uint16_t)port;
- (void)addProcotolListener:(id<SocketBaseDelegate>) delegate;
- (void)removeProcotolListener:(id<SocketBaseDelegate>) delegate;
- (void)sendData:(GCDAsyncSocket *)sock data:(NSData *)data;
    
@end
