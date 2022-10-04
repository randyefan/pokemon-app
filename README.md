# Pokemon App
### Build Tools: 
- Xcode 14.0.1
- Swift 5
- Cocoapods 1.11.3 (Delete podfile.lock and .xcworkspace at the project if you have old version, don't forget to pod install then)

## Dependency Manager
This app using **cocoapods** as Dependency Manager to maintain third party library that needed to support the app. List of third party library that used in the app, listed below: 

1. **RxSwift** & **RxCocoa** ->  Library that help to created reactive programming in the app

2. **SDWebImage** -> Library that help to download and caching image from url that makes the app more efficient when load images from url

3. **SnapKit** -> Library that makes programatically set auto layout more easy for view

4. **SkeletonView** -> Library that helps to setup shimmer in app

5. **Alamofire** & **RxAlamofire** -> Library that helps to make request networking more easy and create readable code for networking stuff

6. **RxTest** -> Library that gives useful additions for testing Rx code

## Architecture
In this project, Im using **MVVM-Rx-CleanArchitecture** which separates the app into some layers and makes the app more testable. I'm also using usecase at domain  layer to define business process on the app. You can refer the image below to see the whole architecture.

[![](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/5CB48EE0-683C-4587-AE74-6343F5D71131.jpeg?token=GHSAT0AAAAAABY5HHEB5MMOAI4XVE27PWFSYZ4I27Q)](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/5CB48EE0-683C-4587-AE74-6343F5D71131.jpeg?token=GHSAT0AAAAAABY5HHEB5MMOAI4XVE27PWFSYZ4I27Q)

## Screenshot
|   |   |   |   |
| ------------ | ------------ | ------------ | ------------ |
|[![	](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/Simulator%20Screen%20Shot%20-%20iPhone%2012%20-%202022-10-04%20at%2001.03.43.png?token=GHSAT0AAAAAABY5HHEAXCEF6PHXT32TY3NMYZ4ISQA "	")](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/Simulator%20Screen%20Shot%20-%20iPhone%2012%20-%202022-10-04%20at%2001.03.43.png?token=GHSAT0AAAAAABY5HHEAXCEF6PHXT32TY3NMYZ4ISQA "	")|	|[![](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/Simulator%20Screen%20Shot%20-%20iPhone%2012%20-%202022-10-04%20at%2001.03.46.png?token=GHSAT0AAAAAABY5HHEAOCHXLVFGTHNCMC5MYZ4ITAA)](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/Simulator%20Screen%20Shot%20-%20iPhone%2012%20-%202022-10-04%20at%2001.03.46.png?token=GHSAT0AAAAAABY5HHEAOCHXLVFGTHNCMC5MYZ4ITAA)|[![](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/Simulator%20Screen%20Shot%20-%20iPhone%2012%20-%202022-10-04%20at%2001.03.53.png?token=GHSAT0AAAAAABY5HHEBAEPCO7WFNQLRVODIYZ4ITEA)](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/Simulator%20Screen%20Shot%20-%20iPhone%2012%20-%202022-10-04%20at%2001.03.53.png?token=GHSAT0AAAAAABY5HHEBAEPCO7WFNQLRVODIYZ4ITEA)|![](https://raw.githubusercontent.com/randyefan/pokemon-app/main/Screenshot/Simulator%20Screen%20Shot%20-%20iPhone%2012%20-%202022-10-04%20at%2001.04.00.png?token=GHSAT0AAAAAABY5HHEAXSQK5TAUS6XFVPSAYZ4ITHA)|
