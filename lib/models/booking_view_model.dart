enum BookingTabStatus { active, completed, cancelled }
enum BookingStatus {
  pending,
  assigned,
  inProgress,
  completed,
  cancelled
}


class Booking {
  final String id;
  final String title;
  final String service;
  final DateTime slotDate;
  final DateTime completedDate;
  final DateTime cancelledDate;
  final String slotTime;
  final String statusLabel;
  final BookingTabStatus status;
  final BookingStatus bookingStatus;
  final double amount;
  final double refundAmount;
  final double? rating;
  final String? technician;

  Booking({
    required this.id,
    required this.title,
    required this.service,
    required this.slotDate,
    required this.completedDate,
    required this.cancelledDate,
    required this.slotTime,
    required this.statusLabel,
    required this.status,
    required this.amount,
    required this.refundAmount,
    required this.bookingStatus,
    this.technician,
    this.rating,
  });
}
