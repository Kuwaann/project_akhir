import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';

class BookDetail extends StatelessWidget {
  final BookingModel booking;

  const BookDetail({super.key, required this.booking});

  // Fungsi helper untuk konversi dari WIB ke zona lain
  String convertFromWIB(DateTime dateTime, int offsetHours) {
    DateTime converted = dateTime.add(Duration(hours: offsetHours));
    return '${converted.hour.toString().padLeft(2, '0')}:${converted.minute.toString().padLeft(2, '0')}';
  }

  // Fungsi helper untuk konversi harga ke mata uang lain
  String convertCurrency(double amount, String currencyCode, {double rate = 1}) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: currencyCode);
    return format.format(amount * rate);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy', 'id_ID');
    final tanggalMain = dateFormatter.format(booking.tanggalBooking);

    // Parsing jam mulai WIB
    final hourMinute = booking.jamMulai.split(':');
    final int jam = int.tryParse(hourMinute[0]) ?? 0;
    final int menit = int.tryParse(hourMinute[1]) ?? 0;

    // Waktu mulai dalam DateTime WIB
    final bookingWIB = DateTime(
      booking.tanggalBooking.year,
      booking.tanggalBooking.month,
      booking.tanggalBooking.day,
      jam,
      menit,
    );

    // Konversi ke beberapa zona
    final wita = convertFromWIB(bookingWIB, 1); // WITA = WIB +1
    final wit = convertFromWIB(bookingWIB, 2);  // WIT = WIB +2
    final london = convertFromWIB(bookingWIB, -7); // London = WIB -7

    // Konversi mata uang (contoh kurs)
    const double usdRate = 0.000067; // 1 IDR ≈ 0.000067 USD
    const double eurRate = 0.000061; // 1 IDR ≈ 0.000061 EUR

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Booking',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: Colors.white,
            child: Column(
              children: [
                // --- Gambar Lapangan ---
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: booking.imageUrl.isNotEmpty
                        ? Image.network(
                            booking.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Detail Booking ---
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.namaLapangan,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Detail Booking",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),

                      // --- Box Detail Booking ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            _buildRow("ID Booking", "#${booking.key ?? 'N/A'}"),
                            _buildRow("Tanggal Booking",
                                DateFormat('dd/MM/yyyy HH:mm', 'id_ID')
                                    .format(booking.tanggalBooking)),
                            _buildRow("Tanggal Main", tanggalMain),
                            const SizedBox(height: 10),
                            const Text(
                              "Jam Main di Berbagai Zona Waktu",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            const SizedBox(height: 5),
                            _buildRow("WIB", booking.jamMulai),
                            _buildRow("WITA", wita),
                            _buildRow("WIT", wit),
                            _buildRow("London (GMT)", london),
                            const SizedBox(height: 10),
                            _buildRow("Jenis Lapangan", booking.jenisLapangan),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        "Detail Pembayaran",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),

                      // --- Box Detail Pembayaran ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Pembayaran:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 5),
                            _buildRow(
                              "IDR",
                              NumberFormat.currency(
                                      locale: 'id_ID', symbol: 'Rp')
                                  .format(booking.totalHarga),
                            ),
                            _buildRow(
                              "USD",
                              convertCurrency(booking.totalHarga.toDouble(), "\$", rate: usdRate),
                            ),
                            _buildRow(
                              "EUR",
                              convertCurrency(booking.totalHarga.toDouble(), "€", rate: eurRate),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Status Pembayaran",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                            booking.statusPembayaran)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    booking.statusPembayaran,
                                    style: TextStyle(
                                      color: _getStatusColor(
                                          booking.statusPembayaran),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  Widget _buildRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: const TextStyle(color: Colors.black)),
          Flexible(
            child: Text(
              right,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.blue;
      case 'Paid':
      case 'Lunas':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
