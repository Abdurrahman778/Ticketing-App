class Ticket {
  final String id;
  final String namaTicket;  // nama_tiket
  final String kategori;    // kategori
  final int harga;          // harga

  Ticket({
    required this.id,
    required this.namaTicket,
    required this.kategori,
    required this.harga,
  });

  factory Ticket.fromMap(Map<String, dynamic> map, String id) {
    return Ticket(
      id: id,
      namaTicket: map['nama_tiket'] ?? '',
      kategori: map['kategori'] ?? '',
      harga: (map['harga'] is String) 
          ? int.tryParse(map['harga']) ?? 0 
          : map['harga'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_tiket': namaTicket,
      'kategori': kategori,
      'harga': harga,
    };
  }
}
