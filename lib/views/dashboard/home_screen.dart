import 'package:android_intent_plus/android_intent.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicemen_technician_app/providers/dashboard_provider.dart';

import '../../custom_widgets/app_image_widget.dart';
import '../../custom_widgets/booking_card_widget.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../models/booking_view_model.dart';
import '../../models/choose_servicemen_model.dart';
import '../../models/dashboard_response_model.dart';
import '../../models/get_profile_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/location_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_textstyles.dart';
import '../../utils/build_extention.dart';
import '../account/account_screen.dart';
import '../booking/booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _calledOnce = false;
  void openBatteryOptimizationSettings() {
    const intent = AndroidIntent(
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
    );
    intent.launch();
  }

  @override
  void initState() {
    super.initState();
    // Don't stop tracking here - let startTrackingIfOnline handle it based on online status
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_calledOnce) return; // 🔥 STOP RE-CALLS
    _calledOnce = true;
    // context.read<DashboardProvider>().changeIndex(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Home screen calling-----");
      // context.read<DashboardProvider>().addingChooseServiceList(context);
      // context.read<DashboardProvider>().dashboard(context);
      context.read<AuthProvider>().getProfile(context).then((v) {
        if (!mounted) return;
        context.read<DashboardProvider>().setOnlineStatus(context);
        // Start tracking if user is online from API
        context.read<DashboardProvider>().startTrackingIfOnline(context);
      });
    });
  }

  showDialogOfBattery() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Background Permission'),
        content: const Text(
            'To keep you online, please allow background operation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openBatteryOptimizationSettings();
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomNav(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Selector<DashboardProvider, int>(
      selector: (_, p) => p.index,
      builder: (_, index, __) {
        switch (index) {
          case 0:
            return buildHome();
          case 1:
            return const BookingScreen();
          case 2:
            return const AccountScreen();
          default:
            return buildHome();
        }
      },
    );
  }

  Widget buildHome() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: buildOnlineStatusSwitch()),
            SliverToBoxAdapter(child: buildTodaySummary()),
            const SliverToBoxAdapter(
              child: Divider(color: AppColors.kGrey4, thickness: 8, height: 60),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
              child: Text(
                context.l10n.todayJobLists,
                style: AppTextStyles.sf20kBlackSemiboldTextStyle,
              ),
            )),
            Selector<DashboardProvider, List<Booking>>(
              selector: (_, p) => p.bookings ?? [],
              builder: (context, bookings, _) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final booking = bookings[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: BookingCardWidget(
                          booking: booking,
                          status: "active",
                        ),
                      );
                    },
                    childCount: bookings.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnlineStatusSwitch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.3, 1],
            colors: [
              AppColors.kGrey3,
              AppColors.kWhite,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.kGrey1, width: 1)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.readyToTakeJobs,
                  style: AppTextStyles.sf16kBlackW600TextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  context.l10n.turnThisOnToStartReceivingNewServiceRequests,
                  style: AppTextStyles.sf14kGreyW400TextStyle,
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Selector<DashboardProvider, bool>(
                selector: (_, p) => p.isOnline,
                builder: (_, isOnline, __) {
                  return Switch(
                    value: isOnline,
                    onChanged: (v) {
                      context
                          .read<DashboardProvider>()
                          .updateOnlineStatus(context, v);
                    },
                    activeColor: AppColors.kWhite,
                    activeTrackColor: AppColors.kPrimaryColor,
                    // inactiveThumbColor: AppColors.kWhite,
                    // inactiveTrackColor: AppColors.kGrey7,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget buildTodaySummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.todaySummary,
            style: AppTextStyles.sf20kBlackSemiboldTextStyle,
          ),
          const SizedBox(
            height: 15,
          ),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.6,
            children: [
              buildSummaryCard(
                title: context.l10n.newRequests,
                count: "02",
                backgroundColor: AppColors.kGrey5,
              ),
              buildSummaryCard(
                title: context.l10n.acceptedJobs,
                count: "04",
                backgroundColor: AppColors.kBlueLight,
              ),
              buildSummaryCard(
                title: context.l10n.inProgressJobs,
                count: "01",
                backgroundColor: AppColors.kOrangeLight,
              ),
              buildSummaryCard(
                  title: context.l10n.completedJobs,
                  count: "03",
                  backgroundColor: AppColors.kGreenLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard(
      {required String title,
      required String count,
      required Color backgroundColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.3, 1],
          colors: [
            backgroundColor,
            AppColors.kWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kGrey1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title, style: AppTextStyles.sf16kBlackW400TextStyle),
          Text(count, style: AppTextStyles.sf24kBlackW600TextStyle),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Selector<DashboardProvider, int>(
        selector: (_, p) => p.index,
        builder: (_, index, __) {
          return index == 0
              ? CustomAppBar(
                  context: context,
                  leading: false,
                  titleColumn: Selector<AuthProvider, GetProfileResponseModel?>(
                      selector: (_, p) => p.getProfileResponseModel,
                      builder: (_, p, __) {
                        return Row(
                          children: [
                            Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.kGrey1),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: p?.data?.technician?.profilePhoto == null
                                    ? Center(
                                        child: AppImageWidget().svgImage(
                                          imageName: AppImages.personIcon,
                                          height: 32,
                                          width: 32,
                                        ),
                                      )
                                    : AppImageWidget().customNetworkImage(
                                        radius: 40,
                                        image: p?.data?.technician!
                                                .profilePhoto!.thumb! ??
                                            "",
                                      )),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.welcome,
                                    style: AppTextStyles.sf14kGreyW400TextStyle,
                                  ),
                                  Text(
                                    p?.data?.technician?.name.toString() ?? "",
                                    style:
                                        AppTextStyles.sf14kBlackW600TextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  actionWidget: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kGrey1),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: AppImageWidget().svgImage(
                              imageName: AppImages.headsetIcon,
                              height: 20,
                              width: 20),
                        ),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kGrey1),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: AppImageWidget().svgImage(
                              imageName: AppImages.notificationIcon,
                              height: 20,
                              width: 20),
                        ),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                )
              : CustomAppBar(
                  context: context,
                  title:
                      index == 1 ? context.l10n.booking : context.l10n.account,
                  leading: false,
                  actionWidget: index == 2
                      ? [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                AppImageWidget().svgImage(
                                    imageName: AppImages.starIcon,
                                    height: 20,
                                    width: 20),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text("2.0",
                                    style:
                                        AppTextStyles.sf16kWhiteW600TextStyle)
                              ],
                            ),
                          )
                        ]
                      : null);
        },
      ),
    );
  }

  Widget buildBottomNav(BuildContext context) {
    return Selector<DashboardProvider, int>(
      selector: (_, p) => p.index,
      builder: (_, index, __) {
        return BottomNavigationBar(
          currentIndex: index,
          backgroundColor: AppColors.kWhite,
          onTap: (i) => context.read<DashboardProvider>().changeIndex(i),
          items: [
            BottomNavigationBarItem(
              icon: AppImageWidget().svgImage(
                imageName: AppImages.homeIcon,
                color: AppColors.kGrey,
              ),
              label: context.l10n.home,
              activeIcon: AppImageWidget().svgImage(
                imageName: AppImages.homeIcon,
                color: AppColors.kPrimaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: AppImageWidget().svgImage(
                imageName: AppImages.bookingIcon,
                color: AppColors.kGrey,
              ),
              label: context.l10n.booking,
              activeIcon: AppImageWidget().svgImage(
                imageName: AppImages.bookingIcon,
                color: AppColors.kPrimaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: AppImageWidget().svgImage(
                imageName: AppImages.personIcon,
                height: 25,
                width: 25,
                color: AppColors.kGrey,
              ),
              label: context.l10n.account,
              activeIcon: AppImageWidget().svgImage(
                height: 25,
                width: 25,
                imageName: AppImages.personIcon,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
