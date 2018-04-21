//
//  DBHelper.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/2.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mysql.h"

@interface DBHelper : NSObject

+ (instancetype)sharedInstance;
// 获取mysql对象
- (MYSQL *)getMyconnection;
// 连接数据库，并返回连接结果
- (BOOL)connectionDB;
// 断开数据库连接
- (void)disconnectionDB;
// 使用数据库查询语句，并返回int，0代表查询成功
- (int)query:(NSString *)sql;
// 插入数据
- (int)insterWithTable:(NSString *)tableName keys:(NSArray *)keys values:(NSArray *)values;
// 删除某数据
- (int)delectWithTable:(NSString *)tableName where:(NSString *)where;
// 更新数据
- (int)updateWithTable:(NSString *)tableName keyAndVaule:(NSDictionary *)keyValues where:(NSString *)where;
// 返回数据查询的结果集
- (MYSQL_RES *)getMysqlRes;
// 释放结果集
- (void)freeMysqlRes:(MYSQL_RES *)res;
// 多功能查询，返回一个结果集，每个item是一个字典可以用字段名或取值
- (NSMutableArray *)fetchQuerySelect:(NSString *)sql tableName:(NSString *)tableName;
    
@end
