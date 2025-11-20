import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/booking_model.dart';

class BookingSayaPage extends StatefulWidget {
  final String userId;
  const BookingSayaPage({super.key, required this.userId});

  @override
  State<BookingSayaPage> createState() => _BookingSayaPageState();
}

class _BookingSayaPageState extends State<BookingSayaPage> {
  late final Box<BookingModel> _bookingBox;
  String _searchQuery = ''; 

  @override
  void initState() {
    super.initState();
    _bookingBox = Hive.box<BookingModel>('bookingBox');
    Intl.defaultLocale = 'id_ID';
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text(
            'Booking Saya',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
            tabs: [
              Tab(icon: Icon(Icons.history), text: 'Riwayat'),
              Tab(icon: Icon(Icons.schedule), text: 'Aktif'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _buildBookingList('Riwayat'),
              _buildBookingList('Aktif'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(String tabType) {
    return ValueListenableBuilder<Box<BookingModel>>(
      valueListenable: _bookingBox.listenable(),
      builder: (context, box, child) {
        final allBookings = box.values.toList();
        final filteredBookings = allBookings
          .where((b) => b.userId == widget.userId)
          .where((b) => b.bookingType == tabType)
          .where((b) =>
              (b.namaLapangan ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
            overscroll: false,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (filteredBookings.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(
                      child: Text(
                        tabType == 'Aktif'
                            ? 'Anda belum memiliki booking yang aktif saat ini.'
                            : 'Belum ada riwayat booking untuk akun ini.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  Column(
                    children: filteredBookings
                        .map((booking) => Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ItemLapangan(booking: booking),
                            ))
                        .toList(),
                  ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemLapangan extends StatelessWidget {
  final BookingModel booking;

  const ItemLapangan({super.key, required this.booking});

  Map<String, dynamic> _getStatusStyle(String status) {
    switch (status) {
      case 'Pending':
        return {
          'color': Colors.blue.shade100,
          'textColor': Colors.blue.shade700
        };
      case 'Paid':
        return {
          'color': Colors.green.shade100,
          'textColor': Colors.green.shade700
        };
      case 'Selesai':
        return {
          'color': Colors.grey.shade300,
          'textColor': Colors.grey.shade700
        };
      case 'Dibatalkan':
        return {
          'color': Colors.red.shade100,
          'textColor': Colors.red.shade700
        };
      default:
        return {'color': Colors.grey.shade100, 'textColor': Colors.black};
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = _getStatusStyle(booking.statusPembayaran);
    final dateFormatter = DateFormat('dd/MM/yyyy', 'id_ID');

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
        boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.1),
          //   spreadRadius: 1,
          //   blurRadius: 5,
          //   offset: const Offset(0, 3),
          // ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail_book',
            arguments: booking,
          );
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
                child: booking.imageUrl.isNotEmpty
                    ? Image.network(
                        booking.imageUrl,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.sports_soccer,
                              size: 40, color: Colors.grey),
                        ),
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
                    Text(
                      booking.namaLapangan,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.sports_soccer,
                            color: Colors.black, size: 16),
                        const SizedBox(width: 5),
                        Text(booking.jenisLapangan,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            color: Colors.black, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          dateFormatter.format(booking.tanggalBooking),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusStyle['color'],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            booking.statusPembayaran,
                            style: TextStyle(
                              fontSize: 10,
                              color: statusStyle['textColor'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.black54, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              '${booking.jamMulai} - ${booking.jamSelesai}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
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
