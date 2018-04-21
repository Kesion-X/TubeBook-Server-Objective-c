//
//  BaseProtocolHeader.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolConst.h"

@interface BaseProtocolHeader : NSObject

@property (nonatomic) NSData *headData;
@property (nonatomic) NSString *protocolName;

- (instancetype)initBaseProtocolHeader:(NSData *)headData;
- (NSString *)getProcotolName;

@end
