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
    SKLabelNode *label, *instructionLabel;
    bool gameEnd;
    SKAction *atlasAnimation;
    SKAction *jumpAnimation;
    int jumps;
    NSArray *bgArr;
}


- (void)didMoveToView:(SKView *)view {
    [self removeAllChildren];
    // Setup your scene here
    // Quit Label
    label = [SKLabelNode labelNodeWithFontNamed:@"BradleyHandITCTT-Bold"];
    label.text = @"Quit";
    label.fontSize = 30;
    label.name = @"quitLabel";
    label.zPosition = 200;
    label.position = CGPointMake(self.frame.size.width*.4, self.frame.size.height*.4);
    label.alpha = 0.0;
    [self addChild:label];
    [label runAction:[SKAction fadeInWithDuration:2.0]];
    
    instructionLabel =[SKLabelNode labelNodeWithFontNamed:@"BradleyHandITCTT-Bold"];
    instructionLabel.text = @"Tap once to jump, tap twice to double jump";
    instructionLabel.fontSize = 20;
    instructionLabel.name = @"instructionLabel";
    instructionLabel.position = CGPointMake(0,0);
    instructionLabel.zPosition = 200;
    [self addChild:instructionLabel];
    [instructionLabel runAction:[SKAction fadeInWithDuration:2.0]];
    
    gameEnd = NO;
    jumps = 0;
    
    // Background
    [self setUpParallex];
    
    // Character
    [self addChild:[self createCharacter]];
    [self setupActions];
    
    // Physics
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    // Walls
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
    // Character
    SKSpriteNode *character = (SKSpriteNode*)[self childNodeWithName:@"character"];
    character.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:character.frame.size.height/2];
    character.physicsBody.friction = 0.0f;
    character.physicsBody.restitution = 0.0f;
    character.physicsBody.linearDamping = 0.0f;
    character.physicsBody.allowsRotation = NO;
}
-(void)makePlatforms{

}

-(void)setUpParallex{ //Set up parallex background
    
    bgArr = @[
              @"parallax-mountain-bg.png",
              @"parallax-mountain-montain-far.png",
              @"parallax-mountain-mountains.png",
              @"parallax-mountain-foreground-trees.png",
              @"parallax-mountain-trees.png"
              ];
    /*bgArr = @[
              @"Layer_0010_1.png",
              @"Layer_0009_2.png",
              @"Layer_0008_3.png",
              @"Layer_0007_Lights.png",
              @"Layer_0006_4.png",
              @"Layer_0005_5.png",
              @"Layer_0004_Lights.png",
              @"Layer_0003_6.png",
              @"Layer_0002_7.png",
              @"Layer_0001_8.png",
              @"Layer_0000_9.png"
              ];*/
    for (int j = 0; j < bgArr.count; j++){
        for(int i = 0; i < 2; i++){
            SKSpriteNode * bg1 =[SKSpriteNode spriteNodeWithImageNamed:bgArr[j]];
            bg1.anchorPoint = CGPointMake(.5,.5);
            bg1.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
            bg1.position = CGPointMake(i * bg1.size.width, 0);
            NSString *tmp = @"background";
            NSString *tmp1 = [tmp stringByAppendingString:[NSString stringWithFormat:@"%d", j]];
            bg1.name = tmp1;
            bg1.zPosition = ((int)j);
            NSLog(@"%@", tmp1);
            NSLog(@" : %f\n", bg1.zPosition);
            [self addChild:bg1];
        }
    }
}

- (SKSpriteNode*) createCharacter{ //create and return character
    SKSpriteNode *character = [SKSpriteNode spriteNodeWithImageNamed:@"sprites_base.png"];
    character.position = CGPointMake(-self.frame.size.width*.3, -self.frame.size.height*.4);
    character.zPosition = 100;
    character.name = @"character";
    return character;
}

- (void)setupActions { //Sprite set up for character
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

//Handle doublejumps
- (void) jump{
    if(jumps < 1){
        SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
        if([charNode.physicsBody velocity].dy < -30.0f){
            [charNode.physicsBody applyImpulse:CGVectorMake(0.0f, 100.0f)];
        }else{[charNode.physicsBody applyImpulse:CGVectorMake(0.0f, 50.0f)];}
        [charNode runAction:jumpAnimation];
        NSLog(@"Jump done");
        jumps++;
    }
}

- (void)touchDownAtPoint:(CGPoint)pos {
    NSLog(@"%@", NSStringFromCGPoint(pos));
    if(pos.x <0) [self jump]; //left side of screen tap
}

- (void)touchMovedToPoint:(CGPoint)pos {

}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:pos];
    if(touchedNode == label && gameEnd == NO){
        [label runAction:[SKAction fadeOutWithDuration:3.0]];
        //NSLog(@"Start pressed");
        gameEnd = YES;
        
        //If start is pressed, shift to next scene
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        //SKScene * myScene = [[GameOverScene alloc] initWithSize:self.size];
        [self.view presentScene:[[Universe sharedInstance] gos] transition: reveal];
    }
    [instructionLabel runAction:[SKAction fadeOutWithDuration:3.0]];
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

-(void)runParallexBackground{
    for(int i=1; i < bgArr.count; i++){
        NSString *tmp = @"background";
        NSString *tmp1 = [tmp stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
        [self enumerateChildNodesWithName:tmp1 usingBlock: ^(SKNode *node, BOOL *stop){
            SKSpriteNode * bg = (SKSpriteNode *) node;
            bg.position = CGPointMake(bg.position.x - (i/2), bg.position.y);
            if (bg.position.x <= -bg.size.width) {
                bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
            }
        }];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    if(!gameEnd){
        [self runParallexBackground];
    }
    SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
   // NSLog(@"%f",[charNode.physicsBody velocity].dy);
    if([charNode.physicsBody velocity].dy > 600.0f){
        CGVector tmp = CGVectorMake([charNode.physicsBody velocity].dx, 600.0f);
        [charNode.physicsBody setVelocity:tmp];
        //NSLog(@">700");
    }
    if([charNode.physicsBody velocity].dy < -350.0f){
        CGVector tmp = CGVectorMake([charNode.physicsBody velocity].dx, -350.0f);
        [charNode.physicsBody setVelocity:tmp];
        //NSLog(@"<-300");
    }
    if([charNode position].y < -self.frame.size.height*.4){
        jumps = 0;
        //NSLog(@"%f,%f",[charNode position].x,[charNode position].y);
    }
}
@end
