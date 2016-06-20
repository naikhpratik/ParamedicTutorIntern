//
//  SqlMB.h
//  Checker
//
//  Created by Zorro on 14/01/2011.
//  Copyright 2011 eHealthInsurance Services Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "QuizBean.h"
#import "ScoreBean.h"
#import "BookmarkBean.h"
#import "ChapterBean.h"
#import "CardBean.h"
#import "ScenariosBean.h"
#import "CheckBean.h"
@interface SqlMB : NSObject {
}

+(SqlMB *) getInstance;
-(CGFloat) getDBVersion;

-(BOOL)alterDBWithAddColumn;
-(BOOL)getBookMarksInPrevious:(NSMutableArray *)arrBooks;
-(BOOL)updateBookMarksToNew:(NSString *)idStr;

// new db operate
-(BOOL)shouldContinueForQuiz:(NSInteger)_chpaterId;
-(BOOL)clearProcessForQuiz:(NSInteger)_chapterId;
-(BOOL)saveProcessForQuiz:(NSInteger)_chapterId Sequence:(NSString *)quizSequence CorrectNum:(NSInteger)correctNum DoneNum:(NSInteger)doneNum isFirstTouch:(BOOL)isFT isFinished:(BOOL)isFin ChapterName:(NSString *)c_Name CurrentIndex:(NSInteger)currentIndex;
-(BOOL)getLastProcessForQuiz:(NSMutableArray *)arrayQuiz OriQuiz:(NSMutableDictionary *)quizOri chapter:(NSInteger)chapter QuizStatus:(NSMutableDictionary *)dataDic;

-(BOOL)shouldCOntinueForCards:(NSInteger)_flashCardId;
-(BOOL)clearProcessForCards:(NSInteger)_flashCardId;
-(BOOL)saveProcessForCards:(NSInteger)_chapterId Sequence:(NSString *)cardsSequence CurrentIndex:(NSInteger)c_index;
-(BOOL)getLastProcessForCards:(NSMutableArray *)arrayCards Chapter:(NSInteger)chapter valueDic:(NSMutableDictionary *)dataDic;


-(BOOL)getQizFromDB:(NSMutableArray *)arrayQiz OriQuiz:(NSMutableDictionary *)quizOri chapter:(NSInteger)_chapter mode:(NSInteger)mode;
-(BOOL)getCardsFromDB:(NSMutableArray *)arrCards chapter:(NSInteger)chapter mode:(NSInteger)mode;
-(NSInteger)saveScore:(NSString *)schapter CorrectNum:(NSInteger)correctNum AllDoneNum:(NSInteger)allDoneNum;
-(BOOL)bookmarkQiz:(NSInteger)qizId BookMark:(BOOL)bookmark;
-(BOOL)bookmarkCard:(NSInteger)cardId BookMark:(BOOL)bookmark;
-(BOOL)bookmarkScen:(NSInteger)scenId BookMark:(BOOL)bookmark isSkillSheet:(BOOL)isSkillSheet;
-(BOOL)getScoreFromDB:(NSMutableArray *)arrayScore;
-(BOOL)getBookmarkFromDB:(NSInteger)booktype Chapter:(NSInteger)chapterID data:(NSMutableArray *)arrayBookmark;
-(BOOL)getChaptersFromDB:(NSMutableArray *)arrChapter;  //get quiz chapter
// 0 is quiz 1 is flash cards
-(BOOL)getAllChapterFromDB:(NSInteger)bookType data:(NSMutableArray *)arrChapter;
-(BOOL)getAllBookmarksFromDB:(NSInteger)bookType data:(NSMutableArray *)arrBookmarks;

-(BOOL)getAllCardsFromReference:(NSMutableArray *)arrReference filtered:(NSMutableArray *)arrFilter;


// tool box
-(BOOL)getAllSkillSheetFromDBForToolBox:(NSMutableArray *)arrayChapters;
-(BOOL)getCheckListFromDBForToolBox:(NSMutableArray *)arrChecks ChapterId:(NSInteger)chapterId;
-(BOOL)getChaptersFromDBForCheckList:(NSMutableArray *)arrChapters withPID:(NSInteger)pid;
-(BOOL)updateCheckWithChapterID:(NSInteger)_id Checked:(BOOL)checked;

-(BOOL)getScenariosFromDB:(NSMutableArray*)arrScen bookType:(BOOL)isBook isSkillSheet:(BOOL)isSkillSheet;
-(BOOL)getAllChapterFromDBForToolBox:(NSMutableArray *)arrayChapters withPId:(NSInteger)_pid;
-(BOOL)clearCheckedFromDBForToolBoxWithCharpterType:(NSInteger)cID;
-(BOOL)clearCheckedFromdbfORtoolBoxWithChecked;
-(BOOL)clearCheckedFromDBForToolBoxWithCharpterID:(NSInteger)Id;


-(BOOL)delScoreFromDB:(NSInteger)scoreId;
-(BOOL)getBookmarkChapter:(NSMutableArray *)chapter;
-(BOOL)getBookmarkChapterForFlashcard:(NSMutableArray *)chapter;
-(void) getDosingQuestionsWithBlock : (void(^)(BOOL success, NSArray* questions)) block;
-(void) getCardiologyQuestionsWithBlock : (void(^)(BOOL success, NSArray* questions)) block;



@end