//
//  BgSelectScene.m
//  2DSidescroller
//
//  Created by Christopher Fu on 3/2/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "BgSelectScene.h"
#import "Universe.h"

@implementation BgSelectScene{
    SKLabelNode *label, *label1, *label2;
    bool gameStart;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    // Get label node from scene and store it for use later
    label = (SKLabelNode *)[self childNodeWithName:@"//1"];
    label.fontName = @"BradleyHandITCTT-Bold";
    label.alpha = 0.0;
    label.zPosition = 100;
    [label runAction:[SKAction fadeInWithDuration:2.0]];
    
    label1 = (SKLabelNode *)[self childNodeWithName:@"//2"];
    label1.fontName = @"BradleyHandITCTT-Bold";
    label1.alpha = 0.0;
    label1.zPosition = 100;
    [label1 runAction:[SKAction fadeInWithDuration:2.0]];
    
    label2 = (SKLabelNode *)[self childNodeWithName:@"//3"];
    label2.fontName = @"BradleyHandITCTT-Bold";
    label2.zPosition = 100;
    label2.alpha = 0.0;
    [label2 runAction:[SKAction fadeInWithDuration:2.0]];
    
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
        gameStart = YES;
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [[Universe sharedInstance] setBg:0];
        [self.view presentScene:[[Universe sharedInstance] gps] transition: reveal];
    }else if(touchedNode == label1 && gameStart == NO){
        [label1 runAction:[SKAction fadeOutWithDuration:2.0]];
        gameStart = YES;
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [[Universe sharedInstance] setBg:1];
        [self.view presentScene:[[Universe sharedInstance] gps] transition: reveal];
    }else if(touchedNode == label2 && gameStart == NO){
        [label2 runAction:[SKAction fadeOutWithDuration:2.0]];
        gameStart = YES;
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [[Universe sharedInstance] setBg:2];
        [self.view presentScene:[[Universe sharedInstance] gps] transition: reveal];
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
