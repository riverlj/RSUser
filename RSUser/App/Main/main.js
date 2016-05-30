require('UIColor')
defineClass('HomeViewController', {
                viewDidAppear: function(animated) {
                    self.super().viewDidAppear(animated);
                    self.navigationController().navigationBar().setHidden(NO);
                }
            })

defineClass('ConfirmOrderViewController', {
            
                viewWillAppear: function(animated) {
                    self.super().viewWillAppear(animated);
                    self.setTitle("你好");
                }
            })