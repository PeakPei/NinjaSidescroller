//
//  GamePlayScreen.m
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "GamePlayScene.h"
#import "Universe.h"

@implementation GamePlayScene {
    SKLabelNode *label;
    bool gameEnd, isJumping;
    SKAction *atlasAnimation;
    SKAction *jumpAnimation;
}


- (void)didMoveToView:(SKView *)view {
    [self removeAllChildren];
    // Setup your scene here
    // Quit Label
    label = [SKLabelNode labelNodeWithFontNamed:@"BradleyHandITCTT-Bold"];
    label.text = @"Quit";
    label.fontSize = 30;
    label.name = @"quitLabel";
    label.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame));
    label.alpha = 0.0;
    [self addChild:label];
    [label runAction:[SKAction fadeInWithDuration:2.0]];
    
    gameEnd = NO; isJumping = NO;
    
    //Background
    for(int i = 0; i < 2; i++){
        SKSpriteNode * bg =[SKSpriteNode spriteNodeWithImageNamed:@"tempWallpaper3.png"];
        bg.anchorPoint = CGPointMake(.5,.5);
        bg.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.name = @"background";
        bg.zPosition = -1;
        [self addChild:bg];
    }
    
    //Character
    [self addChild:[self createCharacter]];
    [self setupActions];
    
    //Physics?
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    //walls
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
    //character
    SKSpriteNode *character = (SKSpriteNode*)[self childNodeWithName:@"character"];
    character.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:character.frame.size.width/2];
    character.physicsBody.friction = 0.0f;
    character.physicsBody.restitution = 0.0f;
    character.physicsBody.linearDamping = 0.0f;
    character.physicsBody.allowsRotation = NO;
}

- (SKSpriteNode*) createCharacter{
    SKSpriteNode *character = [SKSpriteNode spriteNodeWithImageNamed:@"sprites_base.png"];
    character.position = CGPointMake(-self.frame.size.width*.3, -self.frame.size.height*.4);
    character.zPosition = 100;
    character.name = @"character";
    return character;
}

- (void)setupActions {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"running"];
    SKTexture *runningTex1 = [atlas textureNamed:@"sprites_01.png"];
    SKTexture *runningTex2 = [atlas textureNamed:@"sprites_02.png"];
    SKTexture *runningTex3 = [atlas textureNamed:@"sprites_03.png"];
    SKTexture *runningTex4 = [atlas textureNamed:@"sprites_06.png"];
    SKTexture *runningTex5 = [atlas textureNamed:@"sprites_07.png"];
    SKTexture *runningTex6 = [atlas textureNamed:@"sprites_08.png"];
    NSArray *atlasTextures = @[runningTex1,runningTex2,runningTex3,runningTex4,runningTex5,runningTex6];
    
    atlasAnimation = [SKAction animateWithTextures:atlasTextures timePerFrame:.1];
    
    SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
    SKAction *repeatRun = [SKAction repeatActionForever:atlasAnimation ];
    [charNode runAction:repeatRun withKey:@"foreverAction"];
    
    SKTextureAtlas *jumpAtlas = [SKTextureAtlas atlasNamed:@"jump"];
    SKTexture *jumpTex1 = [jumpAtlas textureNamed:@"sprites_91.png"];
    SKTexture *jumpTex2 = [jumpAtlas textureNamed:@"sprites_92.png"];
    SKTexture *jumpTex3 = [jumpAtlas textureNamed:@"sprites_93.png"];
    SKTexture *jumpTex4 = [jumpAtlas textureNamed:@"sprites_94.png"];
    SKTexture *jumpTex5 = [jumpAtlas textureNamed:@"sprites_95.png"];
    SKTexture *jumpTex6 = [jumpAtlas textureNamed:@"sprites_96.png"];
    SKTexture *jumpTex7 = [jumpAtlas textureNamed:@"sprites_97.png"];
    NSArray *jumpAtlasTextures = @[jumpTex1,jumpTex2,jumpTex3,jumpTex4,jumpTex5,jumpTex6,jumpTex7];
    
    jumpAnimation = [SKAction animateWithTextures:jumpAtlasTextures timePerFrame:.1];
    
}

- (void) jumpDone{
    isJumping = NO;
    NSLog(@"Jump done");
}


- (void)touchDownAtPoint:(CGPoint)pos {
    //SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
    //[charNode runAction:atlasAnimation];
    NSLog(@"%@", NSStringFromCGPoint(pos));
    //SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
    /*if(isJumping == NO){
        isJumping = YES;
        SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
        [charNode runAction:jumpMovement];
    }*/
    SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
    [charNode.physicsBody applyImpulse:CGVectorMake(0.0f, 35.0f)];
    [charNode runAction:jumpAnimation];

}

- (void)touchMovedToPoint:(CGPoint)pos {

}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:pos];
    if(touchedNode == label && gameEnd == NO){
        [label runAction:[SKAction fadeOutWithDuration:2.0]];
        NSLog(@"Start pressed");
        gameEnd = YES;
        
        //If start is pressed, shift to next scene
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        //SKScene * myScene = [[GameOverScene alloc] initWithSize:self.size];
        [self.view presentScene:[[Universe sharedInstance] gos] transition: reveal];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
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
