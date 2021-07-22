### 1.9.1
- Use latest write APIs to prevent a crash when storage is full. ([#87](https://github.com/WeTransfer/Diagnostics/pull/87)) via [@AvdLee](https://github.com/AvdLee)
- Update submodule reference. ([#85](https://github.com/WeTransfer/Diagnostics/pull/85)) via [@kairadiagne](https://github.com/kairadiagne)
- Merge release 1.9.0 into master ([#84](https://github.com/WeTransfer/Diagnostics/pull/84)) via [@wetransferplatform](https://github.com/wetransferplatform)

### 1.9.0
- Prevent setup twice, use file coordinator for increased performance ([#83](https://github.com/WeTransfer/Diagnostics/pull/83)) via [@AvdLee](https://github.com/AvdLee)

### 1.8.1
- Merge release 1.8.0 into master ([#77](https://github.com/WeTransfer/Diagnostics/pull/77)) via [@wetransferplatform](https://github.com/wetransferplatform)

### 1.8.0
- Xcode-fix ([#76](https://github.com/WeTransfer/Diagnostics/pull/76)) via [@JulianKahnert](https://github.com/JulianKahnert)
- Native (aka non-catalyst) macOS support added ([#75](https://github.com/WeTransfer/Diagnostics/pull/75)) via [@JulianKahnert](https://github.com/JulianKahnert)
- Merge release 1.7.0 into master ([#70](https://github.com/WeTransfer/Diagnostics/pull/70)) via [@ghost](https://github.com/ghost)

### 1.7.0
- Add crashes to our logs ([#63](https://github.com/WeTransfer/Diagnostics/issues/63)) via [@AvdLee](https://github.com/AvdLee)
- Memory leaks in DiagnosticsLogger.handlePipeNotification ([#65](https://github.com/WeTransfer/Diagnostics/issues/65)) via [@AvdLee](https://github.com/AvdLee)
- Add unit test for HTML encoding. ([#64](https://github.com/WeTransfer/Diagnostics/pull/64)) via [@davidsteppenbeck](https://github.com/davidsteppenbeck)
- Merge release 1.6.0 into master ([#62](https://github.com/WeTransfer/Diagnostics/pull/62)) via [@WeTransferBot](https://github.com/WeTransferBot)

### 1.6.0
- Include device product names ([#60](https://github.com/WeTransfer/Diagnostics/issues/60))
- Encode Logging for HTML so object descriptions are visible ([#51](https://github.com/WeTransfer/Diagnostics/issues/51))
- Trivial title fix. ([#59](https://github.com/WeTransfer/Diagnostics/pull/59))
- Merge release 1.5.0 into master ([#56](https://github.com/WeTransfer/Diagnostics/pull/56))

### 1.5.0
- Change the order of reported sessions ([#54](https://github.com/WeTransfer/Diagnostics/issues/54)) via @AvdLee
- Merge release 1.4.0 into master ([#53](https://github.com/WeTransfer/Diagnostics/pull/53))

### 1.4.0
- Migrate to Bitrise & Danger-Swift ([#52](https://github.com/WeTransfer/Diagnostics/pull/52)) via @AvdLee
- Add charset utf-8 to html head ([#50](https://github.com/WeTransfer/Diagnostics/pull/50)) via @AvdLee

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
