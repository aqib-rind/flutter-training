import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:profondo/utils/global_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home'); // Navigate to home page
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: globalState.imagePath.isNotEmpty
                    ? NetworkImage(globalState.imagePath)
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
                radius: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${globalState.firstName} ${globalState.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${globalState.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Department: ${globalState.dept}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'User ID: ${globalState.userId}',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => navigateToHome(context), // Go back to home
                  icon: const Icon(Icons.home),
                  label: const Text('Back '),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Code for editing profile
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
