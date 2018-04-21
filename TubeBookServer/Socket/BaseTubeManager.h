//
//  BaseTubeManager.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerSocketSDK.h"
#import "ProtocolConst.h"
#import "BaseSocketPackage.h"
#import "DBHelper.h"
#import "TimeUtil.h"
#import "LoginSDK.h"

@interface BaseTubeManager : NSObject <SocketBaseDelegate>

@property (nonatomic, strong) TubeServerSocketSDK *tubeServerSocketSDK;
@property (nonatomic, strong) LoginSDK *loginSDK;

- (instancetype)initBaseTubeManager:(TubeServerSocketSDK *) tubeServerSocketSDK;
// delegate
// - (void)acceptNewClient:(GCDAsyncSocket *)sock;
// - (void)didReadData:(GCDAsyncSocket *)sock didReadData:(NSData *)data protocolName:(NSString *)protocolName;
// - (void)didWriteData:(GCDAsyncSocket *)sock;
// - (void)clientDidDisconnect:(GCDAsyncSocket *)sock;

- (void)openListenerData;
- (void)closeListenerData;
- (GCDAsyncSocket *)getSocketByUserid:(NSString *)uid;
- (NSString *)getUidBySocket:(GCDAsyncSocket *)socket;
- (BOOL)sendNotificationMessageWithreceiveUid:(NSString *)receiveUid
                                   sendSocket:(GCDAsyncSocket *)sendSocket
                                     protocol:(NSString *)protocol
                                       method:(NSString *)method
                                        title:(NSString *)title
                                      content:(NSString *)content;

@end
