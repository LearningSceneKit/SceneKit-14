//
//  ViewController.m
//  SceneKit-14约束
//
//  Created by ShiWen on 2017/7/7.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"

#import <SceneKit/SceneKit.h>
@interface ViewController ()

@property(nonatomic,strong)SCNView *mScnView;
@property(nonatomic,strong)SCNIKConstraint *ikConstraint;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mScnView];
    
//    创建相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = true;
    cameraNode.position = SCNVector3Make(0, 0,1000);
    [self.mScnView.scene.rootNode addChildNode:cameraNode];
    
// 创建手掌
    SCNNode *handNode = [SCNNode node];
    handNode.geometry = [SCNBox boxWithWidth:20 height:20 length:20 chamferRadius:0];
    handNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"box2.jpg"];
    handNode.position = SCNVector3Make(0, -50, 0);
    
    
//    创建小手臂
    SCNNode *lowerArm = [SCNNode node];
    lowerArm.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
    lowerArm.geometry.firstMaterial.diffuse.contents = [UIColor blueColor];
    lowerArm.position = SCNVector3Make(0, -50, 0);
//    连接点
    lowerArm.pivot = SCNMatrix4MakeTranslation(0, 50, 0);
    [lowerArm addChildNode:handNode];
    
    
//    创建上手臂
    SCNNode *upperArm = [SCNNode node];
    upperArm.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
    upperArm.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
    upperArm.pivot = SCNMatrix4MakeTranslation(0, 50, 0);
    [upperArm addChildNode:lowerArm];
    
//    创建控制点
    SCNNode *controlNode = [SCNNode node];
    controlNode.geometry = [SCNSphere sphereWithRadius:10];
    controlNode.geometry.firstMaterial.diffuse.contents = [UIColor whiteColor];
    [controlNode addChildNode:upperArm];
    controlNode.position = SCNVector3Make(0, 100, 0);
    
    [self.mScnView.scene.rootNode  addChildNode:controlNode];
    
//    添加手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.mScnView addGestureRecognizer:gesture];
//    创建约束
    self.ikConstraint = [SCNIKConstraint inverseKinematicsConstraintWithChainRootNode:controlNode];
//    给执行器添加约束
    handNode.constraints = @[self.ikConstraint];
    

}
-(void)tapAction{
    [self createNodeToScene];
}

-(void)createNodeToScene{
    SCNNode *node = [SCNNode node];
    node.position = SCNVector3Make(arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100));
    [self.mScnView.scene.rootNode addChildNode:node];
    node.geometry = [SCNSphere sphereWithRadius:10];
    node.geometry.firstMaterial.diffuse.contents =[ UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0  blue:arc4random_uniform(255.0)/255.0  alpha:1];
    // 创建动画,使肢体不那么僵硬
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    self.ikConstraint.targetPosition = node.position;
    [SCNTransaction commit];
    node.physicsBody = [SCNPhysicsBody dynamicBody];
}
-(SCNView*)mScnView{
    if (!_mScnView) {
        _mScnView = [[SCNView alloc] initWithFrame:self.view.bounds];
        _mScnView.backgroundColor = [UIColor blackColor];
        _mScnView.allowsCameraControl = YES;
        _mScnView.scene = [SCNScene scene];
//        重力
        _mScnView.scene.physicsWorld.gravity = SCNVector3Make(0, 0, 98);
    }
    return _mScnView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
