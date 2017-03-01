//
//  GamePlayScreen.m
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "GamePlayScene.h"
#import "Universe.h"

static const uint32_t characterCategory  =  0x1;  // 00000000000000000000000000000001
static const uint32_t platformCatagory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t worldCategory =  0x1 << 2;  // 00000000000000000000000000000100

@implementation GamePlayScene {
    SKLabelNode *label, *instructionLabel, *instructionLabel1;
    bool gameEnd;
    SKAction *atlasAnimation;
    SKAction *jumpAnimation;
    int jumps;
    NSArray *bgArr;
    bool runningForw;
}

- (void)didMoveToView:(SKView *)view {
    [self removeAllChildren];
    // Setup your scene here
    [self makeLabels];
    
    [self makePlatforms];
    gameEnd = NO;
    jumps = 0;
    runningForw = NO;
    
    // Background
    [self setUpParallex];
    
    // Character
    [self addChild:[self createCharacter]];
    [self setupActions];
    
    // Physics
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    self.physicsWorld.contactDelegate = self; //set up world for collisions
    //self.physicsBody.categoryBitMask = worldCategory;
    // Walls
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
    // Character
    SKSpriteNode *character = (SKSpriteNode*)[self childNodeWithName:@"character"];
    character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:character.frame.size];
    character.physicsBody.friction = 0.0f;
    character.physicsBody.restitution = 0.0f;
    character.physicsBody.linearDamping = 0.0f;
    character.physicsBody.allowsRotation = NO;
    character.physicsBody.categoryBitMask = characterCategory;
    character.physicsBody.contactTestBitMask = platformCatagory;
    character.physicsBody.collisionBitMask = worldCategory|platformCatagory;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
        // Collision with platform or world
    if (((firstBody.categoryBitMask & characterCategory) != 0 && (secondBody.categoryBitMask & platformCatagory) != 0 )){
        NSLog(@"CONTACT Plat\n");
        SKSpriteNode *character = (SKSpriteNode*)[self childNodeWithName:@"character"];
        NSLog(@"%f\n",[character.physicsBody velocity].dy);
        if([character.physicsBody velocity].dy <= 0.5){
            NSLog(@"jump reset\n");
            jumps = 0;
        }
    }
}

-(CGPoint)getRandPos{
    int levels = self.frame.size.height/4;
    int random = rand()%4;
    while (random ==0) random = rand()%4;
    int yPos = -self.frame.size.height*.5 + random*levels;
    int hlevels = self.frame.size.width/5;
    int random1 = rand()%5;
    int hPos = -self.frame.size.width*.5 + random1*hlevels;
    return CGPointMake(hPos, yPos);
}

-(void)makePlatforms{
    for(int i = 0; i<10 ; i++){
        SKSpriteNode *plat = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake((float)self.frame.size.width/5, (float)self.frame.size.height/100) ];
        plat.zPosition = 100;
        plat.name = @"plat";
        plat.position = [self getRandPos];
        plat.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:plat.frame.size];
        
        plat.physicsBody.restitution = 0.1f;
        plat.physicsBody.friction = 0.4f;
        plat.physicsBody.dynamic = NO;
        plat.physicsBody.categoryBitMask = platformCatagory;
        [self addChild:plat];
    }
    
}

// Handle jumps, doublejumps
- (void)jump{
    if(jumps < 2){
        SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
        if([charNode.physicsBody velocity].dy < -30.0f){
            [charNode.physicsBody applyImpulse:CGVectorMake(0.0f, 100.0f)];
        }else{[charNode.physicsBody applyImpulse:CGVectorMake(0.0f, 50.0f)];}
        [charNode runAction:jumpAnimation];
        jumps++;
    }
}


// =========== GAME LOOP ===========
-(void)update:(CFTimeInterval)currentTime { // Called before each frame is rendered
    if(!gameEnd){
        [self runParallexBackground];
    }
    SKSpriteNode *charNode = (SKSpriteNode*)[self childNodeWithName:@"character"];
    if([charNode.physicsBody velocity].dy > 0.0f){
        charNode.physicsBody.collisionBitMask = worldCategory;
    }else{
        charNode.physicsBody.collisionBitMask = worldCategory|platformCatagory;
    }
    if([charNode.physicsBody velocity].dy > 600.0f){
        CGVector tmp = CGVectorMake([charNode.physicsBody velocity].dx, 600.0f);
        [charNode.physicsBody setVelocity:tmp];
    }
    if([charNode.physicsBody velocity].dy < -350.0f){
        CGVector tmp = CGVectorMake([charNode.physicsBody velocity].dx, -350.0f);
        [charNode.physicsBody setVelocity:tmp];
    }
    float leftBound = -self.frame.size.width*.3;
    float rightBound = 0;
    if(runningForw){
        CGVector tmp = CGVectorMake( 150.0f , [charNode.physicsBody velocity].dy);
        [charNode.physicsBody setVelocity:tmp];
    }
    else if([charNode position].x < leftBound){
        CGVector tmp = CGVectorMake( 70.0f , [charNode.physicsBody velocity].dy);
        [charNode.physicsBody setVelocity:tmp];
    }
    else if([charNode position].x > rightBound){
        CGVector tmp = CGVectorMake( -65.0f , [charNode.physicsBody velocity].dy);
        [charNode.physicsBody setVelocity:tmp];
    }
    else if([charNode position].x >= -self.frame.size.width*.35 && [charNode position].x <= -self.frame.size.width*.2){
        CGVector tmp = CGVectorMake( 0.0f , [charNode.physicsBody velocity].dy);
        [charNode.physicsBody setVelocity:tmp];
    }
    [self enumerateChildNodesWithName:@"plat" usingBlock: ^(SKNode *node, BOOL *stop){
        SKSpriteNode * plat = (SKSpriteNode *) node;
        plat.position = CGPointMake(plat.position.x - 20, plat.position.y);
        if (plat.position.x <= -(self.frame.size.width)/2 - plat.frame.size.width) {
            plat.position = [self getNextPos:plat];
        }
    }];
   // NSLog(@"%i\n",jumps);

}//=================================

-(CGPoint)getNextPos: (SKNode*) node{
    int levels = self.frame.size.height/4;
    int random = rand()%4;
    while (random ==0) random = rand()%4;
    int yPos = -self.frame.size.height*.5 + random*levels;
    int hPos = node.position.x + self.frame.size.width + 2*node.frame.size.width;
    return CGPointMake(hPos, yPos);
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
            [self addChild:bg1];
        }
    }
}


-(void)makeLabels{
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
    instructionLabel.text = @"Tap left side to jump or double jump";
    instructionLabel.fontSize = 20;
    instructionLabel.name = @"instructionLabel";
    instructionLabel.position = CGPointMake(0,0);
    instructionLabel.zPosition = 200;
    [self addChild:instructionLabel];
    [instructionLabel runAction:[SKAction fadeInWithDuration:2.0]];
    instructionLabel1 =[SKLabelNode labelNodeWithFontNamed:@"BradleyHandITCTT-Bold"];
    instructionLabel1.text = @"Tap right side to run";
    instructionLabel1.fontSize = 20;
    instructionLabel1.name = @"instructionLabel";
    instructionLabel1.position = CGPointMake(0,-20);
    instructionLabel1.zPosition = 200;
    [self addChild:instructionLabel1];
    [instructionLabel1 runAction:[SKAction fadeInWithDuration:2.0]];
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

- (SKSpriteNode*) createCharacter{ //create and return character
    SKSpriteNode *character = [SKSpriteNode spriteNodeWithImageNamed:@"sprites_base.png"];
    character.position = CGPointMake(-self.frame.size.width*.3, -self.frame.size.height*.4);
    character.zPosition = 100;
    character.name = @"character";
    return character;
}

// Touches
- (void)touchDownAtPoint:(CGPoint)pos {
    //NSLog(@"%@", NSStringFromCGPoint(pos));
    if(pos.x < 0) [self jump]; //left side of screen tap
    if(pos.x > 0) runningForw = YES;
}

- (void)touchMovedToPoint:(CGPoint)pos {
    
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:pos];
    if(touchedNode == label && gameEnd == NO){
        [label runAction:[SKAction fadeOutWithDuration:3.0]];
        gameEnd = YES;
        //If start is pressed, shift to next scene
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:[[Universe sharedInstance] gos] transition: reveal];
    }
    [instructionLabel runAction:[SKAction fadeOutWithDuration:3.0]];
    [instructionLabel1 runAction:[SKAction fadeOutWithDuration:3.0]];
    runningForw = NO;
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

@end
