import 'package:flutter/material.dart';

// Import komponen kustom yang tidak tersedia di sini akan dihapus
// untuk menghindari error, namun tata letak akan dipertahankan.
// import 'package:project_akhir/components/navbar.dart'; 

class KonversiZonaWaktuPage extends StatefulWidget {
  const KonversiZonaWaktuPage({super.key});

  @override
  State<KonversiZonaWaktuPage> createState() => _KonversiZonaWaktuPageState();
}

class _KonversiZonaWaktuPageState extends State<KonversiZonaWaktuPage> {
  // Mock data untuk Timezones (Key: Display Name, Value: UTC Offset in hours)
  final Map<String, int> _timeZones = {
    'Jakarta (WIB)': 7,
    'London (GMT)': 0,
    'New York (EST)': -5,
    'Tokyo (JST)': 9,
    'Sydney (AEST)': 11,
    'Rio de Janeiro (BRT)': -3,
    'Dubai (GST)': 4,
    'Berlin (CET)': 1,
  };

  String? _selectedSourceZone;
  String? _selectedTargetZone;
  String _convertedTimeDisplay = 'Pilih zona waktu sumber dan tujuan.';

  @override
  void initState() {
    super.initState();
    // Mengatur zona waktu awal (opsional: atur ke null agar pengguna memilih)
    _selectedSourceZone = _timeZones.keys.first;
    _selectedTargetZone = _timeZones.keys.last;
    _convertTime();
  }

  // Fungsi untuk menghitung dan memperbarui waktu konversi
  void _convertTime() {
    if (_selectedSourceZone == null || _selectedTargetZone == null) {
      setState(() {
        _convertedTimeDisplay = 'Pilih kedua zona waktu.';
      });
      return;
    }

    final int sourceOffset = _timeZones[_selectedSourceZone]!;
    final int targetOffset = _timeZones[_selectedTargetZone]!;

    // Waktu saat ini di zona waktu Sumber
    final DateTime nowUtc = DateTime.now().toUtc();
    final DateTime sourceTime = nowUtc.add(Duration(hours: sourceOffset));
    
    // Konversi ke zona waktu Tujuan
    // Perhitungan: (Target Offset - Source Offset)
    final int offsetDifference = targetOffset - sourceOffset;
    final DateTime targetTime = sourceTime.add(Duration(hours: offsetDifference));

    setState(() {
      _convertedTimeDisplay =
          '${targetTime.hour.toString().padLeft(2, '0')}:${targetTime.minute.toString().padLeft(2, '0')}:${targetTime.second.toString().padLeft(2, '0')}';
    });
  }

  // Widget kustom untuk Dropdown Button dengan styling yang konsisten
  Widget _buildTimezoneDropdown({
    required String label,
    required String? currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration(
            border: InputBorder.none, // Menghilangkan underline bawaan
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[700]),
            contentPadding: EdgeInsets.zero,
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          items: _timeZones.keys.map((String zoneName) {
            final int offset = _timeZones[zoneName]!;
            final String offsetSign = offset >= 0 ? '+' : '';
            final String offsetText = ' (UTC$offsetSign$offset)';
            
            return DropdownMenuItem<String>(
              value: zoneName,
              child: Text(
                zoneName + offsetText,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memanggil konversi setiap kali widget dibangun (untuk menampilkan waktu yang selalu update)
    // Walaupun dalam aplikasi nyata, ini lebih baik menggunakan Timer.
    // Untuk tujuan contoh ini, kita biarkan di sini.
    _convertTime(); 

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        title: Text('Zona Waktu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),), 
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // --- Kartu Utama Konversi Zona Waktu ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Atur Zona Waktu",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Dropdown Zona Waktu Sumber
                          _buildTimezoneDropdown(
                            label: 'Dari Zona Waktu',
                            currentValue: _selectedSourceZone,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSourceZone = newValue;
                                _convertTime();
                              });
                            },
                          ),
                          
                          const SizedBox(height: 20),

                          // Ikon Pertukaran
                          Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.swap_vert, size: 30, color: Colors.blueGrey),
                              onPressed: () {
                                setState(() {
                                  // Pertukaran zona waktu
                                  String? temp = _selectedSourceZone;
                                  _selectedSourceZone = _selectedTargetZone;
                                  _selectedTargetZone = temp;
                                  _convertTime();
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 20),

                          // Dropdown Zona Waktu Tujuan
                          _buildTimezoneDropdown(
                            label: 'Ke Zona Waktu',
                            currentValue: _selectedTargetZone,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedTargetZone = newValue;
                                _convertTime();
                              });
                            },
                          ),

                          const SizedBox(height: 30),

                          // --- Hasil Konversi ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0), // Warna biru muda
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Waktu Saat Ini (di Tujuan)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255), // Biru gelap
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _convertedTimeDisplay,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFeatures: [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
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
