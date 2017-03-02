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
@property (nonatomic) GameScene *gs;
@property (nonatomic) GameOverScene *gos;
@property (nonatomic) GamePlayScene *gps;
@property (nonatomic) BgSelectScene *bss;
@property (nonatomic) int bg;

-(void)saveState;
-(void)loadState;
@end
