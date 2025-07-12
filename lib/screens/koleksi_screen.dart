import 'dart:convert';
import 'package:cookpad_clone/models/resep_model.dart';
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
    Future.microtask(() =>
        Provider.of<ResepProvider>(context, listen: false).fetchResepDariFirestore());
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
    });

    // Set userId login ke provider
    Provider.of<ResepProvider>(context, listen: false).setUserLoginId(userId);
  }

  @override
  Widget build(BuildContext context) {
    final resepProvider = Provider.of<ResepProvider>(context);
    final resepList = resepProvider.koleksiResep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Resep'),
        backgroundColor: const Color(0xFFF8AE0C),
      ),
      body: resepList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada resep yang disimpan',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
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
                    color: const Color(0xFFFDF9F3),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: resep.gambarUrl != null && resep.gambarUrl!.isNotEmpty
                            ? (resep.gambarUrl!.startsWith('http')
                                ? Image.network(
                                    resep.gambarUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 40);
                                    },
                                  )
                                : Image.memory(
                                    base64Decode(resep.gambarUrl!),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 40);
                                    },
                                  ))
                            : const Icon(Icons.image, size: 40),
                      ),
                      title: Text(
                        resep.nama ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${resep.porsi ?? '-'} orang • ${resep.durasi ?? '-'} menit\noleh: ${resep.username ?? 'Anonim'}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
