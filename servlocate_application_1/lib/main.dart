import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'screens/splash_screen.dart'; // splash will go to login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // CometChat credentials
  const appId = '27810800d9ebef6d';
  const region = 'in';
  const authKey = '20a19597a8b4e8a9ac50d0458aad77c01aedd5ec';

  UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
        ..subscriptionType = CometChatSubscriptionType.allUsers
        ..region = region
        ..appId = appId
        ..authKey = authKey)
      .build();

  await CometChatUIKit.init(uiKitSettings: uiKitSettings);

  runApp(const ServLocateApp());
}

class ServLocateApp extends StatelessWidget {
  const ServLocateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServLocate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(), // This should go to login, then to main app
    );
  }
}
