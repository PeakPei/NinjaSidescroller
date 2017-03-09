//
//  Universe.h
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"
#import "GameOverScene.h"
#import "BgSelectScene.h"
#import "GamePlayScene.h"

@interface Universe : NSObject{}

+(Universe *)sharedInstance;

@property (nonatomic) int score;
@property (nonatomic) int highscore;
@property (nonatomic) int lives;
@property (nonatomic) bool lost;

@property (nonatomic) int bg;


-(GameScene *)getGs;
-(GameOverScene *)getGos;
-(GamePlayScene *)getGps;
-(BgSelectScene *)getBss;

-(void)saveState;
-(void)loadState;
@end
