[![node CI](https://github.com/markCwatson/budgetpals_client/actions/workflows/dart.yml/badge.svg?branch=main)](https://github.com/markCwatson/budgetpals_client/actions/workflows/dart.yml)

# budgetpals_client (WIP)

A mobile client for budgetpals. 

Uses the [budgetpals API](https://github.com/markCwatson/budgetpals) (which is WIP).

This app is my first ever attempt at creating a mobile application, and my first time using Flutter/Dart. The state-management architecture is based on the BLoC pattern using `flutter_bloc` ^v8.1.1.

# Internal testing: TestFlight
This app is available from Apple for internal testing for registered testers using TestFlight.

# Demo (Sept 17, 2023)

Here is a demo of the app running in an iOS simulator connected to the [budgetpals backend](https://github.com/markCwatson/budgetpals). First, here is the basic account creation flow where the user enters an email, name, and password.

![alt-text][1]

Next, when a user signs in for the first time, they are prompted to setup their first budget. The user specifies their starting account balance, the budget period (bi-weekly, monthly, etc.), and the starting date.

![alt-text][2]

Next, the user can build out their budget by adding "planned items" (expenses and incomes). The user specifies dates for the planned items, and the app automatically determines which bi-weekly/monthly/etc. period you are in, then displays planned expenses/incomes that apply to the current period. The summary card shows you planned vs "actual" income/expenses and the starting/ending account balances.

![alt-text][3]

Finally, as money exits the user's bank account, these "actual" transactions are recorded on the Expenses and Income tabs. The user can add unplanned items or they can select planned items that were added to their budget. The summery card in the Budget tab will update the charts and projections based on the actual incomes/expenses as they occur.

![alt-text][4]

Shoutout to [ezgif.com](https://ezgif.com/video-to-gif) for helping me create these GIFs!

[1]: gif/2023.09.17-create-account.gif "Account creation"
[2]: gif/2023.09.17-signin-setup.gif "Sign in and setup budget"
[3]: gif/2023.09.17-planned-items.gif "Planned items"
[4]: gif/2023.09.17-actual-items.gif "Actual items"

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
flutter run -d 9DB1D9E8-8F0A-4FC8-B8ED-9D944B7CDE09
```