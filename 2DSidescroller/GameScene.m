//
//  GameScene.m
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "Universe.h"

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *label;
    bool gameStart;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    // Get label node from scene and store it for use later
    label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    label.fontName = @"BradleyHandITCTT-Bold";
    label.alpha = 0.0;
    [label runAction:[SKAction fadeInWithDuration:2.0]];
    
    gameStart = NO;
    
    //CGFloat w = (self.size.width + self.size.height) * 0.05;
    
    // Create shape node to use during mouse interaction
    /*
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:-M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
     */
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
    /*SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];*/
}

- (void)touchMovedToPoint:(CGPoint)pos {
    /*SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];*/
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
        [self.view presentScene:[[Universe sharedInstance] gps] transition: reveal];
    }
    /*SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];*/
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    //label.hidden = YES;
    
    //for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
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
