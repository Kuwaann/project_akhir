import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'package:project_akhir/services/notification_service.dart';
import '../models/lapangan_model.dart'; 
import '../models/booking_model.dart'; 
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  final TempatOlahraga tempat; 
  final String userId;

  const BookingPage({super.key, required this.tempat, required this.userId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Box<BookingModel> _bookingBox = Hive.box<BookingModel>('bookingBox');

  final List<String> _availableTimes = [
    '08:00', '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00', '17:00',
    '18:00', '19:00', '20:00', '21:00', '22:00'
  ];
  final List<String> _bookedTimes = [];
  
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String? _selectedTime;
  int _bookingDurationHours = 1;
  final int _maxBookingDurationHours = 4;

  late String _lapanganNama;
  late String _lapanganImgURL;
  late String _lapanganJenis;
  late int _pricePerHour;
  
  late int _totalPrice;

  @override
  void initState() {
    super.initState();
    _lapanganNama = widget.tempat.namaTempat;
    _lapanganImgURL = widget.tempat.imageUrl;
    _lapanganJenis = widget.tempat.jenisLapangan;
    _pricePerHour = widget.tempat.hargaSewa;

    _totalPrice = _pricePerHour * _bookingDurationHours;
    
    Intl.defaultLocale = 'id_ID';
    initializeDateFormatting('id_ID').then((_) {
      setState(() {});
    });
  }
  
  void _updateTotalHarga() {
    setState(() {
      _totalPrice = _pricePerHour * _bookingDurationHours;
    });
  }

  void _loadExistingBooking(){
    final existingBookings = _bookingBox.values.where((booking){
      return booking.namaLapangan == _lapanganNama;
    });

    _bookedTimes.clear();

    for(final booking in existingBookings){
      final startParts = booking.jamMulai.split(':');
      final startHour = int.parse(startParts[0]);
      final duration = booking.durasiJam;

      for(int i = 0; i < duration; i++){
        final bookedHour = startHour + i;
        final bookedTimeStr = "${bookedHour.toString().padLeft(2, '0')}:00";
        _bookedTimes.add(bookedTimeStr);
      }
    }
  }

  bool _isBookingOverlap(
      String namaLapangan,
      DateTime tanggalBooking,
      String jamMulai,
      int durasiJam,
  ){
    final existingBookings = _bookingBox.values.where((booking){
      return booking.namaLapangan == namaLapangan && DateUtils.isSameDay(booking.tanggalBooking, tanggalBooking);
    });
    final pembagiWaktu = jamMulai.split(':');
    final startHour = int.parse(pembagiWaktu[0]);
    final startMinute = int.parse(pembagiWaktu[1]);
    final newStart = DateTime(tanggalBooking.year, tanggalBooking.month, tanggalBooking.day, startHour, startMinute);
    final newEnd = newStart.add(Duration(hours: durasiJam));

    for(final booking in existingBookings){
      final bookedParts = booking.jamMulai.split(':');
      final bookedStart = DateTime(
        booking.tanggalBooking.year,
        booking.tanggalBooking.month,
        booking.tanggalBooking.day,
        int.parse(bookedParts[0]),
        int.parse(bookedParts[1])
      );
      final bookedEnd = bookedStart.add(Duration(hours: booking.durasiJam));

      final isOverlap = newStart.isBefore(bookedEnd) && newEnd.isAfter(bookedStart);
      if(isOverlap){
        return true;
      }
    }
    return false;
  }

  void _saveBookingToHive() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih jam mulai terlebih dahulu.')),
      );
      return;
    }

    final isOverlap = _isBookingOverlap(
      widget.tempat.namaTempat, // nama lapangan / tempat
      _selectedDay,
      _selectedTime!,
      _bookingDurationHours,
    );

    if (isOverlap) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal bentrok! Silakan pilih jam lain.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final newBooking = BookingModel(
      namaLapangan: _lapanganNama,
      jenisLapangan: _lapanganJenis,
      tanggalBooking: _selectedDay,
      jamMulai: _selectedTime!,
      durasiJam: _bookingDurationHours,
      totalHarga: _totalPrice,
      statusPembayaran: "Pending",
      userId: widget.userId, 
      imageUrl: widget.tempat.imageUrl,      
    );
    
    try {
      await _bookingBox.add(newBooking);

      await NotificationService().showBookingNotification(
        title: 'Booking Berhasil! 🎉',
        body: 'Booking lapangan $_lapanganNama pada ${DateFormat('dd MMM yyyy').format(_selectedDay)} jam $_selectedTime berhasil dibuat.',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking berhasil disimpan! (Langsung ke Hive)')),
        );
        Navigator.pushReplacementNamed(context, '/booking_saya'); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan booking: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'id';
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(_lapanganNama, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white, // ubah sesuai warna background
                            ],
                            stops: [0.7, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstOut,
                        child: Image.network(
                          _lapanganImgURL,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image, size: 80)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(30),
                  child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Jenis Lapangan: $_lapanganJenis",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Harga per Jam: Rp ${NumberFormat.decimalPattern('id_ID').format(_pricePerHour)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]
                          ),
                        ),
                        SizedBox(height: 30),

                        Text(
                          "Pilih Tanggal Booking",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: TableCalendar(
                            focusedDay: _focusedDay,
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(const Duration(days: 90)),
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedTime = null;
                              });
                            },
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                              titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: TextStyle(color: Colors.white),
                              todayDecoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              outsideDaysVisible: false,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        Text(
                          "Pilih Jam Mulai",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _availableTimes.map((time) {
                            bool isBooked = _bookedTimes.contains(time);
                            bool isSelected = _selectedTime == time;
                            return GestureDetector(
                              onTap: isBooked ? null : () {
                                setState(() {
                                  _selectedTime = time;
                                  _updateTotalHarga();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isBooked
                                      ? Colors.grey[200]
                                      : (isSelected ? Colors.black : Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isBooked
                                        ? Colors.grey[300]!
                                        : (isSelected ? Colors.black : Colors.grey[300]!),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: isBooked
                                        ? Colors.grey[500]
                                        : (isSelected ? Colors.white : Colors.black87),
                                    fontWeight: FontWeight.w500,
                                    decoration: isBooked ? TextDecoration.lineThrough : TextDecoration.none,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 30),

                        Text(
                          "Durasi Booking (jam)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            for (int i = 1; i <= _maxBookingDurationHours; i++)
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _bookingDurationHours = i;
                                      _updateTotalHarga();
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _bookingDurationHours == i
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: _bookingDurationHours == i
                                            ? Colors.black
                                            : Colors.grey[300]!,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      '$i',
                                      style: TextStyle(
                                        color: _bookingDurationHours == i
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 30),

                        Text(
                          "Ringkasan Booking",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              _buildSummaryRow("Nama Lapangan", _lapanganNama),
                              _buildSummaryRow("Jenis", _lapanganJenis),
                              _buildSummaryRow("Tanggal", DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_selectedDay)),
                              _buildSummaryRow("Jam Mulai", _selectedTime ?? '-'),
                              _buildSummaryRow("Durasi", '$_bookingDurationHours jam'),
                              Divider(height: 20, thickness: 1, color: Colors.grey[200]),
                              _buildSummaryRow(
                                "Total Harga",
                                'Rp ${NumberFormat.decimalPattern('id_ID').format(_totalPrice)}',
                                isTotal: true,
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
      bottomNavigationBar: _buildBookingButton(),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.deepOrange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBookingButton() {
    bool isButtonEnabled = _selectedTime != null;
    return BottomAppBar(
      color: Colors.white,
      elevation: 0,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isButtonEnabled ? _saveBookingToHive : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Text(
            'Book Sekarang',
            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
