//
//  ViewController.m
//  22_lecture_Gestures
//
//  Created by Slava on 22.04.17.
//  Copyright © 2017 Slava. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>  // надо добваить <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *testView;
@property (assign, nonatomic) CGFloat testViewScale;
@property (assign, nonatomic) CGFloat testViewRotation ;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // создаем квадрат и распологаем его в центре
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 50,
                                                            CGRectGetMidY(self.view.bounds) - 50,
                                                            100, 100)];
    view.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    // одинарное нажатие
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handelTap:)];

    [self.view addGestureRecognizer:tapGesture];
    
    // двойное нажатие
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(handelDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;        // количество нажатий (срабатывает двойное нажатие)
    [self.view addGestureRecognizer:doubleTapGesture];
    
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];   // одиночное нажатие не произайдет пока не поймет, что двойного щелчка не будет
    
    // двойное нажатие двумя пальцами
    UITapGestureRecognizer *doubleTapGestureDoubleTouch = [[UITapGestureRecognizer alloc]
                                                           initWithTarget:self
                                                           action:@selector(hendelDoubleTapGestureDoubleTouch:)];
    doubleTapGestureDoubleTouch.numberOfTapsRequired = 2;
    doubleTapGestureDoubleTouch.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTapGestureDoubleTouch];
    
    
    self.testView = view; // устанавливаем propperty testView во view
    
    // зумирование
    UIPinchGestureRecognizer *pinhcGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinhcGesture];
    
    // поворот
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleGestureRotation:)];
    [self.view addGestureRecognizer:rotationGesture];
    // делегаты
    pinhcGesture.delegate = self;
    rotationGesture.delegate = self;
    
    // перемещение
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    // вертикальный swipe
    UISwipeGestureRecognizer *verticalSwipeGesture = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(handleGestureVerticalSwipe:)];
    verticalSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp; // вертикальный свайп
    verticalSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:verticalSwipeGesture];
    
    // горизонтальный swipe
    UISwipeGestureRecognizer *horizontalSwipeGesture = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(handleGestureHorizontalSwipe:)];
    horizontalSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight; // горизонтальный свайп
    horizontalSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:horizontalSwipeGesture];
}

#pragma mark - Method 
- (UIColor *)randomColor {
    CGFloat r = (float)(arc4random() % 256) /255.f;
    CGFloat g = (float)(arc4random() % 256) /255.f;
    CGFloat b = (float)(arc4random() % 256) /255.f;
    return [UIColor colorWithRed:r
                    green:g
                    blue:b
                    alpha:1];
    
}


#pragma marg - Gestures
    // одинарное нажатие
- (void)handelTap:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"Tap: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    self.testView.backgroundColor = [self randomColor]; // в случае одиночного нажатия меняется цвет
}
    // двойной тап
- (void)handelDoubleTap:(UITapGestureRecognizer *)doubleTapGesture {
    NSLog(@"Double tap: %@", NSStringFromCGPoint([doubleTapGesture locationInView:self.view]));
    
    CGAffineTransform curientScale = self.testView.transform;
    CGAffineTransform newScale = CGAffineTransformScale(curientScale,1.2, 1.2);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.testView.transform = newScale;                 // в случае двойного клика - квадрат ростет
                     }];
    self.testViewScale = 1.2f;
}
    // двойное нажатие двумя пальцами
- (void)hendelDoubleTapGestureDoubleTouch:(UITapGestureRecognizer *)doubleTapGestureDoubleTouch {
    NSLog(@"Double Tap and Double Touch = %@", NSStringFromCGPoint([doubleTapGestureDoubleTouch locationInView:self.view]));
        [UIView animateWithDuration:0.3
                     animations:^{
                         self.testView.transform = CGAffineTransformMakeScale(1, 1); // уменьшает до прежнего размера
                     }];
    self.testViewScale = 1.f;
}
    // зумирование
- (void)handlePinch:(UIPinchGestureRecognizer *)pinhcGesture {
    
    if (pinhcGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewScale = 1.f;
    }
    
    CGFloat delta = 1.f + pinhcGesture.scale - self.testViewScale;
    NSLog(@"handle Pinch: %.3f", pinhcGesture.scale);
    CGAffineTransform curientScale = self.testView.transform;
    CGAffineTransform newScale = CGAffineTransformScale(curientScale, delta, delta);
    self.testView.transform = newScale;
    self.testViewScale = pinhcGesture.scale;

}

    // поворот
- (void)handleGestureRotation:(UIRotationGestureRecognizer *)rotationGesture {
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewRotation = 0;
    }
    
    NSLog(@"handle rotation: %.3f", rotationGesture.rotation);
    CGFloat newRotation = rotationGesture.rotation - self.testViewRotation;
    CGAffineTransform curientTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(curientTransform, newRotation);
    self.testView.transform = newTransform;
    self.testViewRotation = rotationGesture.rotation;

}
    // перемещение
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    NSLog(@"pan ");
    self.testView.center = [panGesture locationInView:self.view];
}

    // swipe vertical
- (void)handleGestureVerticalSwipe:(UISwipeGestureRecognizer *)verticalSwipeGesture {
    NSLog(@"vertical swipe");
}
    // swipe
- (void)handleGestureHorizontalSwipe:(UISwipeGestureRecognizer *)horizontalSwipeGesture {
    NSLog(@"horizontal swipe");
}

#pragma mark - UIGestureRecognizerDelegate
    // делаем одновременно зумирование и поворот (делегируем строки 73 и 74) (делаем изменение в строке 11)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
    // выполняется действие либо перемещение, либо swipe (делегируем строки 87 и 95)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class ]];
}


@end
