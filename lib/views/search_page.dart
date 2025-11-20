import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../components/navbar.dart';
import '../services/lapangan_service.dart';
import '../models/lapangan_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final LapanganService _service = LapanganService();
  late Future<List<TempatOlahraga>> _futureLapangan;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _futureLapangan = _service.fetchLapangan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),

                      TextField(
                        onChanged: (value) {
                          setState(() => _query = value.toLowerCase());
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 252, 252, 252),
                          hintText: 'Cari lapangan...',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 238, 238, 238),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 238, 238, 238),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      FutureBuilder<List<TempatOlahraga>>(
                        future: _futureLapangan,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: List.generate(
                                  5,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Skeletonizer(
                                      enabled: true,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: const Color.fromARGB(255, 238, 238, 238),
                                            width: 1,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    bottomLeft: Radius.circular(15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            height: 15,
                                                            width: 120,
                                                            color: Colors.grey[300]),
                                                        const SizedBox(height: 10),
                                                        Container(
                                                            height: 12,
                                                            width: 80,
                                                            color: Colors.grey[300]),
                                                        const SizedBox(height: 10),
                                                        Container(
                                                            height: 12,
                                                            width: 100,
                                                            color: Colors.grey[300]),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 12,
                                                      width: 70,
                                                      color: Colors.grey[300],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

    // ————— jika sudah tidak loading —————

                          else if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Text(
                                '❌ Gagal memuat data: ${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Text('Tidak ada data lapangan.'),
                            );
                          }

                          final filtered = snapshot.data!
                              .where((lap) =>
                                  lap.namaTempat.toLowerCase().contains(_query) ||
                                  lap.jenisLapangan.toLowerCase().contains(_query) ||
                                  lap.lokasiWilayah.toLowerCase().contains(_query))
                              .toList();

                          return Column(
                            children: filtered
                                .map((lap) => Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: ItemLapangan(lapangan: lap),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),

            const Navbar(),
          ],
        ),
      ),
    );
  }
}

class ItemLapangan extends StatelessWidget {
  final TempatOlahraga lapangan;
  const ItemLapangan({super.key, required this.lapangan});

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromARGB(255, 238, 238, 238),
          width: 1,
        ),
        color: Colors.white,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.pushNamed(context, '/detail_lapangan', arguments: lapangan);
        },
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.network(
                  lapangan.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lapangan.namaTempat,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.sports_soccer,
                                color: Colors.black, size: 16),
                            const SizedBox(width: 5),
                            Text(lapangan.jenisLapangan),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_city,
                                color: Colors.black, size: 16),
                            const SizedBox(width: 5),
                            Expanded(child: Text(lapangan.lokasiWilayah)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(lapangan.ratingAvg.toStringAsFixed(1)),
                            const SizedBox(width: 5),
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.price_change_rounded,
                            color: Colors.black, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          "Rp${lapangan.hargaSewa.toString()}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
