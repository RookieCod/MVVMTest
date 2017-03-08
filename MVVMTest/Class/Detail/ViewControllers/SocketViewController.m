//
//  SocketViewController.m
//  MVVMTest
//
//  Created by zhangsong on 2017/3/2.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "SocketViewController.h"
#import "SRWebSocket.h"
@interface SocketViewController ()<SRWebSocketDelegate>
{
    SRWebSocket *_srWebSocket;
}

/** <#description#> */
@property (nonatomic, strong) UILabel *textLabel;
/** <#description#> */
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation SocketViewController

- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.sendButton];
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 200, 30)];
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _textLabel;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(60, 160, 60, 30);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.backgroundColor = [UIColor blueColor];
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reConnectedSocket];
}

- (void)reConnectedSocket
{
    _srWebSocket.delegate = nil;
    [_srWebSocket close];
    _srWebSocket = nil;
    
    _srWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://echo.websocket.org"]]];
    _srWebSocket.delegate = self;
    
    [_srWebSocket open];
}

- (void)sendButtonClick:(id)sender
{
    [_srWebSocket send:[NSString stringWithFormat:@"socket send success %zd",arc4random() % 50]];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"__%s__",__FUNCTION__);

    NSLog(@"didOpen%@",webSocket);
    [_srWebSocket sendPing:[NSData data]];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"__%s__",__FUNCTION__);

    _textLabel.text = message;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"__%s__",__FUNCTION__);

    [self reConnectedSocket];
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"__%s__",__FUNCTION__);
    
    [self reConnectedSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"__%s__",__FUNCTION__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
