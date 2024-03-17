import 'package:flutter/material.dart';
import 'package:its_urgent_poc/services/auth.dart';
import 'package:its_urgent_poc/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isLoading = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _mobileNumberController.text.isNotEmpty &&
          _nameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {

    _isButtonEnabled = false;
    _isLoading = false;
    super.dispose();
  }

  void _signIn(BuildContext context) async {
    // Close the keyboard
    FocusScope.of(context).unfocus();

    // Set isLoading to true to show progress indicator
    setState(() {
      _isLoading = true;
      _isButtonEnabled = false;
    });
// Call the signInAnonymously method from FirebaseAuthMethods
    await context.read<FirebaseMethods>().signInAnonymously(
          context,
          mobileNumber: _mobileNumberController.text,
          displayName: _nameController.text,
        );

    // faking sign in.
    // await Future.delayed(const Duration(seconds: 3));

    // Sign-in successful, set isLoading back to false
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              enabled: !_isLoading,
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
              ),
              onChanged: (_) => _updateButtonState(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              enabled: !_isLoading,
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (_) => _updateButtonState(),
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              onTap: _isButtonEnabled ? () => _signIn(context) : null,
              text: "Sign In",
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
