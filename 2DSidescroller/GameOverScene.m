//
//  GameOverScene.m
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "GameOverScene.h"
#import "Universe.h"

@implementation GameOverScene{
    SKLabelNode *label, *label1;
    bool gameRestart;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    gameRestart = NO;
    // Get label node from scene and store it for use later
    label = (SKLabelNode *)[self childNodeWithName:@"//gameOverLabel"];
    label.fontName = @"BradleyHandITCTT-Bold";
    label.alpha = 0.0;
    [label runAction:[SKAction fadeInWithDuration:2.0]];
    
    label1 = (SKLabelNode *)[self childNodeWithName:@"//tapToRestart"];
    label1.alpha = 0.0;
    label1.fontName = @"BradleyHandITCTT-Bold";
    [label1 runAction:[SKAction fadeInWithDuration:3.0]];
}



- (void)touchDownAtPoint:(CGPoint)pos {
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
    if(gameRestart == NO){
        gameRestart = YES;
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:[[Universe sharedInstance] getGs] transition: reveal];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
