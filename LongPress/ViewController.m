//
//  ViewController.m
//  LongPress
//
//  Created by 沈红榜 on 15/7/8.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController {
    CGPoint _tempPoint;
    UIView *_callView;
    UILabel *_label;
    UIImageView *_imgView;
    NSInteger _endState;
    NSLayoutConstraint *_centerX;
    AVAudioRecorder *_audioRecorder;
    NSURL       *_recordUrl;
    NSTimer *_timer;
    UIImageView *_yinjieBtn;
    
    UIView *_maskView;
    NSLayoutConstraint *_maskH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    _recordUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"record.caf"]];
    NSError *error;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:_recordUrl settings:recordSetting error:&error];
    _audioRecorder.meteringEnabled = YES;
    
    UIView *pressView = [[UIView alloc] initWithFrame:CGRectZero];
    pressView.backgroundColor = [UIColor colorWithRed:1.000 green:0.557 blue:0.713 alpha:1.000];
    pressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:pressView];
    
    UILabel *pressLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    pressLbl.translatesAutoresizingMaskIntoConstraints = NO;
    pressLbl.text = @"按住说话";
    pressLbl.textAlignment = NSTextAlignmentCenter;
    [pressView addSubview:pressLbl];
    
    
    _callView = [[UIView alloc] initWithFrame:CGRectZero];
    _callView.hidden = YES;
    _callView.translatesAutoresizingMaskIntoConstraints = NO;
    _callView.layer.cornerRadius = 10;
    _callView.clipsToBounds = YES;
    _callView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [self.view addSubview:_callView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    _label.backgroundColor = [UIColor redColor];
    _label.text = @"手指上滑，取消发送";
    _label.layer.cornerRadius = 5;
    _label.clipsToBounds = YES;
    _label.textColor = [UIColor whiteColor];
    [_callView addSubview:_label];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.translatesAutoresizingMaskIntoConstraints = NO;
    _imgView.image = [UIImage imageNamed:@"yuyin"];
    [_callView addSubview:_imgView];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectZero];
    _maskView.translatesAutoresizingMaskIntoConstraints = NO;
    _maskView.backgroundColor = [UIColor whiteColor];
    [_callView addSubview:_maskView];
    
    _yinjieBtn = [[UIImageView alloc] initWithFrame:CGRectZero];
    _yinjieBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _yinjieBtn.image = [UIImage imageNamed:@"yinjie（6）"];
    [_callView addSubview:_yinjieBtn];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(pressView,pressLbl, _callView, _label, _imgView, _yinjieBtn, _maskView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[pressLbl]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pressLbl]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-80-[_callView]-80-|" options:0 metrics:nil views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[pressView]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pressView(50)]-40-|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_callView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_callView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_callView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_label]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_label]-|" options:0 metrics:nil views:views]];
    _centerX = [NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_callView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-20];
    [self.view addConstraint:_centerX];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_callView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yinjieBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_imgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_yinjieBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imgView attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imgView]-[_maskView]-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_yinjieBtn attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    _maskH = [NSLayoutConstraint constraintWithItem:_maskView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.view addConstraint:_maskH];
    
    UILongPressGestureRecognizer *presss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [pressView addGestureRecognizer:presss];
    
    
    
    
    
}

- (void)longPress:(UILongPressGestureRecognizer *)press {
    switch (press.state) {
        case UIGestureRecognizerStateBegan : {
            NSLog(@"began");
            _callView.hidden = NO;
            [_audioRecorder record];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            NSLog(@"change;");
            
            CGPoint point = [press locationInView:self.view];
            if (point.y < _tempPoint.y - 10) {
                _centerX.constant = 0;
                _endState = 0;
                _yinjieBtn.hidden = YES;
                _label.text = @"松开手指，取消发送";
                _label.backgroundColor = [UIColor clearColor];
                _imgView.image = [UIImage imageNamed:@"chexiao"];

                if (!CGPointEqualToPoint(point, _tempPoint) && point.y < _tempPoint.y - 8) {
                    _tempPoint = point;
                }
            } else if (point.y > _tempPoint.y + 10) {
                _endState = 1;
                _centerX.constant = -20;
                _yinjieBtn.hidden = NO;
                _label.backgroundColor = [UIColor redColor];
                _label.text = @"手指上滑，取消发送";
                _imgView.image = [UIImage imageNamed:@"yuyin"];
                if (!CGPointEqualToPoint(point, _tempPoint) && point.y > _tempPoint.y + 8) {
                    _tempPoint = point;
                }
            }
            
            NSLog(@"%@      %@", NSStringFromCGPoint(point), NSStringFromCGPoint(_tempPoint));
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"cancel, end");
            _callView.hidden = YES;
            [self endPress];
            [_timer invalidate];
            _timer = nil;
            [_audioRecorder stop];
            [_audioRecorder deleteRecording];
            break;
        }
        case UIGestureRecognizerStateFailed: {
            NSLog(@"failed");
            break;
        }
        default: {
            break;
        }
    }
}

- (void)endPress {
    switch (_endState) {
        case 0: {
            NSLog(@"取消发送");
            break;
        }
        case 1: {
            NSLog(@"发送");
            break;
        }
        default:
            break;
    }
}

- (void)changeImage {
    [_audioRecorder updateMeters];//更新测量值
    float avg = [_audioRecorder averagePowerForChannel:0];
    float minValue = -60;
    float range = 60;
    float outRange = 100;
    if (avg < minValue) {
        avg = minValue;
    }
    float decibels = (avg + range) / range * outRange;
    _maskH.constant = _yinjieBtn.frame.size.height - decibels * _yinjieBtn.frame.size.height / 100;
    _maskView.layer.frame = CGRectMake(0, _yinjieBtn.frame.size.height - decibels * _yinjieBtn.frame.size.height / 100, _yinjieBtn.frame.size.width, _yinjieBtn.frame.size.height);
    [_yinjieBtn.layer setMask:_maskView.layer];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
