//
//  SqlMB.m
//  Checker
//
//  Created by Zorro on 14/01/2011.
//  Copyright 2011 eHealthInsurance Services Inc. All rights reserved.
//

#import "SqlMB.h"
//#import "Helper.h"
#import "Config.h"
//#import "NSData.h"
//#import "Base64.h"
#import "DosingBean.h"
#import "CardiologyBean.h"

static sqlite3 *database = nil;


@implementation SqlMB
static SqlMB *instance;  //sigletone object

+ (SqlMB *)getInstance {
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
    //    [Helper LogMessage:DATABASE_PATH rank:RANK_LOW];
	return instance;
}
#pragma mark -
#pragma mark managerment function

//init the sqlmb object
-(id)init{
	if (self==[super init]) {
		//init the database
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        DATABASE_PATH = [documentsDirectory stringByAppendingPathComponent:@"users.sqlite"];
        NSLog(@"%s, the db path is %@",__func__,DATABASE_PATH);
		if(sqlite3_open([DATABASE_PATH UTF8String], &database) != SQLITE_OK) {
			//open the database failed close it
            NSLog(@"%s, the db path is %@",__func__,DATABASE_PATH);
			sqlite3_close(database);
			[self customThrowException:@"Error: open database file."];
			return nil;
		}
	}
	return self;
}
//return the int column
-(NSInteger)intForColumnOfStatement:(sqlite3_stmt*)statement _colum:(NSInteger)_colum{
	return sqlite3_column_int(statement, _colum);
}
-(CGFloat)floatForColumnOfStatement:(sqlite3_stmt*)statement _colum:(NSInteger)_colum{
	//NSLog(@"××××%f×××××",sqlite3_column_double(statement, _colum));
	return sqlite3_column_double(statement, _colum);
}
//return the string colum
-(NSString*)stringForColumnOfStatement:(sqlite3_stmt*)statement _colum:(NSInteger)_colum{
	if (sqlite3_column_text(statement, _colum)) {
		char *_colum_value = (char*)sqlite3_column_text(statement, _colum);
		return [NSString stringWithUTF8String:_colum_value];
	}else {
		return nil;
	}
    
}

//return the bool value from the database
-(BOOL)boolForColumnOfStatement:(sqlite3_stmt*)statement _colum:(NSInteger)_colum{
	if (sqlite3_column_int(statement, _colum)) {
		NSInteger values = sqlite3_column_int(statement, _colum);
		if (values==0) {
			return NO;
		}else {
			return YES;
		}
	}
	return NO;
}
/*
 *the cutomsize thro exception method
 */
-(void)customThrowException:(NSString *)error{
	NSLog(@"%@",error);
	//[NSException raise:NSGenericException format:@"Error: open database file."];
}

/*
 *release the objects
 */
-(void)dealloc{
	//[db close];
	sqlite3_close(database);
	database = nil;
	[super dealloc];
}

-(CGFloat) getDBVersion
{
    CGFloat versionNum = 0.0f;
    NSString *versionStr = @"";
    sqlite3_stmt * statements=nil;
	static char *sql = "select version from Version WHERE id=1";
	if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
        //        [self newDB];
        versionNum = 0.0;
	}else {
        //        NSString *_version = @"";
        if (sqlite3_step(statements) == SQLITE_ROW){
            if (sqlite3_column_text(statements, 0)) {
                versionNum = [self floatForColumnOfStatement:statements _colum:0];
            }
        }
        
        sqlite3_finalize(statements);
        statements = nil;
    }
    //    versionStr = [NSString stringWithFormat:@"%.0f",versionNum];
    //    return versionStr;
    return versionNum;
}

-(BOOL)alterDBWithAddColumn
{
    BOOL alterSuccess = YES;
    /*
    // add sortchapter to qiz
    sqlite3_stmt * statementsUpFTouchChapter=nil;
    if (statementsUpFTouchChapter == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'fTouch_chapter' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statementsUpFTouchChapter, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statementsUpFTouchChapter) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statementsUpFTouchChapter);
        statementsUpFTouchChapter = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statementsUpFtouchAll=nil;
    if (statementsUpFtouchAll == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'fTouch_all' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statementsUpFtouchAll, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statementsUpFtouchAll) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statementsUpFtouchAll);
        statementsUpFtouchAll = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements1=nil;
    if (statements1 == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'sort_chapter' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements1, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements1) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements1);
        statements1 = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements2=nil;
    if (statements2 == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'index_chapter' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements2, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements2) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements2);
        statements2 = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements3=nil;
    if (statements3 == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'sort_all' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements3, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements3) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements3);
        statements3 = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements4=nil;
    if (statements4 == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'index_all' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements4, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements4) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements4);
        statements4 = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements5=nil;
    if (statements5 == nil) {
		char *sql;
        sql = "ALTER TABLE flashcard ADD COLUMN 'sort_chapter' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements5, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements5) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements5);
        statements5 = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements6=nil;
    if (statements6 == nil) {
		char *sql;
        sql = "ALTER TABLE flashcard ADD COLUMN 'index_chapter' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements6, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements6) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements6);
        statements6 = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements7=nil;
    if (statements7 == nil) {
		char *sql;
        sql = "ALTER TABLE flashcard ADD COLUMN 'sort_all' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements7, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements7) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements7);
        statements7 = nil;
        alterSuccess = YES;
    }
    sqlite3_stmt * statements8=nil;
    if (statements8 == nil) {
		char *sql;
        sql = "ALTER TABLE flashcard ADD COLUMN 'index_all' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements8, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements8) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements8);
        statements8 = nil;
        alterSuccess = YES;
    }
    
    sqlite3_stmt * statements9=nil;
    if (statements9 == nil) {
		char *sql;
        sql = "ALTER TABLE quizScore ADD COLUMN 'correctqiz' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements9, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements9) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements9);
        statements9 = nil;
        alterSuccess = YES;
    }
    
    sqlite3_stmt * statements10=nil;
    if (statements10 == nil) {
		char *sql;
        sql = "ALTER TABLE quizScore ADD COLUMN 'doneqiz' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements10, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements10) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements10);
        statements10 = nil;
        alterSuccess = YES;
    }
    
    sqlite3_stmt * statements11=nil;
    if (statements11 == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'resultid_chapter' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements11, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements11) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements11);
        statements11 = nil;
        alterSuccess = YES;
    }
    
    sqlite3_stmt * statements12=nil;
    if (statements12 == nil) {
		char *sql;
        sql = "ALTER TABLE quiz ADD COLUMN 'resultid_all' INTEGER DEFAULT 0";
        if (sqlite3_prepare_v2(database, sql, -1, &statements12, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            if (sqlite3_step(statements12) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"success to alter");
            }
        }
        sqlite3_finalize(statements12);
        statements12 = nil;
        alterSuccess = YES;
    }
    */
    return alterSuccess;
}

-(BOOL)shouldContinueForQuiz:(NSInteger)_chpaterId
{
    BOOL shouldContinue = YES;
    sqlite3_stmt * statements = nil;
    NSString *sqlStr = @"";
//    if (_chpaterId == 0) {
    sqlStr = [NSString stringWithFormat:@"select id from quizHistoryrecoder where chapter_id = %d",_chpaterId];
//    } else {
//        
//    }
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        return NO;
    } else {
        if (sqlite3_step(statements) != SQLITE_ERROR) {
            NSInteger indexNum = [self intForColumnOfStatement:statements _colum:0];
            
            if (indexNum == 0) {
                shouldContinue = NO;
            } else {
                shouldContinue = YES;
            }
        } else {
            NSLog(@"err is %s",sqlite3_errmsg(database));
            shouldContinue = NO;
        }
//        while(sqlite3_step(statements) == SQLITE_ROW){
//            //            NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
//
//        }
    }
    sqlite3_finalize(statements);
    statements = nil;
    NSLog(@"%s, the should continue is %d",__func__,shouldContinue);
    return shouldContinue;
}

-(BOOL)clearProcessForQuiz:(NSInteger)_chapterId
{
    BOOL clearSuccess = YES;
    sqlite3_stmt *statements = nil;
    NSString *sqlStr = @"";
    sqlStr = [NSString stringWithFormat:@"delete from quizHistoryrecoder where chapter_id = %d",_chapterId];
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    } else {
        if (sqlite3_step(statements) != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
        } else {
            NSLog(@"delete success");
        }
    }
    NSLog(@"%s, the string is %@",__func__,sqlStr);
    return clearSuccess;
}

-(BOOL)saveProcessForQuiz:(NSInteger)_chapterId Sequence:(NSString *)quizSequence CorrectNum:(NSInteger)correctNum DoneNum:(NSInteger)doneNum isFirstTouch:(BOOL)isFT isFinished:(BOOL)isFin ChapterName:(NSString *)c_Name CurrentIndex:(NSInteger)currentIndex
{
    BOOL execSuccess = YES;
    sqlite3_stmt * statements = nil;
    NSString *sqlStr = @"";
    if ([self shouldContinueForQuiz:_chapterId]) {
        // update the db
        sqlStr = [NSString stringWithFormat:@"update quizHistoryrecoder set chapter_sequence = '%@', right_amount = %d, done_amount = %d, first_touch = %d, chapter_name = '%@', current_index = %d where chapter_id = %d",quizSequence, correctNum, doneNum, isFT, c_Name, currentIndex, _chapterId];
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            execSuccess = NO;
        } else {
            if (sqlite3_step(statements) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"****** success to update");
            }
        }
    } else {
        // insert a process to db
        sqlStr = [NSString stringWithFormat:@"INSERT INTO quizHistoryrecoder(chapter_id,chapter_sequence,right_amount,done_amount,first_touch,chapter_name,current_index) VALUES(?, ?, ?, ?, ?, ?, ?)"];
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            sqlite3_bind_int(statements, 1, _chapterId);
            sqlite3_bind_text(statements, 2, [quizSequence UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statements, 3, correctNum);
            sqlite3_bind_int(statements, 4, doneNum);
            sqlite3_bind_int(statements, 5, isFT);
            sqlite3_bind_text(statements, 6, [c_Name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statements, 7, currentIndex);
            if (sqlite3_step(statements) != SQLITE_ERROR) {
                execSuccess = YES;
            } else {
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                execSuccess = NO;
            }
        }
    }
    sqlite3_finalize(statements);
    statements = nil;
    NSLog(@"%s, the string is %@",__func__,sqlStr);
    return execSuccess;
}

-(BOOL)getLastProcessForQuiz:(NSMutableArray *)arrayQuiz OriQuiz:(NSMutableDictionary *)quizOri chapter:(NSInteger)chapter QuizStatus:(NSMutableDictionary *)dataDic
{
    BOOL execSuccess = YES;
    if ([arrayQuiz count] != 0) {
        [arrayQuiz removeAllObjects];
    }
    if ([quizOri count] != 0) {
        [quizOri removeAllObjects];
    }
    sqlite3_stmt * queryQiz_statements = nil;
    if (queryQiz_statements == nil) {
        NSString *sqlQuizStr = @"";
        if (chapter == 0) {
            sqlQuizStr = [NSString stringWithFormat:@"select id, question, chapter,rightanswer,wronganswer1,wronganswer2,wronganswer3,wronganswer4, wronganswer5,explanation,bookmark from quiz"];
        } else {
            sqlQuizStr = [NSString stringWithFormat:@"select id, question, chapter,rightanswer,wronganswer1,wronganswer2,wronganswer3,wronganswer4, wronganswer5,explanation,bookmark from quiz WHERE chapter=%d",chapter];
        }
        if (sqlite3_prepare_v2(database, [sqlQuizStr UTF8String], -1, &queryQiz_statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        }
        else{
			if (chapter!= 0) {
				sqlite3_bind_int(queryQiz_statements, 1, chapter);
			}
			NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:10];
			while(sqlite3_step(queryQiz_statements) == SQLITE_ROW){
				QuizBean *quizBean = [[QuizBean alloc] init];
				quizBean.quizID = sqlite3_column_int(queryQiz_statements, 0);
			    if (sqlite3_column_text(queryQiz_statements, 1)) {
					quizBean.question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 1)];
				}else {
					quizBean.question = @"";
				}
				quizBean.chapter = sqlite3_column_int(queryQiz_statements, 2);
				
				NSMutableArray *answers = [[NSMutableArray alloc] init];
				if (sqlite3_column_text(queryQiz_statements, 3)) {   //rightanswer
					[answers addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 3)]];
				}
				if (sqlite3_column_text(queryQiz_statements, 4)) {   //wronganswer1
					NSString *wronganswer1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 4)];
					if (![wronganswer1 isEqualToString:@""]) {
						[answers addObject:wronganswer1];
					}
				}
				if (sqlite3_column_text(queryQiz_statements, 5)) {   //wronganswer2
					NSString *wronganswer2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 5)];
					if (![wronganswer2 isEqualToString:@""]) {
						[answers addObject:wronganswer2];
					}
				}
				if (sqlite3_column_text(queryQiz_statements, 6)) {   //wronganswer3
					NSString *wronganswer3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 6)];
					if (![wronganswer3 isEqualToString:@""]) {
						[answers addObject:wronganswer3];
					}
				}
				if (sqlite3_column_text(queryQiz_statements, 7)) {   //wronganswer4
					NSString *wronganswer4 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 7)];
					if (![wronganswer4 isEqualToString:@""]) {
						[answers addObject:wronganswer4];
					}
				}
				if (sqlite3_column_text(queryQiz_statements, 8)) {   //wronganswer5
					NSString *wronganswer5 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 8)];
					if (![wronganswer5 isEqualToString:@""]) {
						[answers addObject:wronganswer5];
					}
				}
				quizBean.answers = answers;
				
				if (sqlite3_column_text(queryQiz_statements, 9)) {
					quizBean.explanation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryQiz_statements, 9)];
				}else {
					quizBean.explanation = @"";
				}
				
				quizBean.b_bookmark = sqlite3_column_int(queryQiz_statements, 10);
				
				[tempArr addObject:quizBean];
                
                if(answers.count > 0)
                {
                    [quizOri setValue:[answers objectAtIndex:0] forKey:[NSString stringWithFormat:@"%d", quizBean.quizID]];
                }
                
				
				[quizBean release];
			}
            
			sqlite3_finalize(queryQiz_statements);
			queryQiz_statements = nil;
            sqlite3_stmt *statement = nil;
            NSString *sqlStr = @"";
            sqlStr = [NSString stringWithFormat:@"select chapter_sequence,right_amount,done_amount,first_touch,current_index from quizHistoryrecoder where chapter_id=%d",chapter];
            if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, NULL)!=SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
                return NO;
            }
            if (sqlite3_step(statement)!=SQLITE_ERROR) {
                NSString *sequenceStr = [self stringForColumnOfStatement:statement _colum:0];
                //init the quiz array
                NSArray *sortedArr = [sequenceStr componentsSeparatedByString:@","];

                for (int i = 0; i<[sortedArr count]; i++) {
                    NSInteger sortIndex = [[sortedArr objectAtIndex:i] intValue];
                    for (QuizBean *tempBean in tempArr) {
                        if (sortIndex == tempBean.quizID) {
                            [arrayQuiz addObject:tempBean];
                            
                            break;
                        }
                    }
                }

                NSInteger rightNum = [self intForColumnOfStatement:statement _colum:1];
                NSInteger doneNum = [self intForColumnOfStatement:statement _colum:2];
                BOOL isFirstTouch = [self boolForColumnOfStatement:statement _colum:3];
//                NSString *chapterName = [self stringForColumnOfStatement:statement _colum:4];
                NSInteger currentIndex = [self intForColumnOfStatement:statement _colum:4];
                
                [dataDic setObject:[NSNumber numberWithInt:rightNum] forKey:SAVEQIZ_RIGHTCOUNT];
                [dataDic setObject:[NSNumber numberWithInt:doneNum] forKey:SAVEQIZ_DONECOUNT];
                [dataDic setObject:[NSNumber numberWithBool:isFirstTouch] forKey:FIRSTTOUCH_LAST];
//                [dataDic setObject:chapterName forKey:CHAPTERQIZ_NAME];
                [dataDic setObject:[NSNumber numberWithInt:currentIndex] forKey:INDEXQIZ_LAST];
                
            } else {
                NSLog(@"query data filed");
                return NO;
            }
            sqlite3_finalize(statement);
            statement = nil;
            [tempArr release];
		}
    } else {
        execSuccess = NO;
    }
    return execSuccess;
}

-(BOOL)shouldCOntinueForCards:(NSInteger)_flashCardId
{
    BOOL shouldContinue = YES;
    
    sqlite3_stmt *statements = nil;
    NSString *sqlStr = @"";
    sqlStr = [NSString stringWithFormat:@"select id from flashcardHistoryrecorder where chapter_id = %d",_flashCardId];
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        return NO;
    } else {
        if (sqlite3_step(statements) != SQLITE_ERROR) {
            NSInteger indexNum = [self intForColumnOfStatement:statements _colum:0];
            
            if (indexNum == 0) {
                shouldContinue = NO;
            } else {
                shouldContinue = YES;
            }
        } else {
            NSLog(@"err is %s",sqlite3_errmsg(database));
            shouldContinue = NO;
        }
        //        while(sqlite3_step(statements) == SQLITE_ROW){
        //            //            NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
        //
        //        }
    }
    sqlite3_finalize(statements);
    statements = nil;
    NSLog(@"%s, the should continue is %d",__func__,shouldContinue);

    return shouldContinue;
}

-(BOOL)clearProcessForCards:(NSInteger)_flashCardId
{
    BOOL clearSuccess = YES;
    sqlite3_stmt *statements = nil;
    NSString *sqlStr = @"";
    sqlStr = [NSString stringWithFormat:@"delete from flashcardHistoryrecorder where chapter_id = %d",_flashCardId];
    if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    } else {
        if (sqlite3_step(statements) != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
        } else {
            NSLog(@"delete success");
        }
    }
    NSLog(@"%s, the string is %@",__func__,sqlStr);
    return clearSuccess;

}

-(BOOL)saveProcessForCards:(NSInteger)_chapterId Sequence:(NSString *)cardsSequence CurrentIndex:(NSInteger)c_index
{
    BOOL execSuccess = YES;
    sqlite3_stmt * statements = nil;
    NSString *sqlStr = @"";
    if ([self shouldCOntinueForCards:_chapterId]) {
        // update the db
        sqlStr = [NSString stringWithFormat:@"update flashcardHistoryrecorder set chapter_sequence = '%@', current_index = %d where chapter_id = %d",cardsSequence, c_index, _chapterId];
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            execSuccess = NO;
        } else {
            if (sqlite3_step(statements) != SQLITE_DONE) {
                NSAssert1(0, @"Error: failed to alter from database with message '%s'.", sqlite3_errmsg(database));
            } else {
                NSLog(@"****** success to update");
            }
        }
    } else {
        // insert a process to db
        sqlStr = [NSString stringWithFormat:@"INSERT INTO flashcardHistoryrecorder(chapter_id,chapter_sequence,current_index) VALUES(?, ?, ?)"];
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        } else {
            sqlite3_bind_int(statements, 1, _chapterId);
            sqlite3_bind_text(statements, 2, [cardsSequence UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statements, 3, c_index);
            if (sqlite3_step(statements) != SQLITE_ERROR) {
                execSuccess = YES;
            } else {
                NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
                execSuccess = NO;
            }
        }
    }
    sqlite3_finalize(statements);
    statements = nil;
    NSLog(@"%s, the string is %@",__func__,sqlStr);
    return execSuccess;
}

-(BOOL)getLastProcessForCards:(NSMutableArray *)arrayCards Chapter:(NSInteger)chapter valueDic:(NSMutableDictionary *)dataDic
{
    BOOL success;
    if([arrayCards count] != 0)
	{
		[arrayCards removeAllObjects];
	}
    sqlite3_stmt * queryCard_statements=nil;
    NSString *sqlQueryStr = @"";
    if (chapter == 0) {
        sqlQueryStr = [NSString stringWithFormat:@"select _id, question, answer, bookmark from flashcard"];
    } else {
        sqlQueryStr = [NSString stringWithFormat:@"select _id, question, answer, bookmark from flashcard WHERE chapter=%d",chapter];
    }
    if (sqlite3_prepare_v2(database, [sqlQueryStr UTF8String], -1, &queryCard_statements, NULL)!=SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    } else {
        NSMutableArray *tempCardArr = [[NSMutableArray alloc] initWithCapacity:10];
        while (sqlite3_step(queryCard_statements) == SQLITE_ROW) {
            CardBean *cardBean = [[CardBean alloc] init];
            cardBean.cardID = sqlite3_column_int(queryCard_statements, 0);
            if (sqlite3_column_text(queryCard_statements, 1)) {
                cardBean.question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryCard_statements, 1)];
            }else {
                cardBean.question = @"";
            }
            if (sqlite3_column_text(queryCard_statements, 2)) {
                cardBean.answer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(queryCard_statements, 2)];
            }else {
                cardBean.answer = @"";
            }
            cardBean.b_bookmark = sqlite3_column_int(queryCard_statements, 3);
            [tempCardArr addObject:cardBean];
            [cardBean release];
        }
        sqlite3_finalize(queryCard_statements);
        queryCard_statements = nil;
        sqlite3_stmt *statement = nil;
        NSString *sqlStr = @"";
        sqlStr = [NSString stringWithFormat:@"select chapter_sequence,current_index from flashcardHistoryrecorder where chapter_id=%d",chapter];
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &statement, NULL)!=SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        }
        if (sqlite3_step(statement)!=SQLITE_ERROR) {
            NSString *sequenceStr = [self stringForColumnOfStatement:statement _colum:0];
            //init the quiz array
            NSArray *sortedArr = [sequenceStr componentsSeparatedByString:@","];
            
            for (int i = 0; i<[sortedArr count]; i++) {
                NSInteger sortIndex = [[sortedArr objectAtIndex:i] intValue];
                for (CardBean *tempBean in tempCardArr) {
                    if (sortIndex == tempBean.cardID) {
                        [arrayCards addObject:tempBean];
                        break;
                    }
                }
            }
            NSInteger currentIndex = [self intForColumnOfStatement:statement _colum:1];

            [dataDic setObject:[NSNumber numberWithInt:currentIndex] forKey:INDEXCARD_LAST];
            
        } else {
            NSLog(@"query data filed");
            return NO;
        }
        sqlite3_finalize(statement);
        statement = nil;
        [tempCardArr release];
    }
    
    return success;
}

-(BOOL)getQizFromDB:(NSMutableArray *)arrayQiz OriQuiz:(NSMutableDictionary *)quizOri chapter:(NSInteger)_chapter mode:(NSInteger)mode
{
    //    if ([arrayQiz count] != 0) {
    //        [arrayQiz removeAllObjects];
    //    }
    BOOL done;
    NSLog(@"%s, the arrqiz is %@, quizori is %@, chapter is %d, mode is %d",__func__,arrayQiz,quizOri,_chapter,mode);
    if([arrayQiz count] != 0)
	{
		[arrayQiz removeAllObjects];
	}
	if([quizOri count] != 0)
	{
		[quizOri removeAllObjects];
	}
    sqlite3_stmt * statements=nil;
    if (statements == nil) {
		char *sql;
		if (_chapter == 0) {
			if (mode == 0) {
				sql = "select id, question, chapter,rightanswer,wronganswer1,wronganswer2,wronganswer3,wronganswer4, wronganswer5,explanation,bookmark from quiz";
			}else {
				sql = "select id, question, chapter,rightanswer,wronganswer1,wronganswer2,wronganswer3,wronganswer4, wronganswer5,explanation,bookmark from quiz WHERE bookmark=1";// AND bookinComp=1";
			}
		}else {
			if (mode == 0) {
				sql = "select id, question, chapter,rightanswer,wronganswer1,wronganswer2,wronganswer3,wronganswer4, wronganswer5,explanation,bookmark from quiz WHERE chapter=?";
			}else {
                sql = "select id, question, chapter,rightanswer,wronganswer1,wronganswer2,wronganswer3,wronganswer4, wronganswer5,explanation,bookmark from quiz WHERE bookmark=1 AND chapter=?";
//				sql = "select id, question, chapter,rightanswer,wronganswer1,wronganswer2,wronganswer3,wronganswer4, wronganswer5,explanation,bookmark from quiz WHERE bookmark=1 AND bookinComp=0 AND chapter=?";
			}
		}
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            return NO;
        }
        else{
			if (_chapter!= 0) {
				sqlite3_bind_int(statements, 1, _chapter);
			}
			
			while(sqlite3_step(statements) == SQLITE_ROW){
				QuizBean *quizBean = [[QuizBean alloc] init];
				quizBean.quizID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					quizBean.question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					quizBean.question = @"";
				}
				quizBean.chapter = sqlite3_column_int(statements, 2);
				
				NSMutableArray *answers = [[NSMutableArray alloc] init];
				if (sqlite3_column_text(statements, 3)) {   //rightanswer
					[answers addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 3)]];
				}
				if (sqlite3_column_text(statements, 4)) {   //wronganswer1
					NSString *wronganswer1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 4)];
					if (![wronganswer1 isEqualToString:@""]) {
						[answers addObject:wronganswer1];
					}
				}
				if (sqlite3_column_text(statements, 5)) {   //wronganswer2
					NSString *wronganswer2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 5)];
					if (![wronganswer2 isEqualToString:@""]) {
						[answers addObject:wronganswer2];
					}
				}
				if (sqlite3_column_text(statements, 6)) {   //wronganswer3
					NSString *wronganswer3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 6)];
					if (![wronganswer3 isEqualToString:@""]) {
						[answers addObject:wronganswer3];
					}
				}
				if (sqlite3_column_text(statements, 7)) {   //wronganswer4
					NSString *wronganswer4 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 7)];
					if (![wronganswer4 isEqualToString:@""]) {
						[answers addObject:wronganswer4];
					}
				}
				if (sqlite3_column_text(statements, 8)) {   //wronganswer5
					NSString *wronganswer5 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 8)];
					if (![wronganswer5 isEqualToString:@""]) {
						[answers addObject:wronganswer5];
					}
				}
				quizBean.answers = answers;
				
				if (sqlite3_column_text(statements, 9)) {
					quizBean.explanation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 9)];
				}else {
					quizBean.explanation = @"";
				}
				
				quizBean.b_bookmark = sqlite3_column_int(statements, 10);
				
				[arrayQiz addObject:quizBean];
                
                if(answers && answers.count > 0)
                {
                    [quizOri setValue:[answers objectAtIndex:0] forKey:[NSString stringWithFormat:@"%d", quizBean.quizID]];
                }
                
				
				[quizBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
            return YES;
		}
	}
    return NO;
}

-(BOOL)getCardsFromDB:(NSMutableArray *)arrCards chapter:(NSInteger)chapter mode:(NSInteger)mode
{
    if([arrCards count] != 0)
	{
		[arrCards removeAllObjects];
	}
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql;
		if (chapter == 0) {
			if (mode == 0) {
				sql = "select _id, question, answer, bookmark from flashcard";
			}else {
				sql = "select _id, question, answer, bookmark from flashcard WHERE bookmark=1";// AND bookinAll=1";
			}
		}else {
			if (mode == 0) {
				sql = "select _id, question, answer, bookmark from flashcard WHERE chapter=?";
			}else {
				sql = "select _id, question, answer, bookmark from flashcard WHERE bookmark=1 AND bookinAll=0 AND chapter=?";
			}
		}
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			if (chapter!= 0) {
				sqlite3_bind_int(statements, 1, chapter);
			}
			
			while(sqlite3_step(statements) == SQLITE_ROW){
				CardBean *cardBean = [[CardBean alloc] init];
				cardBean.cardID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					cardBean.question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					cardBean.question = @"";
				}
				if (sqlite3_column_text(statements, 2)) {
					cardBean.answer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
				}else {
					cardBean.answer = @"";
				}
				cardBean.b_bookmark = sqlite3_column_int(statements, 3);
				[arrCards addObject:cardBean];
				[cardBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
		}
	}
    
    return NO;
}

-(BOOL)getAllCardsFromReference:(NSMutableArray *)arrReference filtered:(NSMutableArray *)arrFilter
{
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql = "select _id, question, answer from flashcard order by question COLLATE NOCASE";
//        char *sql = "select id, question, answer from flashcard order by question ASC";
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			while(sqlite3_step(statements) == SQLITE_ROW){
				CardBean *cardBean = [[CardBean alloc] init];
				cardBean.cardID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					NSString *sQuestion = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
					cardBean.question = [sQuestion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				}else {
					cardBean.question = @"";
				}
				if (sqlite3_column_text(statements, 2)) {
					NSString *sAnswer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
					cardBean.answer = [sAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				}else {
					cardBean.answer = @"";
				}
				[arrReference addObject:cardBean];
				[cardBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
		}
	}
	
	[arrFilter addObjectsFromArray:arrReference];
    return YES;
}

-(BOOL)getBookMarksInPrevious:(NSMutableArray *)arrBooks
{
    NSLog(@"%s",__func__);
    sqlite3_stmt * statements = nil;
    static char *sql = "SELECT id FROM quiz WHERE bookmark = 1";
    if (sqlite3_prepare(database, sql, -1, &statements, NULL) != SQLITE_OK) {
        NSLog(@"Save the bookMark data faild!");
    }else {
        while (sqlite3_step(statements) == SQLITE_ROW) {
            if (sqlite3_column_text(statements, 0)) {
                
                // add the bookmark ID to the array
                [arrBooks addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 0)]];
            }
        }
    }
    sqlite3_finalize(statements);
    statements = nil;
    return YES;
}

-(BOOL)updateBookMarksToNew:(NSString *)idStr
{
    sqlite3_stmt *statement_updateBookmark = nil;
    NSString *sql_updateBookmark = [NSString stringWithFormat:@"update quiz set bookmark = 1 where id in (%@)",idStr];
    
    
    if (sqlite3_prepare(database, [sql_updateBookmark UTF8String], -1, &statement_updateBookmark, NULL) != SQLITE_OK) {
        NSLog(@"Update bookmark data faild!");
    } else {
        //        sqlite3_bind_text(statement_updateBookmark, 1, [idStr UTF8String], -1, nil);
        
        // excute sql
        sqlite3_step(statement_updateBookmark) ;
        NSLog(@"the id string is %@",idStr);
        // free
        
        
        
        sqlite3_finalize(statement_updateBookmark);
        statement_updateBookmark = nil;
        
    }
    
    return YES;
}

-(NSInteger)saveScore:(NSString *)schapter CorrectNum:(NSInteger)correctNum AllDoneNum:(NSInteger)allDoneNum
{
    NSLog(@"%s, chapter is %@, correct num is %d, all done num is %d",__func__,schapter,correctNum,allDoneNum);
    sqlite3_stmt * statements=nil;
    NSInteger last_insert_id = 0;
	if (statements == nil) {// in
		static char *sql = "INSERT INTO quizScore(chapter, result) VALUES(?, ?)";//, correctqiz, doneqiz
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
		sqlite3_bind_text(statements, 1, [schapter UTF8String], -1, SQLITE_TRANSIENT);
		
		// get current date/time
		NSDate *today = [NSDate date];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		// display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
		NSString *currentTime = [dateFormatter stringFromDate:today];
		//NSLog(@"%@", currentTime);
		[dateFormatter release];
		NSString *strRel;
		if (allDoneNum == 0) {
			strRel= [NSString stringWithFormat:@"%d/%d(%d%%) on %@", correctNum, allDoneNum, 0, currentTime];
		}else {
			strRel= [NSString stringWithFormat:@"%d/%d(%d%%) on %@", correctNum, allDoneNum, correctNum*100/allDoneNum, currentTime];
		}
		//NSLog(@"save chapter=%@", sChapter);
		//NSLog(@"%@", strRel);
		sqlite3_bind_text(statements, 2, [strRel UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_int(statements, 3, correctNum);
//        sqlite3_bind_int(statements, 4, allDoneNum);
		int success = sqlite3_step(statements);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		}
        last_insert_id = sqlite3_last_insert_rowid(database);
		// All data for the book is already in memory, but has not be written to the database
		sqlite3_finalize(statements);
		statements = nil;
        return last_insert_id;
    }
    return last_insert_id;
}
-(BOOL)bookmarkQiz:(NSInteger)qizId BookMark:(BOOL)bookmark
{
    NSLog(@"%s, qiz id is %d, bookmark is %d",__func__,qizId,bookmark);
    sqlite3_stmt * statements=nil;
    if (statements == nil) {
        static char *sql = "update quiz set bookmark=? where id=?";
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_bind_int(statements, 1, bookmark);
        sqlite3_bind_int(statements, 2, qizId);
    }
    int success = sqlite3_step(statements);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        return NO;
    }
    sqlite3_finalize(statements);
    statements = nil;
    return YES;
}

-(BOOL)bookmarkCard:(NSInteger)cardId BookMark:(BOOL)bookmark
{
    sqlite3_stmt * statements=nil;
    if (statements == nil) {
        static char *sql = "update flashcard set bookmark=? where _id=?";
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        sqlite3_bind_int(statements, 1, bookmark);
        sqlite3_bind_int(statements, 2, cardId);
    }
    int success = sqlite3_step(statements);
    if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(statements);
    statements = nil;
    return YES;
}


// Add by Arthur
/*
 Get the chapter data if this score has been bookmarked.
 */
- (BOOL)getBookmarkChapter:(NSMutableArray *)chapter{
    sqlite3_stmt *statements = nil;
    if (statements == nil) {
        static char *sql = "select chapter from quiz where bookmark = 1 group by chapter order by chapter";
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL)!= SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        } else {
            while(sqlite3_step(statements) == SQLITE_ROW){
                int chap = sqlite3_column_int(statements, 0);
                [chapter addObject:[NSNumber numberWithInt:chap]];
            }
            
            sqlite3_finalize(statements);
            statements = nil;
            
            return YES;
        }
    }
    
    return NO;
    
}

- (BOOL)getBookmarkChapterForFlashcard:(NSMutableArray *)chapter{
    sqlite3_stmt *statements = nil;
    if (statements == nil) {
        static char *sql = "select chapter from flashcard where bookmark = 1 group by chapter order by chapter";
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL)!= SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        } else {
            while(sqlite3_step(statements) == SQLITE_ROW){
                int chap = sqlite3_column_int(statements, 0);
                [chapter addObject:[NSNumber numberWithInt:chap]];
            }
            
            sqlite3_finalize(statements);
            statements = nil;
            
            return YES;
        }
    }
    
    return NO;
    
}

-(BOOL)bookmarkScen:(NSInteger)scenId BookMark:(BOOL)bookmark isSkillSheet:(BOOL)isSkillSheet
{
    sqlite3_stmt * statements=nil;
	if (statements == nil) {
		char *sql;
		if (isSkillSheet == NO) {
			sql = "update scenarios set book=?,bookTime=? where id=?";
		}else {
			sql = "update skillsheet set book=?,bookTime=? where id=?";
		}
		
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
		sqlite3_bind_int(statements, 1, bookmark);
		NSDate *date = [NSDate date];
		int iInterval = [date timeIntervalSince1970];
		sqlite3_bind_int(statements, 2, iInterval);
		sqlite3_bind_int(statements, 3, scenId);
	}
	int success = sqlite3_step(statements);
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(statements);
	statements = nil;
    
    return YES;
}

-(BOOL)getScoreFromDB:(NSMutableArray *)arrayScore
{
    NSLog(@"%s, score arr is %@",__func__,arrayScore);
    if ([arrayScore count] != 0) {
        [arrayScore removeAllObjects];
    }
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql = "select id, chapter,result from quizScore";
		
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			//sqlite3_bind_int(statements, 1, cateID-1);
			
			while(sqlite3_step(statements) == SQLITE_ROW){
				ScoreBean *scoreBean = [[ScoreBean alloc] init];
				scoreBean.scoreID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					scoreBean.chapter = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					scoreBean.chapter = @"";
				}
				if (sqlite3_column_text(statements, 2)) {
					scoreBean.result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
				}else {
					scoreBean.result = @"";
				}
				[arrayScore addObject:scoreBean];
				[scoreBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
            return YES;
		}
	}
    return NO;
}

-(BOOL)getBookmarkFromDB:(NSInteger)booktype Chapter:(NSInteger)chapterID data:(NSMutableArray *)arrayBookmark
{
    NSLog(@"%s, booktype is %d, chapterid is %d",__func__,booktype,chapterID);
    if ([arrayBookmark count] != 0) {
        [arrayBookmark removeAllObjects];
    }
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql;
		switch (booktype) {
			case 0:         // Quiz
			{
				if (chapterID == 0) {
					sql = "select id, question from quiz WHERE bookmark=? ORDER by bookTime ASC";  //AND bookinComp=?
				}else {
                    sql = "select id, question from quiz WHERE bookmark=? AND chapter=? ORDER by bookTime ASC";
//					sql = "select id, question from quiz WHERE bookmark=? AND bookinComp=? AND chapter=? ORDER by bookTime ASC";
				}
			}
				break;
			case 1:         // Flashcards
			{
				if (chapterID == 0) {
					sql = "select _id, question from flashcard WHERE bookmark=? ORDER by bookTime ASC"; //AND bookinAll=?
				}else {
					sql = "select _id, question from flashcard WHERE bookmark=? AND bookinAll=? AND chapter=? ORDER by bookTime ASC";
				}
			}
				break;
			default:
				break;
		}
		
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			sqlite3_bind_int(statements, 1, 1);
			if (chapterID != 0) {
                
                if (booktype == 0) {
                    sqlite3_bind_int(statements, 2, chapterID);
                }
                else if(booktype == 1){
                    sqlite3_bind_int(statements, 2, 0);
                    sqlite3_bind_int(statements, 3, chapterID);
                }
			}
			
			while(sqlite3_step(statements) == SQLITE_ROW){
				BookmarkBean *bookmarkBean = [[BookmarkBean alloc] init];
				bookmarkBean.quizID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					bookmarkBean.strQuiz = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					bookmarkBean.strQuiz = @"";
				}
				bookmarkBean.chapterID = sqlite3_column_int(statements, 2);
				bookmarkBean.bookinComp = sqlite3_column_int(statements, 3);
				
				[arrayBookmark addObject:bookmarkBean];
				[bookmarkBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
            return YES;
		}
	}
    
    return NO;
}

-(BOOL)getChaptersFromDB:(NSMutableArray *)arrChapter
{
    if([arrChapter count] != 0)
	{
		[arrChapter removeAllObjects];
	}
    
	sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql = "select id, name from quizChapter order by id";
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			while(sqlite3_step(statements) == SQLITE_ROW){
				ChapterBean *chapterBean = [[ChapterBean alloc] init];
				chapterBean.chapterID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					chapterBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				} else {
					chapterBean.name = @"";
				}
                
				[arrChapter addObject:chapterBean];
				[chapterBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
		}
	}
    return NO;
}

-(BOOL)getAllChapterFromDB:(NSInteger)bookType data:(NSMutableArray *)arrChapter
{
    if([arrChapter count] != 0)
	{
		[arrChapter removeAllObjects];
	}
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql;
		switch (bookType) {
			case 0:
				sql = "select id, name from quizChapter";
				break;
			case 1:
				sql = "select id, name from chapterFcard";
				break;
			default:
				break;
		}
		
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			while(sqlite3_step(statements) == SQLITE_ROW){
				ChapterBean *chapterBean = [[ChapterBean alloc] init];
				chapterBean.chapterID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					chapterBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					chapterBean.name = @"";
				}
				
				[arrChapter addObject:chapterBean];
				[chapterBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
            return YES;
		}
	}
    return NO;
}

-(BOOL)getScenariosFromDB:(NSMutableArray*)arrScen bookType:(BOOL)isBook isSkillSheet:(BOOL)isSkillSheet
{
    sqlite3_stmt * statements=nil;
	if ([arrScen count]!=0) {
        [arrScen removeAllObjects];
    }
	//get default category first
	if (statements == nil) {
		char *sql;
		if (isSkillSheet == NO) {
            if (isBook == YES) {
                sql = "select id, name, file, book from scenarios WHERE book=1";
            } else {
                sql = "select id, name, file, book from scenarios";
            }
		}else {
			sql = "select id, name, file, book from skillsheet WHERE book=1 ORDER by s_order";
		}
		
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			while(sqlite3_step(statements) == SQLITE_ROW){
				ScenariosBean *sBean = [[ScenariosBean alloc] init];
				sBean.sID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					sBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					sBean.name = @"";
				}
				if (sqlite3_column_text(statements, 2)) {
					sBean.filename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
				}else {
					sBean.filename = @"";
				}
				sBean.b_bookmark = sqlite3_column_int(statements, 3);
				
				[arrScen addObject:sBean];
				[sBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
		}
	}   
    
    return YES;
}

-(BOOL)getAllSkillSheetFromDBForToolBox:(NSMutableArray *)arrayChapters
{
    if ([arrayChapters count] != 0) {
        [arrayChapters removeAllObjects];
    }
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql = "select id, name, file, book, is_other from skillsheet ORDER by s_order";
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			while(sqlite3_step(statements) == SQLITE_ROW){
				ScenariosBean *sBean = [[ScenariosBean alloc] init];
				sBean.sID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					sBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					sBean.name = @"";
				}
				if (sqlite3_column_text(statements, 2)) {
					sBean.filename = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
				}else {
					sBean.filename = @"";
				}
				sBean.b_bookmark = sqlite3_column_int(statements, 3);
				sBean.b_others = sqlite3_column_int(statements, 4);
                
				[arrayChapters addObject:sBean];
				[sBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
		}
	}
    return YES;
}

-(BOOL)getCheckListFromDBForToolBox:(NSMutableArray *)arrChecks ChapterId:(NSInteger)chapterId
{
    if ([arrChecks count] != 0) {
        [arrChecks removeAllObjects];
    }
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql = "select _id, precheck, name, information1,information2,information3,checked from checklist WHERE chapter_id=? order by _id";
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			sqlite3_bind_int(statements, 1, chapterId);
			while(sqlite3_step(statements) == SQLITE_ROW){
				CheckBean *checkBean = [[CheckBean alloc] init];
				checkBean._id = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					checkBean.precheck = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					checkBean.precheck = @"";
				}
				if (sqlite3_column_text(statements, 2)) {
					checkBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
				}else {
					checkBean.name = @"";
				}
				if (sqlite3_column_text(statements, 3)) {
					checkBean.informaiton1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 3)];
				}else {
					checkBean.informaiton1 = @"";
				}
				if (sqlite3_column_text(statements, 4)) {
					checkBean.informaiton2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 4)];
				}else {
					checkBean.informaiton2 = @"";
				}
				if (sqlite3_column_text(statements, 5)) {
					checkBean.informaiton3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 5)];
				}else {
					checkBean.informaiton3 = @"";
				}
				checkBean.b_check = sqlite3_column_int(statements, 6);
				[arrChecks addObject:checkBean];
				[checkBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
		}
	}
    
    
    return YES;
}

-(BOOL)getChaptersFromDBForCheckList:(NSMutableArray *)arrChapters withPID:(NSInteger)pid
{
    if ([arrChapters count] != 0) {
        [arrChapters removeAllObjects];
    }
    sqlite3_stmt * statements=nil;
	
	//get default category first
	if (statements == nil) {
		char *sql = "select _id, name from chaptersChecklist WHERE parent_ID=?";
		
		
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			sqlite3_bind_int(statements, 1, pid);
			while(sqlite3_step(statements) == SQLITE_ROW){
				ChapterBean *chapterBean = [[ChapterBean alloc] init];
				chapterBean.chapterID = sqlite3_column_int(statements, 0);
			    if (sqlite3_column_text(statements, 1)) {
					chapterBean.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
				}else {
					chapterBean.name = @"";
				}
				
				[arrChapters addObject:chapterBean];
				[chapterBean release];
			}
			sqlite3_finalize(statements);
			statements = nil;
		}
	}
    
    return YES;
}

-(BOOL)updateCheckWithChapterID:(NSInteger)_id Checked:(BOOL)checked
{
    sqlite3_stmt * statements=nil;
	if (statements == nil) {
		static char *sql = "update checklist set checked=? where _id=?";
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
		sqlite3_bind_int(statements, 1, checked);
		sqlite3_bind_int(statements, 2, _id);
	}
	int success = sqlite3_step(statements);
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(statements);
	statements = nil;
    return YES;
}

-(BOOL)getAllBookmarksFromDB:(NSInteger)bookType data:(NSMutableArray *)arrBookmarks
{
    sqlite3_stmt * statements=nil;
    if ([arrBookmarks count] != 0) {
        [arrBookmarks removeAllObjects];
    }
	char *sql;
	for (int i=0; i<[arrBookmarks count]; i++) {
		ChapterBean *cBean = [arrBookmarks objectAtIndex:i];
		
		switch (bookType) {
			case 0:
				sql = "select id, question from quiz WHERE bookmark=? AND bookinComp=? AND chapter=? ORDER by bookTime ASC";
				break;
			case 1:
				sql = "select id, question from flashcard WHERE bookmark=? AND bookinAll=? AND chapter=? ORDER by bookTime ASC";
				break;
			default:
				break;
		}
		
        if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }else{
			sqlite3_bind_int(statements, 1, 1);
			sqlite3_bind_int(statements, 2, 0);
			sqlite3_bind_int(statements, 3, cBean.chapterID);
			
			BOOL b_has = NO;
			while(sqlite3_step(statements) == SQLITE_ROW){
				b_has = YES;
				break;
			}
            
			if (!b_has) {
				[arrBookmarks removeObjectAtIndex:i];
				i--;
			}
			
			sqlite3_finalize(statements);
			statements = nil;
		}
	}
    return YES;
}

-(BOOL)clearCheckedFromDBForToolBoxWithCharpterType:(NSInteger)cID
{
    sqlite3_stmt * statements=nil;
	if (statements == nil) {
		char *sql = "update checklist set checked=0 WHERE chapter_id <=12";
		if (cID==2) {
			sql = "update checklist set checked=0 WHERE chapter_id <=28 AND chapter_id>=13";
		}else if (cID == 3) {
			sql = "update checklist set checked=0 WHERE chapter_id >28";
		}
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	int success = sqlite3_step(statements);
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(statements);
	statements = nil;
    
    return YES;
}
-(BOOL)clearCheckedFromdbfORtoolBoxWithChecked
{
    sqlite3_stmt * statements=nil;
	if (statements == nil) {
		static char *sql = "update checklist set checked=0";
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	int success = sqlite3_step(statements);
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(statements);
	statements = nil;
    return YES;
}
-(BOOL)clearCheckedFromDBForToolBoxWithCharpterID:(NSInteger)Id
{
    sqlite3_stmt * statements=nil;
	if (statements == nil) {
		const char *sql = "update checklist set checked=0 WHERE chapter_id =?";
		if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	sqlite3_bind_int(statements, 1, Id);
	int success = sqlite3_step(statements);
	if (success == SQLITE_ERROR) {
		NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(statements);
	statements = nil;
    return YES;
}

-(BOOL)delScoreFromDB:(NSInteger)scoreId
{
    NSLog(@"%s, score id is %d",__func__,scoreId);
    sqlite3_stmt *delete_statement = nil;
	//delete from image where id = id
	if (delete_statement == nil) {
		const char *sql = "DELETE FROM quizScore WHERE id=?";
		if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	sqlite3_bind_int(delete_statement, 1, scoreId);
	int success1 = sqlite3_step(delete_statement);
	sqlite3_reset(delete_statement);
	if (success1 != SQLITE_DONE) {
		NSAssert1(0, @"Error: failed to delete from database with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(delete_statement);
	delete_statement = nil;
    return YES;
}


/**
 
 - Get dosing quetions
 
 */

-(void) getDosingQuestionsWithBlock : (void(^)(BOOL success, NSArray* questions)) block
{
    char *sql = "select * from Dosing_Questions";
    sqlite3_stmt *statements = nil;
    if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        if(block)
        {
            block(NO,nil);
        }
    }else{
        
        NSMutableArray* questionsArray = [NSMutableArray array];
        while(sqlite3_step(statements) == SQLITE_ROW){
            DosingBean *dosingBean = [[DosingBean alloc] init];
            
            
            dosingBean.question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 0)];
            dosingBean.answer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
            dosingBean.equation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
            
            [questionsArray addObject:dosingBean];
        }
        sqlite3_finalize(statements);
        statements = nil;
        if(block)
        {
            block(YES, [questionsArray mutableCopy]);
        }
        
    }
}


/**
 
 - Get cardiology quetions
 
 */

-(void) getCardiologyQuestionsWithBlock : (void(^)(BOOL success, NSArray* questions)) block
{
    char *sql = "select * from Cardiology_Questions";
    sqlite3_stmt *statements = nil;
    if (sqlite3_prepare_v2(database, sql, -1, &statements, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        if(block)
        {
            block(NO,nil);
        }
    }else{
        
        NSMutableArray* questionsArray = [NSMutableArray array];
        while(sqlite3_step(statements) == SQLITE_ROW){
            CardiologyBean *cardiologyBean = [[CardiologyBean alloc] init];
            
            
            cardiologyBean.question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 0)];
            cardiologyBean.hint = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 1)];
            cardiologyBean.explanation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statements, 2)];
            
            [questionsArray addObject:cardiologyBean];
        }
        sqlite3_finalize(statements);
        statements = nil;
        if(block)
        {
            block(YES, [questionsArray mutableCopy]);
        }
        
    }
}


@end