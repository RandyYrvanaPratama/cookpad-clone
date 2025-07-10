import 'package:cookpad_clone/provider/resep_provider.dart';
import 'package:cookpad_clone/screens/detail_resep_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KoleksiScreen extends StatefulWidget {
  const KoleksiScreen({super.key});

  @override
  State<KoleksiScreen> createState() => _KoleksiScreenState();
}

class _KoleksiScreenState extends State<KoleksiScreen> {
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final resepProvider = Provider.of<ResepProvider>(context);
    final koleksi = resepProvider.koleksiResep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Resep'),
        backgroundColor: const Color(0xFFF8AE0C),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFF8AE0C)),
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.orange),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: koleksi.isEmpty
          ? const Center(child: Text('Belum ada resep yang disimpan.'))
          : ListView.builder(
              itemCount: koleksi.length,
              itemBuilder: (context, index) {
                final resep = koleksi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailResepScreen(resep: resep),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    color: const Color(0xFFFDF9F3),
                    child: ListTile(
                      leading: resep.gambarUrl.isNotEmpty
                          ? Image.network(
                              resep.gambarUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 40),
                            )
                          : const Icon(Icons.image, size: 40),
                      title: Text(resep.nama),
                      subtitle: Text('${resep.porsi} • ${resep.durasi}'),
                    ),
                  ),
                );
              },
            ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF8AE0C),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-resep');
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFF8AE0C),
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari Resep',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Koleksi',
          ),
        ],
      ),
    );
  }
}
