import 'package:cookpad_clone/models/resep_model.dart';
import 'package:cookpad_clone/provider/resep_provider.dart';
import 'package:cookpad_clone/screens/detail_resep_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String username = '';
  String email = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Future.microtask(() =>
        Provider.of<ResepProvider>(context, listen: false).fetchResepDariFirestore());
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      userId = prefs.getString('userId') ?? '';
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
    final resepList = _searchQuery.isEmpty
        ? resepProvider.resepDipublikasikan
        : resepProvider.cariResep(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Resep'),
        backgroundColor: Colors.orange.shade400,
        elevation: 0,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Cari resep masakan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: resepList.isEmpty
                ? const Center(child: Text('Tidak ada resep ditemukan.'))
                : ListView.builder(
                    itemCount: resepList.length,
                    itemBuilder: (context, index) {
                      final resep = resepList[index];
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
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: resep.gambarUrl != null && resep.gambarUrl!.isNotEmpty
                                    ? (resep.gambarUrl!.startsWith('http')
                                        ? Image.network(
                                            resep.gambarUrl!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.broken_image, size: 40),
                                              );
                                            },
                                          )
                                        : Image.memory(
                                            base64Decode(resep.gambarUrl!),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.broken_image, size: 40),
                                              );
                                            },
                                          ))
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image, size: 40),
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              resep.nama ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.bookmark_border),
                                            onPressed: () {
                                              Provider.of<ResepProvider>(context, listen: false)
                                                  .simpanResepDariOrangLain(resep, userId);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Resep disimpan ke koleksi!'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${resep.porsi ?? '-'} orang • ${resep.durasi ?? '-'} menit',
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'oleh: ${resep.username ?? 'Anonim'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade400,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-resep');
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange.shade400,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/koleksi');
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
