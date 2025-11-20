import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/components/navbar.dart';
import 'package:project_akhir/models/user_model.dart';
import 'package:project_akhir/models/lapangan_model.dart';
import 'package:project_akhir/services/auth/auth_service.dart';
import 'package:project_akhir/services/location_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  List<TempatOlahraga> _lapanganTerdekat = [];
  List<TempatOlahraga> _lapanganRekomendasi = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadLapangan();
    _loadRekomendasi();
  }

  void _loadCurrentUser() {
    setState(() {
      _currentUser = _authService.getCurrentUser();
    });
  }

  void _loadLapangan() async {
    try {
      final pos = await LocationService.getCurrentPosition();
      final userLat = pos.latitude;
      final userLon = pos.longitude;

      final box = Hive.box<TempatOlahraga>('lapanganBox');
      final semua = box.values
          .where((item) => item is TempatOlahraga)
          .map((e) => e as TempatOlahraga)
          .toList();

      final List<Map<String, dynamic>> listDenganJarak = semua.map((lap) {
        final jarak = Geolocator.distanceBetween(
          userLat,
          userLon,
          lap.latitude,
          lap.longitude,
        );

        return {"lap": lap, "jarak": jarak};
      }).toList();

      listDenganJarak.sort((a, b) => a["jarak"].compareTo(b["jarak"]));

      final terdekat =
          listDenganJarak.take(5).map((e) => e["lap"] as TempatOlahraga).toList();

      setState(() {
        _lapanganTerdekat = terdekat;
      });
    } catch (e) {
      print("Gagal memuat lapangan terdekat: $e");
    }
  }

  void _loadRekomendasi() {
    try {
      final box = Hive.box<TempatOlahraga>('lapanganBox');
      final semua = box.values
          .where((item) => item is TempatOlahraga)
          .map((e) => e as TempatOlahraga)
          .toList();

      final rekom =
          semua.where((lap) => lap.ratingAvg >= 4.5).take(5).toList();

      setState(() {
        _lapanganRekomendasi = rekom;
      });
    } catch (e) {
      print("Gagal memuat rekomendasi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              // padding: EdgeInsets.all(30),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                ),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        // ============================
                        // GREETING BOX
                        // ============================
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Halo, ${_currentUser?.firstName ?? 'Pengguna'}!",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Row(
                                spacing: 15,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.notifications,
                                        size: 20,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    
                        SizedBox(height: 20),
                    
                        // ============================
                        // BANNER BOOKING
                        // ============================
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/bookingsekarang.jpg',
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 25.0,
                                  ),
                                  child: Text(
                                    "Pertandinganmu\nSelanjutnya Menanti",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      height: 1.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    height: 80,
                                    padding: const EdgeInsets.all(20.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/search');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        "Booking Sekarang",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    
                        SizedBox(height: 20),
                    
                        // ============================
                        // BOOKING SAYA BOX
                        // ============================
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => Navigator.pushNamed(
                                      context, '/booking_saya'),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month,
                                            size: 24, color: Colors.white),
                                        SizedBox(width: 30),
                                        Text("Booking Saya",
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    
                        SizedBox(height: 30),
                    
                        // ============================
                        // LAPANGAN TERDEKAT
                        // ============================
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lapangan Terdekat",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                    
                            SizedBox(
                              height: 170,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _lapanganTerdekat.length,
                                separatorBuilder: (_, __) => SizedBox(width: 15),
                                itemBuilder: (context, index) {
                                  final lap = _lapanganTerdekat[index];
                    
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/detail_lapangan',
                                        arguments: lap,
                                      );
                                    },
                                    child: Container(
                                      width: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border:
                                            Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                            child: Image.network(
                                              lap.imageUrl,
                                              height: 90,
                                              width: 140,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 90,
                                                  width: 140,
                                                  color: Colors.grey[200],
                                                  child: Icon(Icons
                                                      .image_not_supported),
                                                );
                                              },
                                            ),
                                          ),
                    
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              lap.namaTempat,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                    
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.star,
                                                    size: 14,
                                                    color: Colors.amber),
                                                SizedBox(width: 4),
                                                Text(
                                                  lap.ratingAvg
                                                      .toStringAsFixed(1),
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    
                        SizedBox(height: 30),
                    
                        // ============================
                        // REKOMENDASI (NEW!)
                        // ============================
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rekomendasi (>= 4.5)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                    
                            SizedBox(
                              height: 170,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _lapanganRekomendasi.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 15),
                                itemBuilder: (context, index) {
                                  final lap = _lapanganRekomendasi[index];
                    
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/detail_lapangan',
                                        arguments: lap,
                                      );
                                    },
                                    child: Container(
                                      width: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border:
                                            Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                            child: Image.network(
                                              lap.imageUrl,
                                              height: 90,
                                              width: 140,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 90,
                                                  width: 140,
                                                  color: Colors.grey[200],
                                                  child: Icon(Icons
                                                      .image_not_supported),
                                                );
                                              },
                                            ),
                                          ),
                    
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              lap.namaTempat,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                    
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.star,
                                                    size: 14,
                                                    color: Colors.amber),
                                                SizedBox(width: 4),
                                                Text(
                                                  lap.ratingAvg
                                                      .toStringAsFixed(1),
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    
                        SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // NAVBAR TETAP
            const Navbar(),
          ],
        ),
      ),
    );
  }
}
