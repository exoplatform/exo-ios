# eXo Platform mobile

## Develop

Pre-requisites :

- Xcode 13 (Mac OS 11)
- CocoaPod
- Fastlane (for people on charge of release)

To get and install locally the needed Provisioning Profiles you need to execute the command :

    fastlane sync_certificates

and give `com.exoplatform.mob.eXoPlatformiPHone` as BundleID.

## Release

For each release we must update the version

    # increase the technical version
    xcrun agvtool new-version -all 12
    # increase the marketing version (not always needed)
    xcrun agvtool new-marketing-version 1.0.0

### beta on Appaloosa

To build a beta version of the app and upload it to Appaloosa, execute the following command :

    fastlane build_beta_ppr

### release on AppStore

To build a official version of the app and upload it to the AppStore, execute the following commands :

    fastlane build_appstore

