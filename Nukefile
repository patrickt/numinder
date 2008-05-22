;; Nukefile for Numinder.app

;; source files
(set @nu_files 	  (filelist "^nu/.*nu$"))

;; application description
(set @frameworks                '("Cocoa" "Nu" "Growl"))
(set @application 	            "Numinder")
(set @application_identifier    "us.thomson.patrick.nu.numinder")
(set @nib_files                 (filelist "^resources/.*\.lproj/[^/]*\.nib$"))

;; tasks
(compilation-tasks)
(application-tasks)

(task "default" => "application")
