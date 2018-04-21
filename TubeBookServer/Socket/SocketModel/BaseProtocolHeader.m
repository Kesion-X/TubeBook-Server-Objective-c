//
//  BaseProtocolHeader.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "BaseProtocolHeader.h"

@class NSJSONSerialization;

@implementation BaseProtocolHeader

- (instancetype)initBaseProtocolHeader:(NSData *)headData
{
    self = [super init];
    if (self) {
        self.headData = headData;
    }
    return self;
}

- (NSInteger)getHeadBtLength
{
    return self.headData.length;
}

- (NSString *)getProcotolName
{
    NSString *procotolName = nil;
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.headData options:NSJSONReadingMutableLeaves error:&error];
    if (!error) {
        procotolName = [json objectForKey:PROTOCOL_NAME];
    }
    return procotolName;
}

@end
