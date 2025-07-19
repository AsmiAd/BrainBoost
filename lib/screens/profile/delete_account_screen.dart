import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in again to delete your account')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Delete My Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }
}
