//
//  TubeServerSocketSDK.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeServerSocketSDK.h"
#import "SocketManager.h"

@interface TubeServerSocketSDK ()

@property (nonatomic, strong) SocketManager *socketMgr;

@end

@implementation TubeServerSocketSDK

- (instancetype)initTubeServerSocketSDK
{
    self = [super init];
    if (self) {
        self.socketMgr = [[SocketManager alloc] init];
    }
    return self;
}
    
- (void)acceptClient:(uint16_t)port
{
    [self.socketMgr acceptClient:port];
}
    
- (void)addProcotolListener:(id<SocketBaseDelegate>) delegate
{
    [self.socketMgr addProcotolListener:delegate];
}
    
- (void)removeProcotolListener:(id<SocketBaseDelegate>) delegate
{
    [self.socketMgr removeProcotolListener:delegate];
}
    
- (void)sendData:(GCDAsyncSocket *)sock data:(NSData *)data
{
    [self.socketMgr sendData:sock data:data];
}
    
@end
