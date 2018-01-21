//
//  ViewController.m
//  CifiterDemo
//
//  Created by 知言网络 on 2018/1/17.
//  Copyright © 2018年 知言网络. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataSourse;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CIContext  *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /// 这里我们可以看到总共有多少种滤镜
    NSArray *filterNames = [CIFilter filterNamesInCategory:@"CICategoryBuiltIn"];
    NSLog(@"总共有%ld种滤镜效果:%@",filterNames.count,filterNames);
    
    //以一个具体分类中的滤镜信息
    NSArray* filters =  [CIFilter filterNamesInCategory:kCICategoryDistortionEffect];
    for (NSString* filterName in filters) {
        NSLog(@"filter name:%@",filterName);
        // 我们可以通过filterName创建对应的滤镜对象
        CIFilter* filter = [CIFilter filterWithName:filterName];
        NSDictionary* attributes = [filter attributes];
        // 获取属性键/值对（在这个字典中我们可以看到滤镜的属性以及对应的key）
        NSLog(@"filter attributes:%@",attributes);
    }

    _dataSourse = [[NSMutableArray alloc] initWithObjects:
                   @"CIPhotoEffectMono",
                   @"CIPhotoEffectChrome",
                   @"CIPhotoEffectFade",
                   @"CIPhotoEffectInstant",
                   @"CIPhotoEffectNoir",
                   @"CIPhotoEffectProcess",
                   @"CIPhotoEffectTonal",
                   @"CIPhotoEffectTransfer",
                   @"CISRGBToneCurveToLinear",
                   @"CIVignetteEffect",
                   nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    //1.创建基于CPU的CIContext对象
     self.context = [CIContext contextWithOptions:
     [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
     forKey:kCIContextUseSoftwareRenderer]];
    //2.创建基于GPU的CIContext对象
    self.context = [CIContext contextWithOptions: nil];
    //3.创建基于OpenGL优化的CIContext对象，可获得实时性能
    self.context = [CIContext contextWithEAGLContext:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]];
}

#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourse.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *imageview;
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/4, 0, cell.contentView.frame.size.width/2, 240)];
        [cell addSubview:imageview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 将UIImage转换成CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"WechatIMG1.jpeg"]];
    // 创建滤镜
    CIFilter *filter = [CIFilter filterWithName:_dataSourse[indexPath.row]
                                  keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    // 创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    imageview.image = [UIImage imageWithCGImage:cgImage];
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    return cell;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
