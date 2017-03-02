//
//  GamePlayScreen.h
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GamePlayScene : SKScene<SKPhysicsContactDelegate>

- (void)didBeginContact:(SKPhysicsContact *)contact;

@end
