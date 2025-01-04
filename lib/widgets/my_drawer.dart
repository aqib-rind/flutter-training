import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:profondo/utils/auth.dart';
import 'package:profondo/utils/global_state.dart';
import 'package:profondo/utils/routes.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);
    var imageUrl = globalState.imagePath;
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = AuthService();

    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).dividerColor),
        child: Column(
          // Changed from ListView to Column
          children: [
            Expanded(
              // This will contain your existing ListView
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, MyRoutes.profileRoute);
                    },
                    child: DrawerHeader(
                        padding: EdgeInsets.zero,
                        child: UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor),
                            margin: EdgeInsets.zero,
                            currentAccountPicture: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                            accountName: Text(
                                "${globalState.firstName} ${globalState.lastName}"),
                            accountEmail: Text(globalState.email))),
                  ),
                  // Your existing ListTiles...
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, MyRoutes.homeRoute);
                    },
                    leading: const Icon(
                      CupertinoIcons.home,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, MyRoutes.uploadRoute);
                    },
                    leading: const Icon(
                      Icons.upload_file,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Upload Paper",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(
                          context, MyRoutes.myPapersRoute);
                    },
                    leading: const Icon(
                      Icons.description_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "My Research",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // Sign Out Button at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  "Sign Out",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  _auth.signout();
                  globalState.clearUserData();
                  await Navigator.pushReplacementNamed(
                      context, MyRoutes.loginRoute);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
