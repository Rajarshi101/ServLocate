import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'main_navigation_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController uidController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login to ServLocate')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: uidController,
              decoration: const InputDecoration(labelText: 'Enter UID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final uid = uidController.text.trim();
                if (uid.isEmpty) return;

                try {
                  await CometChatUIKit.login(uid);
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainNavigationScreen(currentUid: uid),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
