// Created for BearDev by drif
// drif@mail.ru

#define JSIsIphoneXSize(size) (size.height / size.width > 2.0)
#define JSIsIphoneX ((UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) && JSIsIphoneXSize(UIScreen.mainScreen.nativeBounds.size))
