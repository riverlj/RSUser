require('UIColor, AppConfig, BandleCellPhoneViewController, ConfirmOrderViewController,LoginViewController, UINavigationController,NSUserDefaults')

defineClass('AppConfig', {
            },
            {
                switchViewControllerWithCode: function(code) {
                    var vc;
                    switch (code) {
                        case 401: {
                            vc = LoginViewController.alloc().init();
                            var nav = UINavigationController.alloc().initWithRootViewController(vc);
                            AppConfig.getAPPDelegate().crrentNavCtl().presentViewController_animated_completion(nav, YES, null);

                            break;
                        }
                        case 403:{
                            vc = BandleCellPhoneViewController.alloc().init();
                            var nav = UINavigationController.alloc().initWithRootViewController(vc);
                            AppConfig.getAPPDelegate().crrentNavCtl().presentViewController_animated_completion(nav, YES, null);
                            break;
                        }
                        default:
                        break;
                    }
                }
            });

defineClass('BandleCellPhoneViewController',{
            bandleCellPhone: function() {
            var data = self.valueForKey("_loginModel")     //get member variables
            var weakSelf = __weak(self)
            data.bindMobile(block(function(){
                                  
                                               weakSelf.dismissViewControllerAnimated_completion(YES, null);
                                  AppConfig.getAPPDelegate().tabBarControllerConfig().selectedIndex = 0;
                                  AppConfig.getAPPDelegate().crrentNavCtl().popToRootViewControllerAnimated(YES);
                                               }))
            }
            });

