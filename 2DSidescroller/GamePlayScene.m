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
static const uint32_t wallCategory =  0x1 << 3;  // 00000000000000000000000000000100

@implementation GamePlayScene {
    SKLabelNode *label, *instructionLabel, *instructionLabel1;
    SKShapeNode *throw;
    bool gameEnd;
    SKAction *atlasAnimation;
    SKAction *jumpAnimation, *deadAnimation;
    int jumps;
    NSArray *bgArr;
    bool runningForw;
    SKSpriteNode *charNode;
    int enCount;
    bool firstJump;

}

- (void)didMoveToView:(SKView *)view {
    [self removeAllChildren];
    // Setup your scene here
    [self makeLabels];
    
    [self makePlatforms];
    [self makeEnemies];
    gameEnd = NO;
    jumps = 0;
    enCount = 0;
    runningForw = NO;
    firstJump = NO;
    
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
    
    // Set up hitbox for character --
    CGFloat offsetX = character.frame.size.width * character.anchorPoint.x;
    CGFloat offsetY = character.frame.size.height * character.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 16 - offsetX, 27 - offsetY);
    CGPathAddLineToPoint(path, NULL, 18 - offsetX, 26 - offsetY);
    CGPathAddLineToPoint(path, NULL, 20 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 21 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 14 - offsetX, 8 - offsetY);
    CGPathAddLineToPoint(path, NULL, 5 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 6 - offsetX, 25 - offsetY);
    CGPathAddLineToPoint(path, NULL, 7 - offsetX, 26 - offsetY);
    
    CGPathCloseSubpath(path);
    
    character.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    //done with hitbox
    
    character.physicsBody.friction = 0.0f;
    character.physicsBody.restitution = 0.0f;
    character.physicsBody.linearDamping = 0.0f;
    character.physicsBody.allowsRotation = NO;
    character.physicsBody.categoryBitMask = characterCategory;
    character.physicsBody.contactTestBitMask = platformCatagory | wallCategory;
    character.physicsBody.collisionBitMask = worldCategory | platformCatagory;
    charNode = character;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // Collision with platform or world
    if (((firstBody.categoryBitMask & characterCategory) != 0 && (secondBody.categoryBitMask & platformCatagory) != 0 )){
        //NSLog(@"CONTACT Plat\n");
        SKSpriteNode *character = (SKSpriteNode*)[self childNodeWithName:@"character"];
        //NSLog(@"%f\n",[character.physicsBody velocity].dy);
        if([character.physicsBody velocity].dy <= 0.5){
            //NSLog(@"jump reset\n");
            jumps = 0;
        }
    }
    // Collsion with wall
    else if (((firstBody.categoryBitMask & characterCategory) != 0 &&
         (secondBody.categoryBitMask & wallCategory) != 0 )){
        if (firstJump == YES){
            NSLog(@"Contact");
            SKSpriteNode *character = (SKSpriteNode*)[self childNodeWithName:@"character"];
            [character removeAllActions];
            [character runAction:deadAnimation];
            gameEnd = YES;
        }
    }
}

-(CGPoint)getRandPos{
    int levels = self.frame.size.height/4;
    int random = rand()%4;
    while (random == 0) random = rand()%4;
    int yPos = -self.frame.size.height * .5 + random*levels;
    int hlevels = self.frame.size.width/5;
    int random1 = rand()%7; //add two extra "frames" off screen
    int hPos = -self.frame.size.width * .5 + random1*hlevels;
    return CGPointMake(hPos, yPos);
}

-(CGPoint)getRandPos1{
    int levels = self.frame.size.height/4;
    int random = rand()%4;
    while (random == 0) random = rand()%4;
    int yPos = -self.frame.size.height * .5 + random*levels;
    int hlevels = self.frame.size.width/5;
    int random1 = rand()%7; //add two extra "frames" off screen
    int hPos = self.frame.size.width + random1*hlevels;
    return CGPointMake(hPos, yPos);
}

-(void)makePlatforms{
    for(int i = 0; i<10 ; i++){
        SKSpriteNode *plat = [SKSpriteNode spriteNodeWithImageNamed:@"log.png"];
        plat.size = CGSizeMake((float)self.frame.size.width/5, (float)self.frame.size.height/100);
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

-(void)makeEnemies{
    //for(int i = 0; i<3 ; i++){
    if(enCount < 3){
        SKSpriteNode *plat = [SKSpriteNode spriteNodeWithImageNamed:@"logv.png"];
        plat.size = CGSizeMake((float)self.frame.size.width/50, (float)self.frame.size.height/4);
        plat.zPosition = 99;
        plat.name = @"en";
        CGPoint a = [self getRandPos1];
        a =  CGPointMake(a.x, a.y - plat.size.height/2);
        plat.position = a;
        plat.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:plat.frame.size];
        plat.physicsBody.restitution = 0.0f;
        plat.physicsBody.friction = 0.4f;
        plat.physicsBody.dynamic = NO;
        plat.physicsBody.categoryBitMask = wallCategory;
        [self addChild:plat];
        enCount += 1;
    }
    
}

// Handle jumps, doublejumps
- (void)jump{
    if(jumps < 2){
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
        [self enumerateChildNodesWithName:@"en" usingBlock: ^(SKNode *node, BOOL *stop){
            SKSpriteNode * plat = (SKSpriteNode *) node;
            plat.position = CGPointMake(plat.position.x - 20, plat.position.y);
            if (plat.position.x <= -(self.frame.size.width)/2 - plat.frame.size.width) {
                NSArray *tmp = @[plat];
                [self removeChildrenInArray:tmp];
                NSLog(@"removed\n");
                enCount--;
            }
        }];
        if(rand()%50<25){[self makeEnemies]; }
    }
    else{
        if(!charNode.hasActions){
            SKTransition *reveal = [SKTransition fadeWithDuration:4.0];
            [self.view presentScene:[[Universe sharedInstance] gos] transition: reveal];
        }
    }
   // NSLog(@"%i\n",jumps);

}//=================================

-(CGPoint)getNextPos: (SKNode*) node{
    int levels = self.frame.size.height/4;
    int random = rand()%4;
    while (random ==0) random = rand()%4;
    int yPos = -self.frame.size.height*.5 + random*levels;
    int hPos = node.position.x + self.frame.size.width + (2 * node.frame.size.width);
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
    
    //Temp, non parallax background so I can test with high fps
    bgArr = @[
              @"tempWallpaper3.png",
              ];
    /*
    bgArr = @[
              @"parallax-mountain-bg.png",
              @"parallax-mountain-montain-far.png",
              @"parallax-mountain-mountains.png",
              @"parallax-mountain-foreground-trees.png",
              @"parallax-mountain-trees.png"
              ];*/
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
    
    throw = [SKShapeNode shapeNodeWithCircleOfRadius:self.frame.size.width*.05];
    throw.fillColor = [SKColor whiteColor];
    throw.position = CGPointMake(self.frame.size.width*.35, -self.frame.size.height*.35);
    throw.name = @"throw";
    throw.zPosition = 200;
    [self addChild:throw];
    [throw runAction:[SKAction fadeInWithDuration:2.0]];
    
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
    
    SKTextureAtlas *deadAtlas = [SKTextureAtlas atlasNamed:@"dead"];
    SKTexture *d1 = [deadAtlas textureNamed:@"sprites_99.png"];
    SKTexture *d2 = [deadAtlas textureNamed:@"sprites_101.png"];
    SKTexture *d3 = [deadAtlas textureNamed:@"sprites_102.png"];
    SKTexture *d4 = [deadAtlas textureNamed:@"sprites_103.png"];
    SKTexture *d5 = [deadAtlas textureNamed:@"sprites_104.png"];
    SKTexture *d6 = [deadAtlas textureNamed:@"sprites_105.png"];
    SKTexture *d7 = [deadAtlas textureNamed:@"sprites_106.png"];
    SKTexture *d8 = [deadAtlas textureNamed:@"sprites_107.png"];
    SKTexture *d9 = [deadAtlas textureNamed:@"sprites_108.png"];
    SKTexture *d10 = [deadAtlas textureNamed:@"sprites_109.png"];
    SKTexture *d11 = [deadAtlas textureNamed:@"sprites_110.png"];
    NSArray *deadTextures = @[d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11];
    
    deadAnimation = [SKAction animateWithTextures:deadTextures timePerFrame:.1];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"running"];
    SKTexture *runningTex1 = [atlas textureNamed:@"sprites_01.png"];
    SKTexture *runningTex2 = [atlas textureNamed:@"sprites_02.png"];
    SKTexture *runningTex3 = [atlas textureNamed:@"sprites_03.png"];
    SKTexture *runningTex4 = [atlas textureNamed:@"sprites_06.png"];
    SKTexture *runningTex5 = [atlas textureNamed:@"sprites_07.png"];
    SKTexture *runningTex6 = [atlas textureNamed:@"sprites_08.png"];
    NSArray *atlasTextures = @[runningTex1,runningTex2,runningTex3,runningTex4,runningTex5,runningTex6];
    
    atlasAnimation = [SKAction animateWithTextures:atlasTextures timePerFrame:.1];
    
    SKSpriteNode *character = (SKSpriteNode*)[self childNodeWithName:@"character"];
    SKAction *repeatRun = [SKAction repeatActionForever:atlasAnimation ];
    [character runAction:repeatRun withKey:@"foreverAction"];
    
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
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:pos];
    SKShapeNode *touchedNode1 = (SKShapeNode *)[self nodeAtPoint:pos];
    firstJump = YES;
    if(touchedNode != label){
    //NSLog(@"%@", NSStringFromCGPoint(pos));
        if(pos.x < 0) [self jump]; //left side of screen tap
        if(pos.x > 0) runningForw = YES;
    }else if(touchedNode1 == throw){
        NSLog(@"Throw\n");
    }
}

- (void)touchMovedToPoint:(CGPoint)pos {
    
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKLabelNode *touchedNode = (SKLabelNode *)[self nodeAtPoint:pos];
    if(touchedNode == label && gameEnd == NO){
        [label runAction:[SKAction fadeOutWithDuration:3.0]];
        [charNode removeAllActions];
        gameEnd = YES;
        [charNode runAction:deadAnimation];

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
