# MTPopView + MTAlertView

### 简介
#### MTPopView用来提供弹出视图模板和弹出动画。   
#### MTAlertView继承至MTPopView，进行了一些功能的封装。具体的功能见详细的接入步骤。

### 使用说明
#### 环境要求
* iOS版本要求: >= 7.0

#### 接入步骤

* 接口调用说明

 	* MTAnimation
 		* 给View添加显示动画

 				[MTAnimation animationShowInView:self style:style completion:^{
	 					//动画完成的Block回调
 				    }]; 
 				    
 		* 给View添加隐藏动画

				[MTAnimation animationHideInView:self style:style completion:^{
						//动画完成的Block回调
				    }];
	* MTPopView
		* 初始化MTPopView
				
				//需要进行自定义的View视图
				UIView *customeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
				
				//第一种初始化方法
				MTPopView *popView = [[MTPopView alloc] initPopViewWith:customeView];
				
				//第二种初始化
				MTPopView *popView = [[MTPopView alloc] init];
				popView.customeView = customeView; 
				 
		* 显示MTPopView

				//不提供父视图，默认显示在当前窗口，不提供动画
				[popView show];
		
				//提供指定显示的视图，不提供动画
				[popView showInParentView:[UIApplication sharedApplication].keyWindow];
		    
		    	//指定视图显示，并且提供动画
				[popView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleFade completion:^{
					//动画完成处理的Block函数
				}];
				MTAlertAction *action = [MTAlertAction actionWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *alertAction) {
					//按钮点击事件在此实现
				}
		
		* 隐藏MTPopView

				//无动画隐藏
				[popView dissmiss];
				
				//带动画隐藏
				[popView dissmissAnimation:MTAnimationStyleSlideFromTop completion:^{
					//动画消失后处理事件
				}];
    
    	* 屏幕旋转事件（子类继承需重写，刷新相应的控件）

    			- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    				//屏幕旋转
    			}
    			
   * MTAlertView
		* 初始化MTAlertView
		
		   		MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"1" subTitle:@"2" message:@"3" delegate:self actionShowStyle:MTAlertActionShowStyleList];
		
		* 初始化默认添加控件为按钮的MTAlertAction

				MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
				 	//处理事件
				 }];
				 
 		* 初始化添加控件为可自定义View的MTAlertAction（如可以自定义在View上添加按钮）
					
			   	MTAlertAction *action = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(300, 60) handleCustomeView:^(UIView *customeView) {
				   	//在此可以操作customeView
				}];
				
		* 往alertView添加action

			    [alertView addAction:action];
		
		* 批量添加action

			    [alertView addActions:@[action, action1, action2,]];
 			
		* 参数说明

				actionShowStyle:MTAlertAction集合中控件的排序方式
				typedef NS_ENUM(NSUInteger, MTAlertActionShowStyle) {
					 MTAlertActionShowStyleNone = 0, /**< 没有，及系统默认 **/
   					 MTAlertActionShowStyleList, /**< 一行多列 **/
   					 MTAlertActionShowStyleRows, /**< 只有一列，多行 **/
				} NS_AVAILABLE_IPHONE(7.0);
				
				style:默认为按钮的时候按钮的样式，具体如下
				typedef NS_ENUM(NSUInteger, MTAlertActionStyle) {
    				MTAlertActionStyleDefault = 0,  /**< 蓝色 **/
   					MTAlertActionStyleCancel,   /**< 蓝色加粗 **/
   					MTAlertActionStyleDestructive,  /**< 红色 **/
				} NS_AVAILABLE_IOS(7.0);
				
		* 添加关闭按钮

				[alertView addCloseButtonSize:CGSizeMake(30, 30) handleCloseButton:^(UIButton *closeButton) {
					//操作关闭按钮的Block函数
				}];
				
		* 更改AlertView内部的Label的位置和样式
				
				//以操作标题Label为例
				alertView.subLabelAlignment = MTAlertViewSubTitleLabelAlignmentRight;
				alertView.subTitleLabel.font = [UIFont systemFontOfSize:15.0];
				alertView.subTitleLabel.textColor = [UIColor blueColor];
				
		* 更改AlertView内部的一些控件位置

				alertView.labelMargin = 0;
				//...
		
		* 显示隐藏同父类方法，需要注意的是，重写的时候，需要调用相应的父类方法，如:

			   	[super showInParentView:parentView];
			   	
			   	
    
    
 