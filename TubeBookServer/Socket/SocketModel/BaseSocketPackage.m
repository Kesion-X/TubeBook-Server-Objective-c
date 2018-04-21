//
//  BaseSocketPage.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "BaseSocketPackage.h"

@implementation BaseSocketPackage

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.data = [[NSMutableData alloc] initWithData:data];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            self.head.headData = [[json objectForKey:@"head"] dataUsingEncoding:NSUTF8StringEncoding];
            self.content.contentData = [[json objectForKey:@"content"] dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return self;
}
    
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [[NSMutableData alloc] init];
    }
    return self;
}
    
- (instancetype)initWithHeadData:(NSData *)headData contentData:(NSData *)contentData
{
    self = [self init];
    if (self) {
        self.head = [[BaseProtocolHeader alloc] initBaseProtocolHeader:headData];
        self.content = [[BaseProtocolContent alloc] initBaseProtocolContent:contentData];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSJSONSerialization JSONObjectWithData:self.head.headData options:NSJSONReadingMutableContainers error:nil], @"head",
                                    [NSJSONSerialization JSONObjectWithData:self.content.contentData options:NSJSONReadingMutableContainers error:nil], @"content", nil];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        int length = [data length];
        NSLog(@"%@ %d",dic,length);
        NSData *lengthData = [NSData dataWithBytes:&length length:sizeof(length)];
        [self.data appendData:lengthData];
        [self.data appendData:data];
    }
    return self;
}
    
- (instancetype)initWithHeadDic:(NSDictionary *)headDic contentDic:(NSDictionary *)contentDic
    {
        self = [self init];
        if (self) {
            
            NSData *contentJsonData = [NSJSONSerialization dataWithJSONObject:contentDic options:NSJSONWritingPrettyPrinted error:nil];
            
            NSData *headJsonData = [NSJSONSerialization dataWithJSONObject:headDic options:NSJSONWritingPrettyPrinted error:nil];
            self = [self initWithHeadData:headJsonData contentData:contentJsonData];
        }
        return self;
    }

@end
