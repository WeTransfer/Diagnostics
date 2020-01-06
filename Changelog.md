## Changelog

### Next
- Add charset utf-8 to html head

### 1.3.0
- Make sure to check whether there's enough space left to save new logs (#37)
- Added public static method  `DiagnosticsLogger.isSetUp()` (#41)
- Changed log times to use 24H clock (#40)
- Support for iOS 10.0 and update package.swift & Diagnostics.podspec to minimum deployment target iOS 10.0. #42 #47

### 1.2.0
- Forward the output of the DiagnosticsLogger to not disable default logging

### 1.1.0
- Added an `HTMLFormatting` type for custom formatting HTML inside reports
- Added a `DiagnosticsReportFilter` type to filter out senstive data (#17, #19)
- Dictionaries are now shown as Tables in the HTML report
- You can now set a custom UserDefaults for the report by using `UserDefaultsReporter.userDefaults = ..`

### 1.0.2
- Tests are no longer failing on CI (#18)
- Remove the CSS resource file for SPM support (#28)
- Saving to desktop makes sure the folder exists

### 1.0.1
- Fixed SPM build errors (#15)
- Fixed CocoaPods build errors by including CSS file (#21)

### 1.0 (2019-12-04)

- First public release! 🎉
