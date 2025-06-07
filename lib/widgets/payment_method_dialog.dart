import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/ticket.dart';
import '../models/purchase.dart';
import '../services/firebase_service.dart';
import '../screens/receipt_screen.dart';

class PaymentMethodDialog extends StatefulWidget {
  final String paymentMethod;
  final Ticket ticket;

  const PaymentMethodDialog({
    super.key,
    required this.paymentMethod,
    required this.ticket,
  });

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDialogTitle(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF6B7280),
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDialogContent(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isProcessing
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          'Konfirmasi Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDialogTitle() {
    switch (widget.paymentMethod) {
      case 'cash':
        return 'Pembayaran Tunai';
      case 'credit_card':
        return 'Pembayaran Kartu Kredit';
      case 'qris':
        return 'Pembayaran QRIS';
      default:
        return 'Pembayaran';
    }
  }

  Widget _buildDialogContent() {
    switch (widget.paymentMethod) {
      case 'cash':
        return _buildCashContent();
      case 'credit_card':
        return _buildCreditCardContent();
      case 'qris':
        return _buildQRISContent();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCashContent() {
    return Column(
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cash-payment.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Pembayaran Tunai',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Jika pembayaran telah diterima, klik\nbutton konfirmasi pembayaran untuk\nmenyelesaikan transaksi',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.4),
        ),
      ],
    );
  }

  Widget _buildCreditCardContent() {
    return Column(
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/card-payment.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '8810 7766 1234 9876',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    const ClipboardData(text: '8810776612349876'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nomor kartu disalin'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Salin',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Transfer Pembayaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pastikan nominal dan tujuan\npembayaran sudah benar sebelum\nmelanjutkan.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.4),
        ),
      ],
    );
  }

  Widget _buildQRISContent() {
    return Column(
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/qris-code.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Scan QR untuk Membayar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Gunakan aplikasi e-wallet atau mobile\nbanking untuk scan QR di atas dan\nselesaikan pembayaran',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.4),
        ),
      ],
    );
  }

  Future<void> _processPayment() async {
    if (!mounted) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Create purchase record
      final purchase = Purchase(
        id: '',
        ticketId: widget.ticket.id,
        ticketName: widget.ticket.namaTicket,
        ticketCategory: widget.ticket.kategori,
        amount: widget.ticket.harga,
        paymentMethod: _getPaymentMethodName(),
        purchaseDate: DateTime.now(),
        status: 'completed',
      );

      // Save to Firebase
      final purchaseId = await _firebaseService.addPurchase(purchase);

      // Navigate to receipt screen
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ReceiptScreen(purchase: purchase.copyWith(id: purchaseId)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _getPaymentMethodName() {
    switch (widget.paymentMethod) {
      case 'cash':
        return 'Tunai (Cash)';
      case 'credit_card':
        return 'Kartu Kredit';
      case 'qris':
        return 'QRIS / QR Pay';
      default:
        return 'Unknown';
    }
  }
}

extension PurchaseCopy on Purchase {
  Purchase copyWith({
    String? id,
    String? ticketId,
    String? ticketName,
    String? ticketCategory, // Changed from ticketType to match Purchase model
    int? amount,
    String? paymentMethod,
    DateTime? purchaseDate,
    String? status,
  }) {
    return Purchase(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      ticketName: ticketName ?? this.ticketName,
      ticketCategory:
          ticketCategory ?? this.ticketCategory, // Fixed property name
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      status: status ?? this.status,
    );
  }
}
