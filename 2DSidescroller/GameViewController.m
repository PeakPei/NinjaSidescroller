//
//  GameViewController.m
//  2DSidescroller
//
//  Created by Christopher Fu on 2/27/17.
//  Copyright © 2017 Christopher Fu. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameOverScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    GameOverScene *scene1 = (GameOverScene *)[SKScene nodeWithFileNamed:@"GameOverScene"];
    GamePlayScene *scene2 = (GamePlayScene *)[SKScene nodeWithFileNamed:@"GamePlayScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    SKView *skView = (SKView *)self.view;
    
    //Init Singleton Universe with scenes
    [[Universe sharedInstance] setGs:scene];
    [[Universe sharedInstance] setGos:scene1];
    [[Universe sharedInstance] setGps:scene2];
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
