import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @yourServiceJourneyBeginsHereLogInEasilyWithYourMobileNumberToStartReceivingJobs.
  ///
  /// In en, this message translates to:
  /// **'Your service journey begins here. Log in easily with your mobile number to start receiving jobs.'**
  String
      get yourServiceJourneyBeginsHereLogInEasilyWithYourMobileNumberToStartReceivingJobs;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund policy'**
  String get refundPolicy;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6 digit code'**
  String get enter6DigitCode;

  /// No description provided for @weSentAVerificationCodeToYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your phone number'**
  String get weSentAVerificationCodeToYourPhoneNumber;

  /// No description provided for @youDidntReceivedAnyCode.
  ///
  /// In en, this message translates to:
  /// **'You didn’t received any code?'**
  String get youDidntReceivedAnyCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourNameHere.
  ///
  /// In en, this message translates to:
  /// **'Enter your name here'**
  String get enterYourNameHere;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmailHere.
  ///
  /// In en, this message translates to:
  /// **'Enter your email here'**
  String get enterYourEmailHere;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @skillsDescription.
  ///
  /// In en, this message translates to:
  /// **'Skills Description'**
  String get skillsDescription;

  /// No description provided for @max200Words.
  ///
  /// In en, this message translates to:
  /// **'max 200 words'**
  String get max200Words;

  /// No description provided for @serviceAreas.
  ///
  /// In en, this message translates to:
  /// **'Service Areas'**
  String get serviceAreas;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @uploadIDProof.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Proof'**
  String get uploadIDProof;

  /// No description provided for @aadhaarPANDrivingLicenseVoterID.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar, PAN, Driving License, Voter ID'**
  String get aadhaarPANDrivingLicenseVoterID;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @uploadPDFJEPGPNG.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF / JEPG / PNG'**
  String get uploadPDFJEPGPNG;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @readyToTakeJobs.
  ///
  /// In en, this message translates to:
  /// **'Ready to Take Jobs'**
  String get readyToTakeJobs;

  /// No description provided for @turnThisOnToStartReceivingNewServiceRequests.
  ///
  /// In en, this message translates to:
  /// **'Turn this on to start receiving new service requests.'**
  String get turnThisOnToStartReceivingNewServiceRequests;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today’s Summary'**
  String get todaySummary;

  /// No description provided for @newRequests.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get newRequests;

  /// No description provided for @acceptedJobs.
  ///
  /// In en, this message translates to:
  /// **'Accepted Jobs'**
  String get acceptedJobs;

  /// No description provided for @inProgressJobs.
  ///
  /// In en, this message translates to:
  /// **'In-Progress Jobs'**
  String get inProgressJobs;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @todayJobLists.
  ///
  /// In en, this message translates to:
  /// **'Today Job Lists'**
  String get todayJobLists;

  /// No description provided for @orderID.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderID;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @slotDate.
  ///
  /// In en, this message translates to:
  /// **'Slot Date'**
  String get slotDate;

  /// No description provided for @serviceAddress.
  ///
  /// In en, this message translates to:
  /// **'Service Address:'**
  String get serviceAddress;

  /// No description provided for @bookedSlotTime.
  ///
  /// In en, this message translates to:
  /// **'Booked Slot Time'**
  String get bookedSlotTime;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @clientProblemDescriptions.
  ///
  /// In en, this message translates to:
  /// **'Client Problem Descriptions'**
  String get clientProblemDescriptions;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// No description provided for @byDate.
  ///
  /// In en, this message translates to:
  /// **'By Date'**
  String get byDate;

  /// No description provided for @viewNotes.
  ///
  /// In en, this message translates to:
  /// **'View Notes'**
  String get viewNotes;

  /// No description provided for @viewJobDetails.
  ///
  /// In en, this message translates to:
  /// **'View Job Details'**
  String get viewJobDetails;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get clientName;

  /// No description provided for @beforeStartWorkUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Before Start Work Upload Photo'**
  String get beforeStartWorkUploadPhoto;

  /// No description provided for @beforeStartingTheWorkPleaseCaptureImagesOfTheProductsCurrentCondition.
  ///
  /// In en, this message translates to:
  /// **'Before starting the work, please capture images of the product’s current condition.'**
  String
      get beforeStartingTheWorkPleaseCaptureImagesOfTheProductsCurrentCondition;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @uploadJEPGPNG.
  ///
  /// In en, this message translates to:
  /// **'Upload JEPG / PNG'**
  String get uploadJEPGPNG;

  /// No description provided for @startWork.
  ///
  /// In en, this message translates to:
  /// **'Start Work'**
  String get startWork;

  /// No description provided for @notesForProof.
  ///
  /// In en, this message translates to:
  /// **'Notes for Proof'**
  String get notesForProof;

  /// No description provided for @uploadComplete.
  ///
  /// In en, this message translates to:
  /// **'Upload & Complete'**
  String get uploadComplete;

  /// No description provided for @forAdminMe.
  ///
  /// In en, this message translates to:
  /// **'for admin & me'**
  String get forAdminMe;

  /// No description provided for @writeHere.
  ///
  /// In en, this message translates to:
  /// **'Write here...'**
  String get writeHere;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancelByMe.
  ///
  /// In en, this message translates to:
  /// **'Cancel By Me'**
  String get cancelByMe;

  /// No description provided for @afterEndWorkUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'After End Work Upload Photo'**
  String get afterEndWorkUploadPhoto;

  /// No description provided for @uploadAfterServicePhotosToConfirmTheCompletedWork.
  ///
  /// In en, this message translates to:
  /// **'Upload after-service photos to confirm the completed work.'**
  String get uploadAfterServicePhotosToConfirmTheCompletedWork;

  /// No description provided for @completeWork.
  ///
  /// In en, this message translates to:
  /// **'Complete Work'**
  String get completeWork;

  /// No description provided for @uploadCurrentStatusPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload current status photo'**
  String get uploadCurrentStatusPhoto;

  /// No description provided for @addReasonForCancellation.
  ///
  /// In en, this message translates to:
  /// **'Add Reason for Cancellation'**
  String get addReasonForCancellation;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @otherDetails.
  ///
  /// In en, this message translates to:
  /// **'Other Details'**
  String get otherDetails;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @completedJobs.
  ///
  /// In en, this message translates to:
  /// **'Completed Jobs'**
  String get completedJobs;

  /// No description provided for @serviceDate.
  ///
  /// In en, this message translates to:
  /// **'Service Date'**
  String get serviceDate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @areYouSureYouWantToLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureYouWantToLogOut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
