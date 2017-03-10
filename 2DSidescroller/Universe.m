//
//  Universe.m
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "Universe.h"

@implementation Universe
@synthesize score, highscore;
@synthesize lives;
@synthesize lost;
@synthesize bg;

static Universe *singleton = nil;
static GameScene *gs = nil;
static GameOverScene *gos = nil;
static BgSelectScene *bss = nil;
static GamePlayScene *gps = nil;


-(id)init
{
    if (singleton)
        return singleton;
    
    self = [super init];
    if (self)
    {
        singleton = self;
    }
    return self;
}

+(Universe *)sharedInstance
{
    if (singleton)
        return singleton;
    
    return [[Universe alloc] init];
}

-(GameScene *)getGs{
    if (gs)
        return gs;
    else gs = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    gos = nil;//reduce memory usage
    bss = nil;
    gps = nil;
    return gs;
}

-(GameOverScene *)getGos{
    if (gos)
        return gos;
    else gos = (GameOverScene *)[SKScene nodeWithFileNamed:@"GameOverScene"];
    gs = nil;
    bss = nil;
    gps = nil;
    return gos;
}

-(GamePlayScene *)getGps{
    if (gps)
        return gps;
    else gps = (GamePlayScene *)[SKScene nodeWithFileNamed:@"GamePlayScene"];
    gs = nil;
    bss = nil;
    gos = nil;
    return gps;
}

-(BgSelectScene *)getBss{
    if (bss)
        return bss;
    else bss = (BgSelectScene *)[SKScene nodeWithFileNamed:@"BgSelectScene"];
    gs = nil;
    gps = nil;
    gos = nil;
    return bss;
}

-(void)saveState
{
    NSArray *dirs = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSError *err;
    [[NSFileManager defaultManager] createDirectoryAtURL:[dirs objectAtIndex:0] withIntermediateDirectories:YES attributes:nil error:&err];
    NSURL *url = [NSURL URLWithString:@"example.archive" relativeToURL:[dirs objectAtIndex:0]];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeInt:highscore forKey:@"highscore"];
    [archiver finishEncoding];
    [data writeToURL:url atomically:YES];
    
    NSLog(@"Save the value %d for the high score", highscore);
}

-(void)loadState
{
    NSArray *dirs = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSError *err;
    [[NSFileManager defaultManager] createDirectoryAtURL:[dirs objectAtIndex:0] withIntermediateDirectories:YES attributes:nil error:&err];
    NSURL *url = [NSURL URLWithString:@"example.archive" relativeToURL:[dirs objectAtIndex:0]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data)
        return;
    
    NSKeyedUnarchiver *unarchiver;
    
    unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    highscore = [unarchiver decodeIntForKey:@"highscore"];
    
    NSLog(@"Loaded the value %d for the score", highscore);
}

@end

