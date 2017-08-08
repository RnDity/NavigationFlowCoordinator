# NavigationFlowCoordinator

Coordinators concept is design pattern helping organize flow of screens in your applications. It's nicely explained by Krzysztof Zabłocki in [this blog post](http://merowing.info/2016/01/improve-your-ios-architecture-with-flowcontrollers/).

`NavigationFlowCoordinator` is basic implementation of this pattern with some additional useful features.

## Coordinator
`Coordinator` protocol is an abstraction over objects that can start and finish some flow. Usually part of flow controlled by coordinator consists of few `UIViewControllers`. `Coordinator` protocol is very simple:
```swift
public protocol Coordinator: class {
    func start()
    func finish()
}
```

## Flow Coordinator
`FlowCoordinator` is basic implementation of `Coordinator` intended to be subclassed by specific coordinator implementation. `FlowCoordinator` introduces ability to chain coordinators by child-parent relationship. Any `FlowCoordinator` can start child coordinator by calling this method:

```swift
func start(childCoordinator: FlowCoordinator)
```
It also gives ability to send and handle `FlowEvents`. This mechanism is described in details later in this document.

## Navigation Flow Coordinator

`NavigationFlowCoordinator` is flow coordinator implementation helping to deal with controlling flow based on `UINavigationController`. It's designed to be subclassed rather than used "as is". Example of very basic implemenation can look like that: 

```swift
class MoviesListCoordinator: NavigationFlowCoordinator {

    override func createMainViewController() -> UIViewController? {
        let viewController = MoviesListViewController()
        viewController.flowDelegate = self
        return viewController
    }
}

extension MoviesListCoordinator: MovieListFlowDelegate {
    func addNewMovie() {
        // starts child coordinator that handles other part of flow
        start(childCoordinator: MovieCreateOrUpdateCoordinator(movieId: nil))
    }

    func showAbout() {
        // present view controller being part of flow controlled by this coordinator
        push(viewController: AboutViewController())
    }
}
```

Overriding `createMainViewController()` method is crucial as the view controller defined this way becomes "main view controller" of coordinator. It means that coordinator finishes its flow as soon as main view controller is popped from navigation controller. 
Presenting new view controller can be made by directly pushing it on navigation view controller or by using one of functions wrapping operations on navigation view controller (as in `showAbout()` method). 
When we want to switch to part of flow controlled by other coordinator we need to start child coordinator as in `addNewMovie()` method. Coordinators chained by child-parent relationship share instance of navigation controller unless any of them overrides `navigationController` property. 
When coordinator starts child coordinator it's not necessary to store reference to it as internal mechanism will keep this reference for us. The reference will be released once child coordinator finishes (either by popping its main view controller or by calling `finish()` method). 

## FlowEvent
Passing data from child cooridnator to its parent is usually made using delegates or blocks. 
Sometimes there might be many coordindators in chain and we might want to pass some data from last child coordinator to one of coordinators a few levels up in hierarchy. Doing it with delegates we would have to engage inner coordinators (coordinators between ones interested in passing data) and their delegates even if they are not interested at all in this particular event. We end up adding new methods in each delegate, adding code to trigger these methods on callback from child coordinator and so on. 
With usage of `FlowEvents`, solution to this problem is much simpler. `FlowEvents` mechanism adds ability to send event object being implementation of `FlowEvent` protocol. Example:
```swift
send(flowEvent: MovieUpdatedFlowEvent(movieId: movieId))
```

The event can be then handled by any of parent coordinators in chain that are interested in handling this particular event by overriding method:
```swift
override func handle(flowEvent: FlowEvent) -> Bool {
    if let movieUpdatedFlowEvent = flowEvent as? MovieUpdatedFlowEvent, movieUpdatedFlowEvent.movieId == movieId {
        movieDetailsViewController.invalidateMovieData()
    }
    return false
}
```

`Coordinator` handling the event can prevent event being sent further. Returning true from `handle(flowEvent:)` function causes the event will no longer be passed up in the hierarchy. By returning false we can handle the event still giving a chance to handle the event by any of parent coordinators.

## Example
In the NavigationFlowCoordinatorExample folder you can find example application using `NavigationFlowCoordinators`.

