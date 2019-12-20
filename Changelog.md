## Changelog

### Next
- Make sure to check whether there's enough space left to save new logs (#37)

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
