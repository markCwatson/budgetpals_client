# budgetpals_client (WIP)

A mobile client for budgetpals. 

Uses the [budgetpals API](https://github.com/markCwatson/budgetpals) (which is WIP).

This app is my first ever attempt at creating a mobile application, and my first time using Flutter/Dart.

# Progress (as of Aug 27, 2023)

Here is the app running in an iOS simulator connected to the budgetpals backend. Only the add account, sign in/authorization, fetching expenses, and adding expenses is working so far.

The app architecture uses the BLoC pattern using `flutter_bloc` ^v8.1.1.

![alt-text][1]

[1]: gif/2023.08.25_budgetpals_app.gif "The budgetpals app running"

# Running app on iOS simulator
First, you need to run the [budgetpals API](https://github.com/markCwatson/budgetpals) on the same network. Instructions can be found there for how to build and run all of the Docker containers. All of the networking is taken care of using Docker's networking functionality.

You can use VS Vode and the Flutter plugin to manage running the app, but it can also be run in the terminal. Assuming you have Xcode and a simulator installed, run the simulator.

```
open -a Simulator
```

Next, get a list of the devices recognized by Flutter

```
flutter devices
```

Here is a partial representation of the response I get (to fit everything in small space):

```
3 connected devices:

iPhone 14 Pro (mobile) • 9DB1D9E8-8F0A-4FC8-B8ED-9D944B7CDE09
macOS (desktop)        • macos
Chrome (web)           • chrome
```

Finally, run the app on the `iPhone 14 Pro (mobile)` with a device ID of `9DB1D9E8-8F0A-4FC8-B8ED-9D944B7CDE09`, in my case.

```
flutter run --dart-define=API_URL=http://localhost:3333 -d 9DB1D9E8-8F0A-4FC8-B8ED-9D944B7CDE09
```