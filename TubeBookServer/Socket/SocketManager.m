//
//  SocketManager.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/2/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "SocketManager.h"
#import "GCDAsyncSocket.h"

#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 10.0

@interface SocketManager () <GCDAsyncSocketDelegate>

@property (strong, nonatomic) NSMutableArray *clientSocket;
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (nonatomic, strong) dispatch_queue_t delegateQueue;
@property (strong, nonatomic) NSMutableArray *procotolListeners;

@end

@implementation SocketManager

- (void)dealloc
{
    for (id<SocketBaseDelegate> delegate in self.procotolListeners) {
        [self.procotolListeners removeObject:delegate];
    }
    self.procotolListeners = nil;
    self.socket.delegate = nil;
}
    
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clientSocket = [[NSMutableArray alloc] init];
        self.procotolListeners = [[NSMutableArray alloc] init];
        _delegateQueue = dispatch_queue_create("com.kesion.tubebook.socket", NULL);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}
    
- (void)acceptClient:(uint16_t)port
{
    NSError *error = nil;
    [self.socket disconnect];
    [self.socket acceptOnPort:port error:&error];
    if (error) {
        NSLog(@"accept error %@",error);
        return ;
    }
    
}
    
- (void)addProcotolListener:(id<SocketBaseDelegate>) delegate
{
    [self.procotolListeners addObject:delegate];
}
    
- (void)removeProcotolListener:(id<SocketBaseDelegate>) delegate
{
    [self.procotolListeners removeObject:delegate];
}
    
- (void)sendData:(GCDAsyncSocket *)sock data:(NSData *)data
{
    [sock writeData:data withTimeout:-1 tag:0];
}
    
    
#pragma mark - private
- (void)dispatchAcceptNewClient:(GCDAsyncSocket *)sock
{
    dispatch_async(self.delegateQueue, ^{
        for (id<SocketBaseDelegate> delegate in self.procotolListeners) {
            if (delegate && [delegate respondsToSelector:@selector(acceptNewClient:)]) {
                [delegate acceptNewClient:sock];
            }
        }
    });
}
    
- (void)dispatchReceiveData:(GCDAsyncSocket *)sock
                 didReadData:(NSData *)data
                protocolName:(NSString *)protocolName;
{
    dispatch_async(self.delegateQueue, ^{
        for (id<SocketBaseDelegate> delegate in self.procotolListeners) {
            if (delegate && [delegate respondsToSelector:@selector(didReadData:didReadData:protocolName:)]) {
                [delegate didReadData:sock didReadData:data protocolName:protocolName];
            }
        }
    });
}
    
- (void)dispatchWriteData:(GCDAsyncSocket *)sock
{
    dispatch_async(self.delegateQueue, ^{
        for (id<SocketBaseDelegate> delegate in self.procotolListeners) {
            if (delegate && [delegate respondsToSelector:@selector(didWriteData:)]) {
                [delegate didWriteData:sock];
            }
        }
    });
}
    
- (void)dispatchClientDidDisconnect:(GCDAsyncSocket *)sock
{
    for (id<SocketBaseDelegate> delegate in self.procotolListeners) {
        if (delegate && [delegate respondsToSelector:@selector(clientDidDisconnect:)]) {
            [delegate clientDidDisconnect:sock];
        }
    }
}
    
#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    // This method is executed on the socketQueue (not the main thread)
    @synchronized(self.clientSocket)
    {
        [self.clientSocket addObject:newSocket];
        [newSocket readDataWithTimeout:-1 tag:0];
        [self dispatchAcceptNewClient:sock];
    }
//    NSString *host = [newSocket connectedHost];
//    UInt16 port = [newSocket connectedPort];

}
    
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // This method is executed on the socketQueue (not the main thread)
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
           // NSLog(@"ddad ee");
//            int i;
//            [data getBytes: &i length: sizeof(i)];
            //NSLog(@"length %d",i);
            NSData *mainData = [NSData dataWithBytes:&data.bytes[4] length:(data.length-4)];
            NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:mainData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *headDic = [dic objectForKey:@"head"];
            NSLog(@"%@ ",dic);
//            NSDictionary *contentDic = [dic objectForKey:@"content"];
//            NSInteger count = [[contentDic objectForKey:@"tagCount"] integerValue];
//            NSLog(@"count %ld",count);
            [self dispatchReceiveData:sock didReadData:mainData protocolName:[headDic objectForKey:@"Protocol-Name"]];
            [sock readDataWithTimeout:-1 tag:0];
        }
    });
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [self dispatchWriteData:sock];
}
    
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (sock != self.socket)
    {
        @synchronized(self.clientSocket)
        {
            [self dispatchClientDidDisconnect:sock];
            [self.clientSocket removeObject:sock];
        }
    }
}
    
@end
