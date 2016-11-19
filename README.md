# MTPopView + MTAlertView

### ���
#### MTPopView�����ṩ������ͼģ��͵���������   
#### MTAlertView�̳���MTPopView��������һЩ���ܵķ�װ������Ĺ��ܼ���ϸ�Ľ��벽�衣

### ʹ��˵��
#### ����Ҫ��
* iOS�汾Ҫ��: >= 7.0

#### ���벽��

* �ӿڵ���˵��

 	* MTAnimation
 		* ��View�����ʾ����

 				[MTAnimation animationShowInView:self style:style completion:^{
	 					//������ɵ�Block�ص�
 				    }]; 
 				    
 		* ��View������ض���

				[MTAnimation animationHideInView:self style:style completion:^{
						//������ɵ�Block�ص�
				    }];
	* MTPopView
		* ��ʼ��MTPopView
				
				//��Ҫ�����Զ����View��ͼ
				UIView *customeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
				
				//��һ�ֳ�ʼ������
				MTPopView *popView = [[MTPopView alloc] initPopViewWith:customeView];
				
				//�ڶ��ֳ�ʼ��
				MTPopView *popView = [[MTPopView alloc] init];
				popView.customeView = customeView; 
				 
		* ��ʾMTPopView

				//���ṩ����ͼ��Ĭ����ʾ�ڵ�ǰ���ڣ����ṩ����
				[popView show];
		
				//�ṩָ����ʾ����ͼ�����ṩ����
				[popView showInParentView:[UIApplication sharedApplication].keyWindow];
		    
		    	//ָ����ͼ��ʾ�������ṩ����
				[popView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleFade completion:^{
					//������ɴ����Block����
				}];
				MTAlertAction *action = [MTAlertAction actionWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *alertAction) {
					//��ť����¼��ڴ�ʵ��
				}
		
		* ����MTPopView

				//�޶�������
				[popView dissmiss];
				
				//����������
				[popView dissmissAnimation:MTAnimationStyleSlideFromTop completion:^{
					//������ʧ�����¼�
				}];
    
    	* ��Ļ��ת�¼�������̳�����д��ˢ����Ӧ�Ŀؼ���

    			- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    				//��Ļ��ת
    			}
    			
   * MTAlertView
		* ��ʼ��MTAlertView
		
		   		MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"1" subTitle:@"2" message:@"3" delegate:self actionShowStyle:MTAlertActionShowStyleList];
		
		* ��ʼ��Ĭ����ӿؼ�Ϊ��ť��MTAlertAction

				MTAlertAction *action = [MTAlertAction actionWithDefaultTypeWithTitle:@"1" style:MTAlertActionStyleDefault handler:^(MTAlertAction *action) {
				 	//�����¼�
				 }];
				 
 		* ��ʼ����ӿؼ�Ϊ���Զ���View��MTAlertAction��������Զ�����View����Ӱ�ť��
					
			   	MTAlertAction *action = [MTAlertAction actionWithCustomeViewTypeWithViewSize:CGSizeMake(300, 60) handleCustomeView:^(UIView *customeView) {
				   	//�ڴ˿��Բ���customeView
				}];
				
		* ��alertView���action

			    [alertView addAction:action];
		
		* �������action

			    [alertView addActions:@[action, action1, action2,]];
 			
		* ����˵��

				actionShowStyle:MTAlertAction�����пؼ�������ʽ
				typedef NS_ENUM(NSUInteger, MTAlertActionShowStyle) {
					 MTAlertActionShowStyleNone = 0, /**< û�У���ϵͳĬ�� **/
   					 MTAlertActionShowStyleList, /**< һ�ж��� **/
   					 MTAlertActionShowStyleRows, /**< ֻ��һ�У����� **/
				} NS_AVAILABLE_IPHONE(7.0);
				
				style:Ĭ��Ϊ��ť��ʱ��ť����ʽ����������
				typedef NS_ENUM(NSUInteger, MTAlertActionStyle) {
    				MTAlertActionStyleDefault = 0,  /**< ��ɫ **/
   					MTAlertActionStyleCancel,   /**< ��ɫ�Ӵ� **/
   					MTAlertActionStyleDestructive,  /**< ��ɫ **/
				} NS_AVAILABLE_IOS(7.0);
				
		* ��ӹرհ�ť

				[alertView addCloseButtonSize:CGSizeMake(30, 30) handleCloseButton:^(UIButton *closeButton) {
					//�����رհ�ť��Block����
				}];
				
		* ����AlertView�ڲ���Label��λ�ú���ʽ
				
				//�Բ�������LabelΪ��
				alertView.subLabelAlignment = MTAlertViewSubTitleLabelAlignmentRight;
				alertView.subTitleLabel.font = [UIFont systemFontOfSize:15.0];
				alertView.subTitleLabel.textColor = [UIColor blueColor];
				
		* ����AlertView�ڲ���һЩ�ؼ�λ��

				alertView.labelMargin = 0;
				//...
		
		* ��ʾ����ͬ���෽������Ҫע����ǣ���д��ʱ����Ҫ������Ӧ�ĸ��෽������:

			   	[super showInParentView:parentView];
			   	
			   	
    
    
 