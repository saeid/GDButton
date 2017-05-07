# GDButton

Animated menu button for iOS

![1](https://cloud.githubusercontent.com/assets/9967486/24078805/1cc2e75c-0c8d-11e7-9a47-926ada6ca641.gif)


## Requirements
- xcode 8+
- swift 3+
- iOS 8+


## Installation
Install manually
------
Drag "GDButton.swift" to your project and use!

Install using Cocoapods
------
Soon!


## How to use

```swift
    //create an instance of GDButton() or assign to a view in storyboard
    let buttonView = GDButton()

    func createSampleButtons(){
        buttonView.addButton(with: "test number 1", icon: UIImage(named: "icon1")!, handler: { _ in
            print("Hello! i am button 1")
            self.buttonView.openCloseView()
        })
        buttonView.addButton(with: "test number 2", icon: UIImage(named: "icon2")!, handler: { _ in
            print("Hello! i am button 2")
            self.buttonView.openCloseView()
        })
        buttonView.addButton(with: "test number 3", icon: UIImage(named: "icon3")!, handler: { _ in
            print("Hello! i am button 3")
            self.buttonView.openCloseView()
        })
        buttonView.addButton(with: "test number 4", icon: UIImage(named: "icon4")!, handler: { _ in
            print("Hello! i am button 4")
            self.buttonView.openCloseView()
        })
    }
```