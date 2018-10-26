fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios certificates
```
fastlane ios certificates
```
Sync (or create if needed) all keys, certs and profiles (development, adhoc, appstore)
### ios sync_certificates
```
fastlane ios sync_certificates
```
Sync all keys, certs and profiles (development and adhoc)
### ios dynamic_build
```
fastlane ios dynamic_build
```
Dynamic build using multi parameters : app id / base url / env name / app name
### ios build_appstore
```
fastlane ios build_appstore
```
Build the AppStore version and upload it
### ios build_testflight
```
fastlane ios build_testflight
```
Build the AppStore version and upload it to TestFlight
### ios build_beta_ppr
```
fastlane ios build_beta_ppr
```
Build a beta version and upload to Appaloosa
### ios test
```
fastlane ios test
```
Run all the tests
### ios screenshots
```
fastlane ios screenshots
```
Create screenshots of the application

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
