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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;
@property (weak, nonatomic)  SKView * skView;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTap;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
}

//Screen inits -----------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    /*
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    StartScene *startScene = [[StartScene alloc] initWithSize:CGSizeMake(screenWidth,screenHeight)];
    SKView* skView = (SKView *) self.view;
    
    [skView presentScene:startScene];
    */
    
    // Present the Start Scene right away.
    if (self.gameState == kGameStateStart) [self.skView presentScene: self.startScene];
    if (! self.doubleTap) [self initGestures];
}


-(SKView *)skView{
    if (!_skView){
        NSLog(@"%s",__FUNCTION__);
        // configure the view
        _skView = (SKView *)self.view;
        _skView.showsFPS = YES;
        _skView.showsNodeCount = YES;
    }
    return _skView;
}

- (StartScene *)startScene{
    if (!_startScene) {
        NSLog(@"%s",__FUNCTION__);
        _startScene = [StartScene sceneWithSize: self.skView.bounds.size];
        _startScene.scaleMode = SKSceneScaleModeAspectFill;
        _startScene.viewController = self;
    }
    return _startScene;
}
-(LevelScene *)levelScene{
    if (!_levelScene){
        _levelScene = [LevelScene sceneWithSize:self.skView.bounds.size];
        _levelScene.scaleMode = SKSceneScaleModeAspectFill;
        _levelScene.viewController = self;
    }
    return _levelScene;
}
- (InstructionsScene *)instructionsScene{
    if (!_instructionsScene) {
        NSLog(@"%s",__FUNCTION__);
        _instructionsScene = [InstructionsScene sceneWithSize:self.skView.bounds.size];
        _instructionsScene.scaleMode = SKSceneScaleModeAspectFill;
        _instructionsScene.viewController = self;
    }
    return _instructionsScene;
}

- (RopeScene *)ropeScene{
    if (!_ropeScene) {
        NSLog(@"%s",__FUNCTION__);
        _ropeScene = [RopeScene sceneWithSize:self.skView.bounds.size];
        _ropeScene.scaleMode = SKSceneScaleModeAspectFill;
        _ropeScene.viewController = self;
    }
    return _ropeScene;
}
//---------------------------------------------------------actions
- (void)initGestures{
    NSLog(@"%s",__FUNCTION__);
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.doubleTap.numberOfTapsRequired  = 2;
    self.doubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer: self.doubleTap];
}


- (void)showStartScene{
    NSLog(@"%s",__FUNCTION__);
    [self.skView presentScene: self.startScene];
    [self hideUIElements:NO];
}

- (void)showInstructionsScene{
    NSLog(@"%s",__FUNCTION__);
    [self.skView presentScene: self.instructionsScene];
}
-(void)goToLevel:(int)level
{
    self.ropeScene.currLevel = level;
    
    //NSLog(@"gotolevel:%d",self.ropeScene.currLevel);
    
    [self.ropeScene nextLevel];
    
    [self.skView presentScene: self.ropeScene];
}

#pragma mark - Actions
- (IBAction)clickedStartSceneButton{
    NSLog(@"%s",__FUNCTION__);
    self.gameState = kGameStateStart;
    [self showStartScene];
    
}

- (IBAction)clickedGameSceneButton{
    NSLog(@"%s",__FUNCTION__);
    self.gameState = kGameStateGame;
    [self hideUIElements:YES];
    
}

- (IBAction)clickedInstructionsSceneButton{
    NSLog(@"%s",__FUNCTION__);
    self.gameState = kGameStateInstructions;
    [self hideUIElements:YES];
}

// handleDoubleTap is called by self.doubleTap (a UIGestureRecognizer)
- (void)handleDoubleTap:(UITapGestureRecognizer *)sender{
    NSLog(@"%s",__FUNCTION__);
    if (self.gameState == kGameStateGame && sender.state == UIGestureRecognizerStateEnded){
        self.gameState = kGameStateStart;
        [self showStartScene];
    }
}
/*
// pauseGame and resumeGame are called by the AppDelegate
- (void)pauseGame{
    [self.gameScene pauseGame];
}

- (void)resumeGame{
    [self.gameScene resumeGame];
}
*/

//hides UI elements when not in use or needed ----------------------------------------
- (void)hideUIElements:(BOOL)shouldHide{
    CGFloat alpha = shouldHide ? 0.0f : 1.0f;
    
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // fade out buttons
        self.playButton.alpha = alpha;
        self.instructionsButton.alpha = alpha;
        
        // fade out text at same time
        if (self.gameState == kGameStateGame) {
            [self.startScene runStartScreenTransition];
        }
        
        if (self.gameState == kGameStateInstructions) {
            [self.startScene runStartScreenTransition];
        }
        
        
    } completion:NULL];
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
    if (self.gameState != kGameStateInstructions ) self.instructionsScene = nil;
    if (self.gameState != kGameStateStart ) self.startScene = nil;
}

- (BOOL)shouldAutorotate{
    return YES;
}

// hide the status bar
- (BOOL)prefersStatusBarHidden{
    return YES;
}


//Screen actions ---------------------------------------------------------------

-(void)gameWon{
    NSLog(@"WIN");
    SKView * skView = (SKView *)self.view;
    
    SKScene *scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    
}

@end
