//
//  BaseTubeManager.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "BaseTubeManager.h"

@implementation BaseTubeManager

- (instancetype)initBaseTubeManager:(TubeServerSocketSDK *) tubeServerSocketSDK
{
    self = [super init];
    if (self) {
        self.tubeServerSocketSDK = tubeServerSocketSDK;
    }
    return self;
}

- (void)openListenerData
{
    if (self.tubeServerSocketSDK) {
        [self.tubeServerSocketSDK addProcotolListener:self];
    }
}

- (void)closeListenerData
{
    if (self.tubeServerSocketSDK) {
        [self.tubeServerSocketSDK removeProcotolListener:self];
    }
}

- (GCDAsyncSocket *)getSocketByUserid:(NSString *)uid
{
    GCDAsyncSocket *socket;
    if (self.loginSDK) {
        socket = [self.loginSDK getSocketByUserid:uid];
    }
    return socket;
}

- (NSString *)getUidBySocket:(GCDAsyncSocket *)socket
{
    NSString *uid;
    if (self.loginSDK) {
        uid = [self.loginSDK getUserIdBySocket:socket];
    }
    return uid;
}

- (BOOL)sendNotificationMessageWithreceiveUid:(NSString *)receiveUid
                                   sendSocket:(GCDAsyncSocket *)sendSocket
                                     protocol:(NSString *)protocol
                                       method:(NSString *)method
                                        title:(NSString *)title
                                      content:(NSString *)content
{
    if (self.loginSDK) {
        GCDAsyncSocket *receiveSocket = [self getSocketByUserid:receiveUid];
        NSString *uid = [self getUidBySocket:sendSocket];
        if ( !receiveSocket || !uid || (receiveUid == uid) ) {
            return NO;
        }
        NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"success",@"status",
                                    receiveUid,@"receive_uid",
                                    uid,@"send_uid",
                                    title,@"title",
                                    content,@"content",
                                    @([TimeUtil getNowTimeTimest]),@"time",nil];
        NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 protocol, PROTOCOL_NAME,
                                 method,PROTOCOL_METHOD,
                                 nil];
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
        [self.tubeServerSocketSDK sendData:receiveSocket data:pg.data];
        return YES;
    }
    return NO;
}

@end

