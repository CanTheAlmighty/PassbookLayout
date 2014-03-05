PassbookLayout (iOS 6+)
===============

Mimicking the behaviour of the Passbooks apps in iOS using a custom UICollectionViewLayout.

![Crappy gif ahoy!](images/demo.gif)

##Intended use
This collection view is suitable for applications that want to mimick the behaviour of the included Apple Passbook on iOS devices (iOS 6 onwards).

This collection view layout is rather inneficient compared to other layouts, it invalidates for each change of bounds to support it's fancy animations, but it only recalculates the currently visible cells, so it supports big numbers of data, as long as the drawing time on each cell is not big. 

It does not use `UIDynamics`, just math.

## Version History
v1.0.0 The passbook layout supports selection, stacking on top, bottom and 
