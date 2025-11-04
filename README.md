[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
<!-- PROJECT LOGO -->
<p align="center">
  <h3 align="center">Flutter TDD Clean Architecture E-Commerce App - EShop</h3>
</p>

[![Product Name Screen Shot][product-screenshot]](https://example.com)


Welcome to the Flutter-TDD-Clean-Architecture-E-Commerce-App GitHub repository! This project is a showcase of modern mobile app development practices, leveraging the power of Flutter, Test-Driven Development (TDD), Clean Architecture, and the BLoC (Business Logic Component) package. Built using the latest version of Flutter 3, this E-Commerce application exemplifies best practices for building scalable, maintainable, and efficient Flutter apps.

## Key Features:

* **Test-Driven Development (TDD)**: This project emphasizes the importance of writing tests before writing the actual code. It ensures that the application's logic is thoroughly tested, enhancing reliability and maintainability.
* **Clean Architecture**: The app follows a clean and modular architecture that separates concerns into different layers: Presentation, Domain, and Data. This architecture promotes code reusability and makes it easier to adapt to changes in the future.
* **BLoC State Management**: The app utilizes the BLoC pattern for state management. BLoC helps manage the flow of data and business logic in a clean and reactive manner, improving overall app performance.
* **E-Commerce Functionality**: The app showcases a variety of E-Commerce features, such as product browsing, searching, cart and purchasing. Users can explore products, add them to their cart, and complete transactions seamlessly.
<!-- Features -->
---
| Feature       | UseCases                                                                                                                                                                                                   |
|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Product       | Get Product UseCase                                                                                                                                                                                        |
| Category      | Get Cached Category UseCase<br/>Get Remote Category UseCase<br/>Filter Category UseCase                                                                                                                    |
| Cart          | Get Cached Cart UseCase<br/>Get Remote Cart UseCase<br/>Add Cart Item UseCase<br/>Sync Cart UseCase                                                                                                        |
| User          | Get Cached User UseCase<br/>SignIn UseCase<br/>SignUp UseCase<br/>SignOut UseCase                                                                                                                          |
| Delivery Info | Get Cached Delivery Info UseCase<br/>Get Remote Delivery Info UseCase<br/>Add Delivery Info UseCase<br/>Edit Delivery Info UseCase<br/>Select Delivery Info UseCase<br/>Get Selected Delivery Info UseCase |
| Order         | Get Orders UseCase<br/>Add Order UseCase                                                                                                                                                                   |

---

## Demo Sample

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <img src="https://res.cloudinary.com/dhyttttax/image/upload/v1695741758/RepoAssets/home-loading_r39lc6.gif" width="200"/>
            </td>            
            <td style="text-align: center">
                <img src="https://res.cloudinary.com/dhyttttax/image/upload/v1695743869/RepoAssets/home-navigation-min_q1cou5.gif" width="200"/>
            </td>
            <td style="text-align: center">
                <img src="https://res.cloudinary.com/dhyttttax/image/upload/v1695744798/RepoAssets/product-details-order_j0lvw5.gif" width="200" />
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <img src="https://res.cloudinary.com/dhyttttax/image/upload/v1695745493/RepoAssets/user-delivery-infomarion_zr1eyv.gif" width="200"/>
            </td>
            <td style="text-align: center">
                <img src="https://res.cloudinary.com/dhyttttax/image/upload/v1695746530/RepoAssets/user-auth-screens_k3h6fw.gif" width="200"/>
            </td>
            <td style="text-align: center">
                <img src="https://res.cloudinary.com/dhyttttax/image/upload/v1695747060/RepoAssets/user-sign-in-loading_qjqmt0.gif" width="200"/>
            </td>
        </tr>
    </table>
</div>

## Contributing:

We welcome contributions from the Flutter community to make this project even better. Whether you are interested in adding new features, fixing bugs, or improving documentation, your contributions are highly appreciated. Please refer to the contribution guidelines in the repository for more details on how to get involved.

<!-- GETTING STARTED -->
## Getting Started

To get started with this project, follow the instructions in the README to set up your development environment and run the app locally. You can also explore the project's architecture, tests, and documentation to gain insights into building robust Flutter apps.

We hope this Flutter-TDD-Clean-Architecture-E-Commerce-App serves as a valuable resource for both Flutter enthusiasts and developers looking to learn about TDD, clean architecture, and BLoC in the context of mobile app development. Happy coding!

### Installation

Android Studio

A) Run/Debug (device/emulator or Chrome)

Edit Configurations… → select your Flutter app config.
Additional run args:
Debug/staging: --dart-define-from-file=.env.debug.json
Release-like run: --release --dart-define-from-file=.env.release.json
Select device (Android/Chrome) and Run. The app will see kGeminiApiKey from String.fromEnvironment('GEMINI_API_KEY').
B) Build APK/AAB via UI
You have three options:

Option 1: Custom “Flutter command” run config

Edit Configurations… → + → Flutter.
Name: Build APK (Release).
In “Additional run args”, put the full command sequence:
build apk --release --dart-define-from-file=.env.release.json
Run this configuration to produce the APK. Do a second one for appbundle if you need AAB:
build appbundle --release --dart-define-from-file=.env.release.json
Option 2: Gradle task with dart-defines (no Flutter CLI)

Open the Gradle tool window → Run configuration: Execute Gradle Task.
Task: app:assembleRelease
Arguments: -Pdart-defines=R0VNSU5JX0FQSV9LRVk9WUVPVVJfUFJPRFVDVElPTl9LRVk=
That base64 string is base64 of GEMINI_API_KEY=YOUR_PRODUCTION_KEY.
For multiple defines, join multiple base64-encoded pairs with commas:
-Pdart-defines=BASE64(KEY1=VAL1),BASE64(KEY2=VAL2)
This passes DART_DEFINES to the Flutter Gradle plugin, which injects them into the build.
Option 3: Terminal inside Android Studio

Use the built-in terminal and run:
flutter build apk --release --dart-define-from-file=.env.release.json
Same result, but fully controlled.
Notes

Option 1 is the most “Flutter-native” in the IDE. Option 2 is useful if you’re building purely via Gradle tasks.
Keep .env*.json out of Git (already ignored).
For debug device runs, prefer Option A; for packaged artifacts, prefer Option 1 or 3.
Xcode (Archive)

Flutter for iOS reads defines from the DART_DEFINES environment variable during build. Each define must be base64-encoded as KEY=VALUE and multiple entries are comma-separated.

Open Runner.xcworkspace in Xcode.
Product → Scheme → Edit Scheme…
Select both Run and Archive actions and set these:
Environment Variables:
Name: DART_DEFINES
Value: base64(GEMINI_API_KEY=YOUR_PRODUCTION_KEY)
Example (single define):
R0VNSU5JX0FQSV9LRVk9WU9VUl9QUk9EVUNUSU9OX0tFWQ==
For multiple defines, join with commas:
BASE64(KEY1=VAL1),BASE64(KEY2=VAL2)
Close and Product → Archive. The resulting IPA uses the provided key.
Tip: If you use different keys for Debug vs Release

Create separate Schemes or set different DART_DEFINES in the Scheme’s Run (Debug) vs Archive (Release) actions.
Or add per-configuration xcconfig variables and a pre-build script to compose DART_DEFINES from those.
Web builds in IDE

Android Studio Run to Chrome:
Same as Android Run/Debug: Additional run args → --dart-define-from-file=.env.debug.json
For release web builds, either:
Create a “Flutter command” run config:
build web --release --dart-define-from-file=.env.release.json
Or use the terminal inside the IDE to run the command above.
Runtime code reminder

Read the key using:
const String kGeminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
Ensure your Gemini client reads this at startup and disables the feature or shows a helpful message if empty.
Security note

Client-side keys (Web/Android/iOS) can be extracted. If you need strong protection, place the Gemini call server-side (e.g., Firebase Functions) and keep the key off the client entirely. You can keep your current client flow and switch just the transport to your function without changing UI.
For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App.svg?style=for-the-badge
[contributors-url]: https://github.com/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App.svg?style=for-the-badge
[forks-url]: https://github.com/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App/network/members
[stars-shield]: https://img.shields.io/github/stars/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App.svg?style=for-the-badge
[stars-url]: https://github.com/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App/stargazers
[issues-shield]: https://img.shields.io/github/issues/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App.svg?style=for-the-badge
[issues-url]: https://github.com/Sameera-Perera/Flutter-TDD-Clean-Architecture-E-Commerce-App/issues
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: http://www.linkedin.com/in/sameera-perera-1148081b8
[product-screenshot]: readme_assets/splash.jpg