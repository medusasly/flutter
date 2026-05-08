# Gas-Ly

A modern Flutter application for ordering cooking gas with M-Pesa integration. Users can browse gas products, add to cart, and pay via M-Pesa STK push.

## Features

- **Authentication**: Sign up and sign in with email/password
- **Product Catalog**: Browse gas cylinders from Total, K-Gas, and Shell brands
- **Search**: Filter products by name or brand
- **Shopping Cart**: Add products with quantity selector
- **Checkout**: Multiple payment options (M-Pesa, Card, Cash on Delivery)
- **M-Pesa Integration**: Real STK push payment via Safaricom Daraja API
- **Order History**: Track past orders
- **Profile Management**: View and manage user profile

## Screenshots

The app features a modern, warm UI design with:
- Coral/orange accent color (#FF6B4A)
- Clean white backgrounds
- Product cards with brand badges and quantity selectors
- Trust indicators (30 min delivery, 100% Safe, 24/7 Support)

## Prerequisites

Before running this project, ensure you have:

1. **Flutter SDK** (>=3.0.0) installed
   ```bash
   flutter --version
   ```

2. **Dart SDK** (comes with Flutter)

3. **Android Studio** or **Xcode** (for emulators)

4. **M-Pesa Daraja API Credentials** (for payments):
   - Consumer Key
   - Consumer Secret
   - Passkey
   - Shortcode

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure M-Pesa credentials (Environment Variables)**
   
   This app uses environment variables to securely store M-Pesa API credentials. **The `.env` file is already added to `.gitignore` and will NOT be committed to version control.**

   #### Step 1: Create a Safaricom Developer Account
   1. Go to [Safaricom Developer Portal](https://developer.safaricom.co.ke/)
   2. Click **"Sign Up"** and fill in your details
   3. Verify your email address
   4. Log in to the portal

   #### Step 2: Create a New App
   1. From the dashboard, click **"My Apps"** in the sidebar
   2. Click **"Create New App"**
   3. Enter an app name (e.g., "GasLy App")
   4. Enter a description (e.g., "Gas delivery app with M-Pesa integration")
   5. Click **"Create App"**

   #### Step 3: Subscribe to M-Pesa APIs
   1. Click on your newly created app
   2. Go to the **"Products"** tab
   3. Find **"MPesa Express (Sandbox)"** and click **"Subscribe"**
   4. The API will now be listed under your subscribed products

   #### Step 4: Get Consumer Key & Consumer Secret
   1. In your app, go to the **"Keys"** tab
   2. You will see:
      - **Consumer Key** - Copy this (looks like: `ABC123xyz789`)
      - **Consumer Secret** - Copy this (looks like: `xyz789ABC123`)
   3. These are used for OAuth authentication

   #### Step 5: Get Passkey and Shortcode
   1. Go to **"APIs"** → **"MPesa Express"** → **"Sandbox"**
   2. The sandbox provides default test credentials:
      - **Shortcode**: `174379` (this is the test till number)
      - **Passkey**: Click on **"Generate Passkey"** or use the provided test passkey
   3. Copy both values

   #### Step 6: Configure Environment Variables
   1. Copy the example environment file:
      ```bash
      cp .env.example .env
      ```
   2. Open `.env` and fill in your actual credentials:
      ```env
      MPESA_CONSUMER_KEY=your_actual_consumer_key_here
      MPESA_CONSUMER_SECRET=your_actual_consumer_secret_here
      MPESA_PASSKEY=your_actual_passkey_here
      MPESA_SHORTCODE=174379
      MPESA_ENV=sandbox
      ```
   3. **Important:** The `.env` file is automatically ignored by Git and will NOT be committed

   #### Step 7: Test Your Integration
   1. Run the app
   2. Add items to cart and proceed to checkout
   3. Select M-Pesa payment
   4. Enter test phone number: `254708374149`
   5. You should receive a simulated STK push (in sandbox mode, no actual SMS is sent)

   ### Sandbox Test Phone Numbers
   Use these numbers to test different scenarios:

   | Phone Number | Scenario |
   |--------------|----------|
   | `254708374149` | Successful payment |
   | `254708374150` | Insufficient funds |
   | `254708374151` | Wrong PIN |
   | `254708374152` | Transaction cancelled |

   ### Important Notes
   - **`.env` file is automatically ignored** - The `.env` file containing your real credentials is in `.gitignore` and won't be committed to Git
   - **Use `.env.example` as a template** - Copy it to `.env` and fill in your credentials without modifying the example file
   - **Sandbox mode** does not send real SMS messages - it's for testing only
   - The passkey is unique to your app and should be kept secure
   - For production, you'll need to apply for **Go Live** approval from Safaricom
   - Never commit your actual credentials to version control
   - **For production builds:** Make sure to update `MPESA_ENV=production` and use production credentials from Daraja portal

4. **Run the app**
   
   For Chrome (Web):
   ```bash
   flutter run -d chrome
   ```
   
   For Android Emulator:
   ```bash
   flutter run
   ```
   
   For iOS Simulator (Mac only):
   ```bash
   flutter run -d ios
   ```

## Building APK

To generate a release APK for Android:

1. **Build APK**
   ```bash
   flutter build apk --release
   ```

2. **Find the APK**
   The APK will be located at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Build App Bundle (for Play Store)**
   ```bash
   flutter build appbundle --release
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── products.dart            # Product model
├── providers/
│   ├── auth_provider.dart       # Authentication state
│   └── cart_provider.dart       # Shopping cart state
├── screens/
│   ├── auth_screen.dart         # Login/Register
│   ├── home.dart                # Home page with products
│   ├── cart.dart                # Shopping cart
│   ├── checkout.dart            # Payment method selection
│   ├── mpesa.dart               # M-Pesa payment
│   ├── order_summary.dart       # Order confirmation
│   ├── orders.dart              # Order history
│   ├── profile_screen.dart      # User profile
│   ├── main_screen.dart         # Main navigation wrapper
│   └── app_theme.dart           # Theme configuration
├── services/
│   └── mpesa_service.dart       # M-Pesa API integration
└── widgets/
    ├── product_card.dart        # Product display card
    └── cart_item.dart           # Cart item widget

assets/
└── images/                      # Product images and logos
    ├── logo.png
    ├── delivery_hero.png
    ├── total-13kg.png
    ├── total6kg.png
    ├── k-gas-13.png
    ├── k-gas.png
    ├── shell-13kg.png
    ├── shell-6kg.png
    └── regulator.png
```

## Dependencies

Key packages used:
- `provider` - State management
- `http` - API requests
- `crypto` - Password hashing for M-Pesa
- `intl` - Date/time formatting

## Demo Credentials

For testing without creating an account:
- **Email**: `demo@gasly.com`
- **Password**: `password123`

## M-Pesa Test Numbers (Sandbox)

Use these test phone numbers for M-Pesa payments in sandbox mode:
- `254708374149` - Successful payment
- `254708374150` - Insufficient funds
- `254708374151` - Wrong PIN

## Troubleshooting

### App doesn't run on Chrome
```bash
flutter create --platforms=web .
flutter run -d chrome
```

### M-Pesa payments not working
1. Verify your Daraja API credentials
2. Ensure you're using sandbox mode for testing
3. Check that the phone number is in format `2547XXXXXXXX`

### Images not loading
Ensure all assets are listed in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
```

## License

This project is for educational purposes. Please configure your own M-Pesa credentials for production use.
