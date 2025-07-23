import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final api = ApiService(FirebaseAuth.instance);
  List<dynamic> users = [];
  List<dynamic> decks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);
    users = await api.getAllUsers();
    decks = await api.getAllDecksAdmin();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Users', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ...users.map((u) => ListTile(
                        title: Text(u['email']),
                        subtitle: Text('Role: ${u['role']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await api.deleteUser(u['_id']);
                            fetchData();
                          },
                        ),
                      )),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('All Decks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ...decks.map((d) => ListTile(
                        title: Text(d['title']),
                        subtitle: Text('User: ${d['userId']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await api.deleteDeckAdmin(d['_id']);
                            fetchData();
                          },
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
