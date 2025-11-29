import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/lapangan_model.dart';
import '../services/lapangan_service.dart';

class LapanganDetail extends StatefulWidget {
  final TempatOlahraga tempat;

  const LapanganDetail({super.key, required this.tempat});

  @override
  State<LapanganDetail> createState() => _LapanganDetailState();
}

class _LapanganDetailState extends State<LapanganDetail> {
  final LapanganService lapanganService = LapanganService();
  double? distanceInKm;

  @override
  void initState() {
    super.initState();
    _getDistance();
  }

  Future<void> _getDistance() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() => distanceInKm = -1);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.tempat.latitude,
        widget.tempat.longitude,
      );

      if (!mounted) return;
      setState(() {
        distanceInKm = distance / 1000;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => distanceInKm = -1);
    }
  }

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
      stars.add(
        Icon(Icons.star_border, color: Colors.amber.withOpacity(0.5), size: 16),
      );
    }
    return Row(children: stars);
  }

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
        scrolledUnderElevation: 0,
        title: const Text(
          'Detail',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    tempat.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 80)),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  tempat.namaTempat,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),

                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sports_soccer, size: 16),
                        const SizedBox(width: 5),
                        Text(tempat.jenisLapangan),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Container(height: 10, width: 1, color: Colors.grey),
                    const SizedBox(width: 10),
                    _buildRatingStars(tempat.ratingAvg),
                    const SizedBox(width: 5),
                    Text(tempat.ratingAvg.toString()),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 18),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        tempat.lokasiWilayah,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                if (distanceInKm != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      distanceInKm == -1
                          ? "Tidak dapat mengakses lokasi"
                          : "${distanceInKm!.toStringAsFixed(1)} km dari lokasi Anda",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),

                InkWell(
                  onTap: () {
                    lapanganService.openMap(tempat.latitude, tempat.longitude);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.map, color: Colors.blue, size: 16),
                      SizedBox(width: 5),
                      Text(
                        "Lihat di Maps",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Mulai dari"),
                      Text(
                        _formatRupiah(tempat.hargaSewa),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/booking', arguments: tempat);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            'Book Sekarang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
