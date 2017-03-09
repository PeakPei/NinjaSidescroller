//
//  GameScene.m
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "GameScene.h"
#import "Universe.h"


@implementation GameScene {
    SKLabelNode *label;
    bool gameStart;
}

- (void)didMoveToView:(SKView *)view {
    // Get label node from scene and store it for use later
    label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    label.fontName = @"BradleyHandITCTT-Bold";
    label.alpha = 0.0;
    [label runAction:[SKAction fadeInWithDuration:2.0]];
    
    gameStart = NO;

    for(int i = 0; i < 2; i++){
        SKSpriteNode * bg =[SKSpriteNode spriteNodeWithImageNamed:@"tempWallpaper3.png"];
        bg.anchorPoint = CGPointMake(.5,.5);
        bg.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.name = @"background";
        [self addChild:bg];
    }
}


- (void)touchDownAtPoint:(CGPoint)pos {
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:pos];
    if(touchedNode == label && gameStart == NO){
        [label runAction:[SKAction fadeOutWithDuration:2.0]];
        NSLog(@"Start pressed");
        gameStart = YES;
        
        //If start is pressed, shift to next scene
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        //SKScene * myScene = [[GameOverScene alloc] initWithSize:self.size];
        [self.view presentScene:[[Universe sharedInstance] getBss] transition: reveal];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    [self enumerateChildNodesWithName:@"background" usingBlock: ^(SKNode *node, BOOL *stop){
        SKSpriteNode * bg = (SKSpriteNode *) node;
        bg.position = CGPointMake(bg.position.x - 5, bg.position.y);
        
        if (bg.position.x <= -bg.size.width) {
            bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
        }
    }];
}

@end
