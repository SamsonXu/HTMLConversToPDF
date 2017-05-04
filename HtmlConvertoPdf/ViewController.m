//
//  ViewController.m
//  HtmlConvertoPdf
//
//  Created by iOS－Dev on 2017/5/3.
//  Copyright © 2017年 iOS－Dev. All rights reserved.
//

#import "ViewController.h"
#import "OCPDFGenerator.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
@interface ViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic, copy) NSString *htmlStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //Use the below code for HTML
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    _htmlStr = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:nil];
   //    NSLog(@"FileExists:%d", [[NSFileManager defaultManager] fileExistsAtPath:path]);
    [webView loadHTMLString:_htmlStr baseURL:nil];
    
    [self.view addSubview:webView];

    NSArray *itemTitles = @[@"save",@"share"];
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < itemTitles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*60, 0, 60, 30)];
        btn.tag = 100+i;
        [btn setTitle:itemTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [itemArray addObject:item];
    }
    self.navigationItem.rightBarButtonItems = itemArray;
    
}

- (void)rightItemClick:(UIButton *)sender{
    
    if (sender.tag == 100) {
        [MBProgressHUD showMessage:@"正在保存为PDF文件"];
        
        [OCPDFGenerator generatePDFFromHTMLString:_htmlStr];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAlertMessage:@"保存成功"];
        
    }else if (sender.tag == 101){
        
        [self savePdf];
    }
    
    
    
}

- (void)savePdf{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存为PDF文件到本地并分享?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showMessage:@"正在保存为PDF文件"];
        
        [OCPDFGenerator generatePDFFromHTMLString:_htmlStr];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showAlertMessage:@"保存成功"];
        
        [self sharePdf];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertCtrl addAction:action1];
    [alertCtrl addAction:action2];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
    
   
}

- (void)sharePdf{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/new.Pdf"];
    
    UIDocumentInteractionController *ctrl = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    ctrl.delegate = self;
    
    ctrl.UTI = @"com.adobe.pdf";
    [ctrl presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
