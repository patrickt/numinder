;; main.nu
;; Numinder - a reminder application for Growl.

(load "Nu:nu")		;; basics
(load "Nu:cocoa")	;; cocoa definitions
(load "delegate")   ;; the application delegate. specified in the .nib file.

;; this makes the application window take focus when we've started it from the terminal
((NSApplication sharedApplication) activateIgnoringOtherApps:YES)

;; run the main Cocoa event loop
(NSApplicationMain 0 nil)
