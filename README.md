# Baggage Fee Estimator

A Flutter mobile app that estimates the **excess baggage fee** for air travel.
Mobile Technology individual assignment (CLO2).

## Inputs

| Input | Notes |
|---|---|
| Checked baggage weight (kg) | Up to 2 decimal places, must be more than 0 |
| Ticket class | Economy (free allowance 20 kg) or Business (free allowance 40 kg) |
| Excess baggage rate per kg (RM) | Up to 2 decimal places, must be more than 0 |

## Outputs

| Output | Formula |
|---|---|
| Excess baggage weight | `weight - X` (X = 20 kg economy, 40 kg business). Never negative: 0 kg if the weight is not more than X |
| Excess baggage charge | `excess weight x rate per kg` |
| Total amount payable | `excess charge + (8% x excess charge)` |

## Sample results

| Weight | Class | Rate/kg | Excess weight | Excess charge | Total payable |
|---|---|---|---|---|---|
| 25 kg | Economy | RM15 | 5 kg | RM75.00 | RM81.00 |
| 18 kg | Economy | RM15 | 0 kg | RM0.00 | RM0.00 |
| 55 kg | Business | RM12 | 15 kg | RM180.00 | RM194.40 |
| 42.5 kg | Business | RM12 | 2.5 kg | RM30.00 | RM32.40 |

## Features

- App title in the app bar
- Navigation drawer with **Home** and **About**
- Input validation (empty, invalid or zero values show an error; letters cannot be typed)
- Result card showing how each value was worked out
- About page with app icon, author information, copyright notice and a clickable GitHub link
- Custom launcher icon (`flutter_launcher_icons`)
- Unit and widget tests (`flutter test`)

## Project structure

```
lib/
  main.dart                 App, theme, navigation drawer
  app_info.dart             App title and author details
  baggage_calculator.dart   Calculation logic (no UI code)
  formatters.dart           Number / RM / kg formatting
  pages/
    home_page.dart          Input form and result
    about_page.dart         About page
test/
  baggage_calculator_test.dart
  widget_test.dart
```

## Run

```
flutter pub get
flutter run
flutter test
```

## Author

Muhammad Nur Hafiz bin Mohd Zaid
