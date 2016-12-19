# Pre-work - *TipMe*

**TipMe** is a tip calculator application for iOS.

Submitted by: **Daniel Zheng**

Time spent: **14** hours spent in total

- 2 hours: Watching tutorial, reading documentation
- 2 hours: Creating minimum viable app with basic features
- 1 hours: Add `defaults` feature
- 4.5 hours: Improve UI, add constraints with auto-layout *(most time consuming part)*
- 3 hours: Improve controller logic, link UI with controller
- 0.5 hours: Cleaning code, documentation

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage. *(Last tip percentage automatically becomes the new default.)*

The following **optional** features are implemented:
* [x] UI animations (occur when bill field becomes empty or not empty)
* [x] Saving the bill amount across app restarts
* [x] Saving the tip amount across app restarts
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Calculating cost of total bill split among 2-5 people

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/tr2JqlH.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

### Summary

This was my first experience creating an iOS app. I have previous experience with Android development, so the Xcode Storyboard builder was somewhat intuitive to me. I also have experience writing Swift from using the Vapor web framework, so I didn't feel limited by my lack of understanding of the language. This app was designed for the iPhone 6/6s: other iOS devices may encounter display issues.

### Difficulties

The biggest and only difficulty that I encountered was designing the UI for the app, particularly using constraints with auto-layout. It was frustrating for me (as a web developer) to spend hours creating simple constraints and aligning views. However, I am confident that it will become more natural to me with time.

### Future

I learned to use CocoaPods and `Podfile` while making this app with the intention of including some cool open-source UI components from Github. However, I didn't find any suitable ones for this project.

## Conclusion

I really enjoyed making this app and look forward to making more iOS applications in the future!

## License

    Copyright 2016 Dan Zheng

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
