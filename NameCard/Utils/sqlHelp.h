//
//  sqlHelp.h
//  Notebook
//
//  Created by 杨昊 on 12-11-16.
//  Copyright (c) 2012年 EntLib.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface sqlHelp : NSObject{
    
    sqlite3 *m_sql;
    NSString *m_dbName;
    
}

@property(nonatomic)sqlite3*    m_sql;
@property(nonatomic,retain)NSString*    m_dbName;

-(id)initWithDbName:(NSString*)dbname;
-(BOOL)openOrCreateDatabase:(NSString*)DbName;
-(BOOL)openDB;
-(BOOL)createTable:(NSString*)sqlCreateTable;
-(void)closeDatabase;
-(BOOL)InsertTable:(NSString*)sqlInsert;
-(BOOL)InsertTableBatch:(NSString*)sqlInsert;
-(BOOL)UpdataTable:(NSString*)sqlUpdata;
-(BOOL)UpdataTableBatch:(NSString*)sqlUpdata;
-(BOOL)DeleteTableBatch:(NSString*)sqlDelete;
-(int)InsertTableWithID:(NSString *)sqlInsert;
-(NSArray*)querryTable:(NSString*)sqlQuerry;
-(NSArray*)querryTableBatch:(NSString*)sqlQuerry;
-(NSArray*)querryTableByCallBack:(NSString*)sqlQuerry;


@end
