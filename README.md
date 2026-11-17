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

- App title in the app bar, custom blue theme and status bar icons
- Navigation menu (three-dot menu) with **Home** and **About**
- Ticket class chosen with radio buttons
- Error messages for empty, invalid or zero inputs (letters cannot be typed)
- Instructions and helpful notices (free allowance, 8% service tax)
- Result card with the three outputs, and a Reset button
- About page with app icon, author information, copyright notice and a clickable GitHub link
- Custom launcher icon (`flutter_launcher_icons`)

## Project structure

```
lib/
  main.dart         App, theme, app bar and navigation menu
  home_page.dart    Inputs, calculation and result
  about_page.dart   About page
```

## Run

```
flutter pub get
flutter run
```

## Author

Muhammad Nur Hafiz bin Mohd Zaid
