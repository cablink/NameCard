//
//  sqlHelp.m
//  Notebook
//
//  Created by 杨昊 on 12-11-16.
//  Copyright (c) 2012年 EntLib.com. All rights reserved.
//

#import "sqlHelp.h"

@implementation sqlHelp

@synthesize m_sql;
@synthesize m_dbName;


- (id) initWithDbName:(NSString*)dbname
{
    self = [super init];
    //NSLog(@"%@",dbname);
    if (self != nil) {
        if ([self openOrCreateDatabase:dbname]) {
            [self closeDatabase];
        }
    }
    return self;
}


- (id) init
{
    
    NSAssert(0,@"Never Use this.Please Call Use initWithDbName:(NSString*)");
    return nil;
    
}

- (void) dealloc
{
    [self closeDatabase];
    self.m_sql = nil;
    self.m_dbName =nil;
    
}


//-------------------创建数据库-------------------------

-(BOOL)openOrCreateDatabase:(NSString*)dbName
{
    self.m_dbName = dbName;
    NSArray *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    //[documentsDirectory ]
    NSString *f_name = [documentsDirectory stringByAppendingPathComponent:dbName];
    if(sqlite3_open([[documentsDirectory stringByAppendingPathComponent:dbName]UTF8String],&m_sql) !=SQLITE_OK)
    {
        NSLog(@"openOrCreateDatabase error:%@",f_name);
        return    NO;
    }else
        //NSLog(@"dbPath:%@",f_name);
    return YES;
}

-(BOOL)openDB
{
    return [self openOrCreateDatabase:self.m_dbName];
}
//------------------创建表----------------------

-(BOOL)createTable:(NSString*)sqlCreateTable
{
    if (![self openOrCreateDatabase:self.m_dbName]) {
        return NO;
    }
    char *errorMsg;
    if (sqlite3_exec (self.m_sql, [sqlCreateTable UTF8String],NULL,NULL, &errorMsg) != SQLITE_OK)
    {
        NSLog(@"CreateTable error:%s",errorMsg);
        sqlite3_free(errorMsg);
        return NO;
    }
    [self closeDatabase];
    return YES;
    
}

//----------------------关闭数据库-----------------
-(void)closeDatabase
{
    sqlite3_close(self.m_sql);
}


//------------------insert-------------------

-(BOOL)InsertTable:(NSString*)sqlInsert
{
    BOOL ret = NO;
    if (![self openOrCreateDatabase:self.m_dbName]) {
        return ret;
    }
    ret = [self InsertTableBatch:sqlInsert];
    [self closeDatabase];
    return ret;
}


-(BOOL)InsertTableBatch:(NSString*)sqlInsert
{
    char* errorMsg = NULL;
    if(sqlite3_exec(self.m_sql, [sqlInsert UTF8String],0,NULL, &errorMsg) == SQLITE_OK)
    {
        
        return YES;
    }
    else {
        NSLog(@"InsertTable error:%@",sqlInsert);
        printf("InsertTable errMsg:%s",errorMsg);
        sqlite3_free(errorMsg);
        return NO;
    }
    return YES;
}
-(int)InsertTableWithID:(NSString *)sqlInsert
{
    int r=0;
    if (![self openOrCreateDatabase:self.m_dbName]) {
        return -1;
    }
    char* errorMsg = NULL;
    if(sqlite3_exec(self.m_sql, [sqlInsert UTF8String],0,NULL, &errorMsg) == SQLITE_OK)
    {
        r = sqlite3_last_insert_rowid(self.m_sql);
        [self closeDatabase];
        NSLog(@"Rowid is %i",r);
    }
    else {
        NSLog(@"InsertTable error:%@",sqlInsert);
        printf("InsertTable errMsg:%s",errorMsg);
        sqlite3_free(errorMsg);
        [self closeDatabase];
        
    }
    return r;
}
//--------------updata-------------

-(BOOL)UpdataTable:(NSString*)sqlUpdata{
    
    BOOL ret=NO;
    if (![self openOrCreateDatabase:self.m_dbName]) {
        
        return ret;
        
    }
    ret = [self UpdataTableBatch:sqlUpdata];
    [self closeDatabase];
    return ret;
}

-(BOOL)UpdataTableBatch:(NSString*)sqlUpdata{
    char *errorMsg;
    
    if (sqlite3_exec (self.m_sql, [sqlUpdata UTF8String],0,NULL, &errorMsg) ==SQLITE_OK)        
    {
        return YES;
        
    }else {
        NSLog(@"UpdateTable error:%@",sqlUpdata);
        printf("UpdateTable errMsg:%s",errorMsg);
        sqlite3_free(errorMsg);
        return NO;
    }
    return YES;
}


-(BOOL)DeleteTableBatch:(NSString*)sqlDelete{
    char *errorMsg;
    
    if (sqlite3_exec (self.m_sql, [sqlDelete UTF8String],0,NULL, &errorMsg) ==SQLITE_OK)
    {
        return YES;
        
    }else {
        NSLog(@"DeleteTable error:%@",sqlDelete);
        printf("UpdateTable errMsg:%s",errorMsg);
        sqlite3_free(errorMsg);
        return NO;
    }
    return YES;
}

//--------------select---------------------

-(NSArray*)querryTable:(NSString*)sqlQuery

{
    
    if (![self openOrCreateDatabase:self.m_dbName]) {
        
        return nil;
        
    }
 /*
    int row = 0;
    
    int column = 0;
    
    char*    errorMsg = NULL;
    
    char**    dbResult = NULL;
    
    NSMutableArray*    array = [[NSMutableArray alloc]init];
   
    if(sqlite3_get_table(m_sql, [sqlQuery UTF8String], &dbResult, &row,&column,&errorMsg ) ==SQLITE_OK)
        
    {
        
        if (0 == row) {
            
            [self closeDatabase];
            
            return nil;
            
        }
        
        int index = column;
        for(int i =0; i < row ; i++ ) {
            NSMutableDictionary*    dic = [[NSMutableDictionary alloc]init];
            for(int j =0 ; j < column; j++ ) {
                if (dbResult[index]) {
                    NSString*    value = [[NSString alloc]initWithUTF8String:dbResult[index]];
                    NSString*    key = [[NSString alloc]initWithUTF8String:dbResult[j]];
                    [dic setObject:value forKey:key];
                }
                index ++;
            }
            [array addObject:dic];
        }
        sqlite3_free_table(dbResult);
        
    }else {
        NSLog(@"queryTable error:%s",errorMsg);
        sqlite3_free(errorMsg);
        [self closeDatabase];
        return nil;
    }
  
  */
    
    NSArray *array = [self querryTableBatch:sqlQuery];
    [self closeDatabase];
    return array;
}

-(NSArray*)querryTableBatch:(NSString*)sqlQuery

{
    
    /*
    int row = 0;
    
    int column = 0;
    
    char*    errorMsg = NULL;
    
    char**    dbResult = NULL;
    
    NSMutableArray*    array = [[NSMutableArray alloc]init];

    if(sqlite3_get_table(m_sql, [sqlQuery UTF8String], &dbResult, &row,&column,&errorMsg ) ==SQLITE_OK)
        
    {
        
        if (0 == row) {
            
            
            
            return nil;
            
        }
        
        int index = column;
        for(int i =0; i < row ; i++ ) {
            NSMutableDictionary*    dic = [[NSMutableDictionary alloc]init];
            for(int j =0 ; j < column; j++ ) {
                if (dbResult[index]) {
                    NSString*    value = [[NSString alloc]initWithUTF8String:dbResult[index]];
                    NSString*    key = [[NSString alloc]initWithUTF8String:dbResult[j]];
                    [dic setObject:value forKey:key];
                }
                index ++;
            }
            [array addObject:dic];
        }
        sqlite3_free_table(dbResult);
    }else {
        NSLog(@"queryTableBatch error:%s",errorMsg);
        sqlite3_free(errorMsg);
        return nil;
    }
    */
    
    sqlite3_stmt *stmt;
    NSMutableArray*    array = [[NSMutableArray alloc]init];
    int result = sqlite3_prepare_v2(m_sql, [sqlQuery UTF8String], -1, &stmt, NULL);
    if(SQLITE_OK == result)
    {
        int num = sqlite3_column_count(stmt);
        
        //NSLog(@"num:%i",num);
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            int count = sqlite3_data_count(stmt);
            //NSLog(@"colume:%i",count);
            NSMutableDictionary*    dic = [[NSMutableDictionary alloc]init];
            for(int i = 0;i<count;i++)
            {
                
                NSString*    value = [[NSString alloc]initWithUTF8String:sqlite3_column_text(stmt,i)];
                NSString*    key = [[NSString alloc]initWithUTF8String:sqlite3_column_name(stmt,i)];
                [dic setObject:value forKey:key];
                //NSLog(@"key:%@  value:%@",key,value);
            }
            [array addObject:dic];
        }
        sqlite3_finalize(stmt);
    }else{
        sqlite3_finalize(stmt);
        NSLog(@"Error");
    }
    return array;
}

@end
