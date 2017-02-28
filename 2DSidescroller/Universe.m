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
@synthesize gs, gos;

static Universe *singleton = nil;


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

