// lib/screens/lapangan_detail.dart (Perubahan: Menggunakan LapanganService)

import 'package:flutter/material.dart';
import '../models/lapangan_model.dart';
import '../services/lapangan_service.dart'; // <--- Import LapanganService yang benar

class LapanganDetail extends StatefulWidget {
  final TempatOlahraga tempat;

  const LapanganDetail({super.key, required this.tempat});

  @override
  State<LapanganDetail> createState() => _LapanganDetailState();
}

class _LapanganDetailState extends State<LapanganDetail> {
  // 1. Ganti inisialisasi dari ApiService menjadi LapanganService
  final LapanganService lapanganService = LapanganService();

  // Fungsi helper untuk menampilkan bintang rating
  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    }
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.amber.withOpacity(0.5), size: 16));
    }
    return Row(children: stars);
  }

  // Fungsi helper untuk memformat harga menjadi Rupiah
  String _formatRupiah(int amount) {
    String str = amount.toString();
    String result = '';
    int counter = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      counter++;
      result = str[i] + result;
      if (counter % 3 == 0 && i != 0) {
        result = '.' + result;
      }
    }
    return 'Rp$result';
  }


  @override
  Widget build(BuildContext context) {
    final tempat = widget.tempat;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // --- GAMBAR LAPANGAN (DARI URL) ---
                Container(
                  width: double.infinity,
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      tempat.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => 
                        const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                    ),
                  )
                ),
                const SizedBox(height: 20),
                // --- DETAIL TEKS ---
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Tempat
                      Text(
                        tempat.namaTempat,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Jenis Lapangan & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.sports_soccer, color: Colors.black, size: 16),
                              const SizedBox(width: 5),
                              Text(tempat.jenisLapangan),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 10, 
                            width: 1, 
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              _buildRatingStars(tempat.ratingAvg),
                              const SizedBox(width: 5),
                              Text(tempat.ratingAvg.toString()),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Lokasi & Tombol Maps
                      Row(
                        children: [
                          const Icon(Icons.location_city, color: Colors.black, size: 16),
                          const SizedBox(width: 5),
                          Text(tempat.lokasiWilayah),
                          const SizedBox(width: 15),
                          // Tombol Google Maps
                          InkWell(
                            onTap: () {
                              // 2. Panggil openMap dari LapanganService
                              lapanganService.openMap(tempat.latitude, tempat.longitude);
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.map, color: Colors.blue, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  "Lihat di Maps",
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Jam Operasional
                      const Row(
                        children: [
                          Icon(Icons.alarm, color: Colors.black, size: 16),
                          SizedBox(width: 5),
                          Text("Setiap Hari, 08.00 - 23.00 WIB"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Box Harga
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Mulai dari",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _formatRupiah(tempat.hargaSewa),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 238, 238, 238),
                width: 1
              )
            )
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black,
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: (){
                Navigator.pushNamed(context, '/booking', arguments: tempat);
              },
              child: const Text(
                "Book Sekarang",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}