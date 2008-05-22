;; Large chunks of this were stolen from the Growl example in the Nu distribution.

(load "macros")

(unless (load "Growl")
        (NSAlert alertWithMessageText:"Framework loading error"
                 defaultButtonTitle:nil
                 alternateButtonTitle:nil
                 otherButtonTitle:nil
                 informativeText:"Numinder could not load Growl.framework. Please ensure that it's located in /Library/Frameworks/."))

(class NuGrowlDelegate is NSObject
     (ivar (id) registrationDictionary)
     
     (imethod (id) registrationDictionaryForGrowl is
          (set? @registrationDictionary
                (NSMutableDictionary dictionaryWithList:
                     (list "AllNotifications" (NSArray arrayWithObject:"Numinder")
                           "DefaultNotifications" (NSArray arrayWithObject:0)))))
     
     (imethod (id) applicationNameForGrowl is "Numinder"))

(GrowlApplicationBridge setGrowlDelegate:(set $gd ((NuGrowlDelegate alloc) init)))


(function growl (message)
     (GrowlApplicationBridge notifyWithTitle:"Numinder"
          description:(message stringValue)
          notificationName:"Numinder"
          iconData:(NSData data)
          priority:0
          isSticky:NO
          clickContext:(message stringValue)))
