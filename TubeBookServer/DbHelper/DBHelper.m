//
//  DBHelper.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/3/2.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DBHelper.h"
#define kLocalHost "localhost"
#define kUserName "root"
#define kUserPass "123456"
#define kDBName "tubebook"

@implementation DBHelper
{
    MYSQL *_myconnect;
}
    
- (instancetype)init
{
    self = [super init];
    if (self) {
        //_myconnect = mysql_init(_myconnect);
    }
    return self;
}
    
+ (instancetype)sharedInstance
{
    static DBHelper *dbHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbHelper = [[DBHelper alloc] init];
    });
    return dbHelper;
}
    
- (MYSQL *)getMyconnection
{
    return _myconnect;
}
    
- (BOOL)connectionDB
{
    if (!_myconnect) {
        _myconnect = mysql_init(_myconnect);
        _myconnect = mysql_real_connect(_myconnect,kLocalHost,kUserName,kUserPass,kDBName,MYSQL_PORT,NULL,0);
        mysql_set_character_set(_myconnect, "utf8");
    }
    if (_myconnect) {
        return YES;
    } else {
        return NO;
    }
}

- (void)disconnectionDB
{
    mysql_close(_myconnect);
    _myconnect = NULL;
}
    
- (int)query:(NSString *)sql
{
    return mysql_query(_myconnect, [sql UTF8String]);
}

- (int)insterWithTable:(NSString *)tableName keys:(NSArray *)keys values:(NSArray *)values
{
    NSString *key = @"";
    for (int i = 0 ; i < keys.count ; ++i) {
        NSString *k = [keys objectAtIndex:i];
        key = [key stringByAppendingString:[NSString stringWithFormat:@"`%@`",k]];
        if ( i != keys.count-1 ) {
            key = [key stringByAppendingString:@","];
        }
    }
    NSString *value = @"";
    for (int i = 0 ; i < values.count ; ++i) {
        if ([[values objectAtIndex:i] isKindOfClass:[NSString class]]) {
            NSString *v = [values objectAtIndex:i];
            value = [value stringByAppendingString:[NSString stringWithFormat:@"'%@'",v]];
        } else {
            CGFloat f = [[values objectAtIndex:i] floatValue];
            NSInteger u = [[values objectAtIndex:i] integerValue];

            if ( (fabs(f)-labs(u)*1.0f)>0 ) {
                value = [value stringByAppendingString:[NSString stringWithFormat:@"%f",[[values objectAtIndex:i] floatValue]]];
            } else {
                value = [value stringByAppendingString:[NSString stringWithFormat:@"%ld",[[values objectAtIndex:i] integerValue]]];
            }
        }
        if ( i != values.count-1 ) {
            value = [value stringByAppendingString:@","];
        }
    }
    NSString *sql= [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@);",tableName,key,value];
    return [self query:sql];
}


// 更新数据
- (int)updateWithTable:(NSString *)tableName keyAndVaule:(NSDictionary *)keyValues where:(NSString *)where
{
    NSString *setV = @"";
    int i=0;
    NSInteger count = keyValues.allKeys.count;
    for (NSString *key in keyValues.allKeys) {
        id value = [keyValues objectForKey:key];
        if (![value isKindOfClass:[NSString class]]) {
            NSInteger v = 0;
            v = [value integerValue];
            setV = [setV stringByAppendingFormat:@" %@ = %lu", key, v];
        } else {
            setV = [setV stringByAppendingFormat:@" %@ = '%@'",key,value];
        }
        if ( i!=count-1 ) {
            setV = [setV stringByAppendingFormat:@","];
        }
        ++i;
    }
    NSString *sql= [NSString stringWithFormat:@"UPDATE %@ set %@ where %@;", tableName, setV, where];
    return [self query:sql];
}

- (int)delectWithTable:(NSString *)tableName where:(NSString *)where
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM `tubebook`.`%@` WHERE %@;", tableName, where];
    return [self query:sql];
}
    
- (MYSQL_RES *)getMysqlRes
{
    return mysql_store_result(_myconnect);
}
    
- (void)freeMysqlRes:(MYSQL_RES *)res
{
    mysql_free_result(res);
}
    
- (NSMutableArray *)fetchQuerySelect:(NSString *)sql tableName:(NSString *)tableName
{
    NSMutableArray *list = nil;
    if (_myconnect) {
        //NSString *filedSql = [NSString stringWithFormat:@"select COLUMN_NAME from information_schema.COLUMNS where table_name = '%@' and table_schema = 'tubebook';",tableName];
        list = [[NSMutableArray alloc] init];
        if (mysql_query(_myconnect, [sql UTF8String])==0) {
            MYSQL_RES *res = [self getMysqlRes];
            MYSQL_ROW row;
            while ((row=mysql_fetch_row(res))) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                //                     for(int i = 0;i<fieldCount;++i){
                //                         for (int j=0; j<res->field_count; ++j) {
                //                             //[fieldList objectAtIndex:i]
                //                         }
                //                        [dic setObject:[NSString stringWithUTF8String:row[i]] forKey: [fieldList objectAtIndex:i]];
                //                     }
                for (int j=0; j<res->field_count; ++j) {
                    //[fieldList objectAtIndex:i]
                    //[dic setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>]
                    if (row[j]) {
                        [dic setValue:[NSString stringWithUTF8String:row[j]] forKey:[NSString stringWithUTF8String:res->fields[j].name]];
                    } else {
                        [dic setValue:@"" forKey:[NSString stringWithUTF8String:res->fields[j].name]];
                    }

                }
                
                [list addObject:dic];
            }
            [self freeMysqlRes:res];
            res = NULL;
        }
//        if (mysql_query(_myconnect, [filedSql UTF8String])==0) {
//            NSMutableArray *fieldList = [[NSMutableArray alloc] init]; // 存储字段名
//            MYSQL_RES *fieldNameRes = [self getMysqlRes];
//            MYSQL_ROW row;
//            int fieldCount = 0;
//            while ((row=mysql_fetch_row(fieldNameRes))) {
//                [fieldList addObject:[NSString stringWithUTF8String:row[0]]];
//                fieldCount ++;
//            }
//            [self freeMysqlRes:fieldNameRes];
//            fieldNameRes = NULL;
//
//            list = [[NSMutableArray alloc] init];
//            if (mysql_query(_myconnect, [sql UTF8String])==0) {
//                MYSQL_RES *res = [self getMysqlRes];
//                 char *field1 = res->fields[0].name;
//                 while ((row=mysql_fetch_row(res))) {
//                     NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
////                     for(int i = 0;i<fieldCount;++i){
////                         for (int j=0; j<res->field_count; ++j) {
////                             //[fieldList objectAtIndex:i]
////                         }
////                        [dic setObject:[NSString stringWithUTF8String:row[i]] forKey: [fieldList objectAtIndex:i]];
////                     }
//                     for (int j=0; j<res->field_count; ++j) {
//                         //[fieldList objectAtIndex:i]
//                          [dic setObject:[NSString stringWithUTF8String:row[j]] forKey:[NSString stringWithUTF8String:res->fields[j].name] ];
//                     }
//
//                     [list addObject:dic];
//                 }
//                [self freeMysqlRes:fieldNameRes];
//                fieldNameRes = NULL;
//            }
//        }
    }
    if (list && list.count==0) {
        list = nil;
    }
    return list;
}
    


@end
