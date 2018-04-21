//
//  BaseSocketPackage.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseProtocolHeader.h"
#import "BaseProtocolContent.h"

@interface BaseSocketPackage : NSObject
//length
//{
//    "head":{},
//    "content":{}
//}
@property (nonatomic, strong) NSMutableData *data;//length, head data, content data
@property (nonatomic) NSInteger length; // header length + content length
@property (nonatomic, strong) BaseProtocolHeader *head;
@property (nonatomic, strong) BaseProtocolContent *content;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithHeadData:(NSData *)headData contentData:(NSData *)contentData;
- (instancetype)initWithHeadDic:(NSDictionary *)headDic contentDic:(NSDictionary *)contentDic;
    
@end
