
# 类似擦玻璃的效果

## 效果图
![image](https://github.com/yuchuanfeng/CFScratchViewDemo/blob/master/Untitled.gif)

## 使用非常简单
```objc
    // 清晰的图片
    UIImage* image = [UIImage imageNamed:@"paint01-1"];
    // 上层模糊的图片
    UIImage* coverImage = [UIImage imageNamed:@"paint01-01blur"];
    CFScratchView* scratchView = [[CFScratchView alloc] initWithImage:image coverImage:coverImage];
    [self.view addSubview:scratchView];
    scratchView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 400);
```
