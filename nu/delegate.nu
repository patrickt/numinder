;; delegate.nu
;; Numinder - a reminder application for Growl.
;; This file holds the specifications for the application delegate.

(load "growl")

(class AppDelegate is NSObject
     
     (ivar (id) messageField)   ;; the message to growl at a later time
     (ivar (id) timeField)      ;; a user-specified date or time interval to delay the growl
     (ivar (id) buttonMatrix)   ;; a group of buttons to determine whether the user is using a date or time interval
     
     ;; Returns the proper amount to delay by querying the selected button.
     (- (id) convertStringToSecondsFromNow:(id)str is
        (if (eq (@buttonMatrix selectedColumn) 0)
            (self convertTimeIntervalString:str)
            (else
                 (self convertDateStringToTimeInterval:str))))
     
     
     (- (id) convertTimeIntervalString:(id)interval is
        (set timeUnitPairs (/(\d+) (second|minute|hour|day)/ findAllInString:interval))
        (unless (timeUnitPairs count)
                (NSException raise: "NuminderParsingError"
                     format: <<-END
                     Numinder could not find any parsable time intervals in your string.
                     Some valid time intervals are 'in 5 seconds' and '12 minutes and 50 seconds from now'.
                     Is the 'in' button above selected when you wanted the 'at' button?.END))
        ;; Using map: and reduce:from: makes this code a little harder to follow, but
        ;; it's faster than using an incremental variable.
        (set allPairAmounts
             (timeUnitPairs map:
                  (do (unitPair)
                      (NSLog "Unit pair is #{(unitPair description)}")
                      (set quantity ((unitPair groupAtIndex: 1) doubleValue))
                      (set unit (unitPair groupAtIndex: 2))
                      (NSLog "Quantity is #{quantity}")
                      (if (>= 0.0 quantity)
                          (NSException raise: "NuminderParsingError"
                               format: <<-END
                               While trying to parse the phrase '#{(unitPair groupAtIndex:1)}"(s)', Numinder encountered an error.
                               The amount '#{quantity}' could not be recognized as a positive numerical value.
                               Make sure to use digits rather than ordinal numbers (e.g. '5' over 'five').END))
                      (set multiplier
                           (case unit
                                 ("second" 1)
                                 ("minute" 60)
                                 ("hour"   360)
                                 ("day"    8640)))
                      (* multiplier quantity))))
        (allPairAmounts reduce:(do (x y) (+ x y)) from:0))
     
     
     (- (id) convertDateStringToTimeInterval:(id)str is
        (NSLog "Converting a date string #{str}")
        (set result (NSDate dateWithNaturalLanguageString:str))
        (if result
            (result timeIntervalSinceNow)
            (else
                 (NSException raise:"NuminderParsingError" format:<<-END
                  Numinder encountered an error while trying to parse the time '#{str}.'
                  Some valid examples are 'at 12:50', 'tomorrow at dinner', and 'next year'.
                  Did you enter it correctly?END))))
     
     (- (id) remind:(id)sender is
        (try
            (set amt (self convertStringToSecondsFromNow: (@timeField string)))
            (NSLog "Will display message #{amt} seconds from now")
            (self performSelector:"showNotification:"
                  withObject:(@messageField string)
                  afterDelay:amt)
            (catch (exception)
                   (if (eq (exception name) "NuminderParsingError")
                       (growl (exception reason))
                       (else
                            (NSLog "Error: #{(exception name)} - #{(exception reason)}")
                            (growl "Numinder was unable to complete your reminder due to an unexpected error."))))))
     
     
     (- (id) showNotification:(id)str is
        (growl str))
     
     
     ;; Ironically enough, this is the only application delegate method.
     (- (id) applicationShouldTerminateAfterLastWindowClosed:(id)app is YES))

