import 'package:flutter/material.dart';
import '../../../models/booking_view_model.dart';
import '../../../utils/app_textstyles.dart';
import '../../../utils/build_extention.dart';
import '../utils/app_colors.dart';
import 'custom_button.dart';


class BookingCardWidget extends StatelessWidget {
  final Booking booking;
  final String status;
  final bool? bookingDetail;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.status,
    this.bookingDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // final bookingProvider = context.read<BookingProvider>();
        // bookingProvider.selectBooking(booking);
        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ChangeNotifierProvider.value(
        //       value: bookingProvider,
        //       child: const BookingDetailsScreen(),
        //     ),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.kGrey1,width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.title,
                    style: AppTextStyles.sf16kBlackW500TextStyle,
                  ),
                ),
                Text(
                  "${context.l10n.viewNotes}",
                  style: AppTextStyles.sf14kPrimaryW500TextStyle,
                ),
              ],
            ),
            Divider(color: AppColors.kGrey1, thickness: 1, height: 20),
                Row(
                    children: [
                      Text(
                        "${context.l10n.orderID}: ",
                        style: AppTextStyles.sf14kBlackW400TextStyle,
                      ),
                      Text(
                        booking.id,
                        style: AppTextStyles.sf14kGreyW400TextStyle,
                      ),
                    ],
                  ),
            rowWidget(context.l10n.service, booking.service),
            rowWidget(context.l10n.serviceDate, "22 Nov 2025"),
            rowWidget(context.l10n.bookedSlotTime,"12:00 PM"),
            columnWidget(context.l10n.serviceAddress, "403, Maria Palace, Shahpore  Road, Adajan, Surat, Gujarat, 395005"),
           SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: context.wp(0.4),
                  height: 38,
                  child: CustomOutlineButton(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.kRed,
                    child: Text(
                      context.l10n.reject,
                      style: AppTextStyles.sf14kRedW500TextStyle,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: context.wp(0.4),
                  height: 38,
                  child: GradientButton(
                    radius: 5,
                    child: Text(
                      context.l10n.accept,
                      style: AppTextStyles.sf16kWhiteMediumTextStyle,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget rowWidget(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: AppTextStyles.sf14kGreyW400TextStyle),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.sf14kBlackW500TextStyle,
            ),
          ),
        ],
      ),
    );
  }
  Widget columnWidget(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label:", style: AppTextStyles.sf14kGreyW400TextStyle),
          Text(
            value,

            style: AppTextStyles.sf14kBlackW500TextStyle,
            softWrap: true,
          ),
        ],
      ),
    );
  }


}
