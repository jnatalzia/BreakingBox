//
//  ViewController.m
//  Breaking Box
//
//  Created by Ryan  Stush on 11/10/13.
//  Copyright (c) 2013 RyanStush, JoeNatalzia. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "StartScene.h"
#import "RopeScene.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    //SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    /*SKScene *ropescene = [RopeScene sceneWithSize:skView.bounds.size];
    ropescene.scaleMode = SKSceneScaleModeAspectFill;*/
    
    // Present the scene.
    //[skView presentScene:ropescene];
}

//Screen inits -----------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    StartScene *startScene = [[StartScene alloc] initWithSize:CGSizeMake(screenWidth,screenHeight)];
    SKView* skView = (SKView *) self.view;
    
    [skView presentScene:startScene];
}


//Screen actions ---------------------------------------------------------------

- (BOOL)shouldAutorotate
{
    return YES;
}
-(void)gameWon{
    NSLog(@"WIN");
    SKView * skView = (SKView *)self.view;
    
    SKScene *scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
