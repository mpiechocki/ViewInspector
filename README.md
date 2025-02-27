# ViewInspector for SwiftUI

[![Build Status](https://travis-ci.com/nalexn/ViewInspector.svg?branch=master)](https://travis-ci.com/nalexn/ViewInspector) [![codecov](https://codecov.io/gh/nalexn/ViewInspector/branch/master/graph/badge.svg)](https://codecov.io/gh/nalexn/ViewInspector) ![Platform](https://img.shields.io/badge/platform-ios%20%7C%20tvos%20%7C%20watchos%20%7C%20macos-lightgrey)

**ViewInspector** is a library for unit testing SwiftUI-based projects.
It allows for traversing SwiftUI view hierarchy in runtime providing direct access to the underlying View structs.

## Why?

SwiftUI views are a function of state. We can provide the input, but couldn't verify the output. Until now.

## Features

#### 1. Verify the view's inner state

You can dig into the hierarchy and read actual state values on any SwiftUI View:

```swift
let view = ContentView()
let value = try view.inspect().text().string()
XCTAssertEqual(value, "Hello, world!")
```

#### 2. Extract your views from the hierarchy

It is possible to obtain a copy of your custom view with actual state and references from the hierarchy of any depth:

```swift
let customView = try view.inspect().anyView().view(CustomView.self)
let sut = customView.actualView()
XCTAssertTrue(sut.isToggleOn)
```

#### 3. Trigger side effects

Simulate user interaction by programmatically triggering system controls callbacks:

```swift
let view = ContentView()
let button = try view.inspect().hStack().button(3)
try button.tap()

let textField = try view.inspect().hStack().textField(2)
try textField.callOnCommit()
```

### Is it using private APIs?

**ViewInspector** is using official Swift reflection API to dissect the view structures. So this library is production-friendly, although it's strongly recommended to use it for debugging and unit testing purposes only.

## How do I add it to my Xcode project?

1. In Xcode select **File ⭢ Swift Packages ⭢ Add Package Dependency...**
2. Copy-paste repository URL: **https://github.com/nalexn/ViewInspector**
3. Hit **Next** two times, under **Add to Target** select your test target
4. Hit **Finish**

## How do I use it in my project?

Cosidering you have a view:

```swift
struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
    }
}
```
Your test file would look like this:

```swift
import XCTest
import ViewInspector // 1.
@testable import MyApp

extension ContentView: Inspectable { } // 2.

final class ContentViewTests: XCTestCase {

    func testStringValue() throws { // 3.
        let sut = ContentView()
        let value = try sut.inspect().text().string() // 4.
        XCTAssertEqual(value, "Hello, world!")
    }
}
```
So, you need to do the following:

1. Add `import ViewInspector`
2. Extend your view to conform to `Inspectable` in the test target scope.
3. Annotate the test function with `throws` keyword to not mess with the bulky `do { } catch { }`. Test fails automatically upon exception.
4. Start the inspection with `.inspect()` function

## Inspection guide

After the `.inspect()` call you need to repeat the structure of the `body` by chaining corresponding functions named after the SwiftUI views.

```swift
struct MyView: View {
    var body: some View {
        HStack {
           Text("Hi")
           AnyView(OtherView())
        }
    }
}

struct OtherView: View {
    var body: some View {
        Text("Ok")
    }
}
```

In this case you can obtain access to the `Text("Ok")` with the following chain:

```swift
let view = MyView()
view.inspect().hStack().anyView(1).view(OtherView.self).text()
```

Note that after `.hStack()` you're required to provide the index of the view you're retrieving: `.anyView(1)`. For obtaining `Text("Hi")` you'd call `.text(0)`.

You can save the intermediate result in a variable and reuse it for further inspection:

```swift
let view = MyView()
let hStack = try view.inspect().hStack()
let hiText = try hStack.text(0)
let okText = try hStack.anyView(1).view(OtherView.self).text()
```

### Custom views using `@EnvironmentObject`

Currently, **ViewInspector** does not support SwiftUI's native environment injection through `.environmentObject(_:)`, however you still can inspect such views by explicitely providing the environment object to every view that uses it. A small refactoring of the view's source code is required.

Consider you have a view that has a `@EnvironmentObject` variable:

```swift
struct MyView: View {

    @EnvironmentObject var state: GlobalState
    
    var body: some View {
        Text(state.showHi ? "Hi" : "Bye")
    }
}
```

You can inspect it with **ViewInspector** after refactoring the following way:

```swift
struct MyView: View, InspectableWithEnvObject {

    @EnvironmentObject var state: GlobalState
    
    var body: Body {
        content(state)
    }
    
    func content(_ state: GlobalState) -> some View {
        Text(state.showHi ? "Hi" : "Bye")
    }
}
```

After that you can extract the view in tests by explicitely providing the environment object:

```swift
let envObject = GlobalState()
let view = MyView()
let value = try view.inspect(envObject).text().string()
XCTAssertEqual(value, "Hi")
```

For the case when view is embedded in the hierarchy:

```swift
let envObject = GlobalState()
let view = HStack { AnyView(MyView()) }
try view.inspect().anyView(0).view(MyView.self, envObject)
```

Note that you don't need to call `.environmentObject(_:)` in these cases.

## Library readiness

- [ ] AngularGradient
- [x] AnyView
- [x] Button
- [ ] ButtonStyleConfiguration.Label
- [x] Custom view (SwiftUI and UIKit)
- [x] DatePicker
- [x] Divider
- [x] EditButton
- [x] EquatableView
- [x] ForEach
- [x] Form
- [x] GeometryReader
- [x] Group
- [x] GroupBox
- [x] HSplitView
- [x] HStack
- [x] Image
- [ ] LinearGradient
- [x] List
- [ ] MenuButton
- [x] ModifiedContent
- [x] NavigationLink
- [x] NavigationView
- [ ] PasteButton
- [x] Picker
- [ ] PrimitiveButtonStyleConfiguration.Label
- [ ] RadialGradient
- [x] ScrollView
- [x] Section
- [x] SecureField
- [x] Slider
- [x] Stepper
- [x] TabView
- [x] Text
- [x] TextField
- [x] Toggle
- [ ] ToggleStyleConfiguration.Label
- [x] VSplitView
- [x] VStack
- [x] ZStack

### Contributions are welcomed!

---

![license](https://img.shields.io/badge/license-mit-brightgreen) [![Twitter](https://img.shields.io/badge/twitter-nallexn-blue)](https://twitter.com/nallexn) [![blog](https://img.shields.io/badge/blog-medium-red)](https://medium.com/@nalexn)