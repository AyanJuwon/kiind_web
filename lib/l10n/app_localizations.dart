import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_is.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fil'),
    Locale('fr'),
    Locale('id'),
    Locale('is'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('sv'),
    Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN', scriptCode: 'Hans'),
    Locale('zh')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @addAmountToWallet.
  ///
  /// In en, this message translates to:
  /// **'Add Amount To Wallet'**
  String get addAmountToWallet;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @amountInWallet.
  ///
  /// In en, this message translates to:
  /// **'Amount in wallet'**
  String get amountInWallet;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @avgDonated.
  ///
  /// In en, this message translates to:
  /// **'Average Donated'**
  String get avgDonated;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @campaigns.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get campaigns;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'COMMENTS'**
  String get comments;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @continue1.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue1;

  /// No description provided for @continueAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to'**
  String get continueAgree;

  /// No description provided for @continueWithoutSignup.
  ///
  /// In en, this message translates to:
  /// **'Continue Without Signing up'**
  String get continueWithoutSignup;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get details;

  /// No description provided for @donateNow.
  ///
  /// In en, this message translates to:
  /// **'Donate Now'**
  String get donateNow;

  /// No description provided for @donationUpdates.
  ///
  /// In en, this message translates to:
  /// **'Donation Updates'**
  String get donationUpdates;

  /// No description provided for @donations.
  ///
  /// In en, this message translates to:
  /// **'My Donations'**
  String get donations;

  /// No description provided for @donor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get donor;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterComId.
  ///
  /// In en, this message translates to:
  /// **'Enter Community Id'**
  String get enterComId;

  /// No description provided for @enterPriceManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Price Manually'**
  String get enterPriceManually;

  /// No description provided for @episodes.
  ///
  /// In en, this message translates to:
  /// **'EPISODES'**
  String get episodes;

  /// No description provided for @errorMsg.
  ///
  /// In en, this message translates to:
  /// **'It\'s not you; it\'s us.'**
  String get errorMsg;

  /// No description provided for @forgotPssword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPssword;

  /// No description provided for @fundWallet.
  ///
  /// In en, this message translates to:
  /// **'Fund Wallet'**
  String get fundWallet;

  /// No description provided for @goodDay.
  ///
  /// In en, this message translates to:
  /// **'Good Day'**
  String get goodDay;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @groups_info.
  ///
  /// In en, this message translates to:
  /// **'Selecting a Sub-group gives you access to streamline what you want to see on the app'**
  String get groups_info;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World'**
  String get helloWorld;

  /// No description provided for @helpFriend.
  ///
  /// In en, this message translates to:
  /// **'Help my friend'**
  String get helpFriend;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @job.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get job;

  /// No description provided for @kontinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get kontinue;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get leaveGroup;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @makeDifference.
  ///
  /// In en, this message translates to:
  /// **'Make A difference'**
  String get makeDifference;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @myDonations.
  ///
  /// In en, this message translates to:
  /// **'My Donations'**
  String get myDonations;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @newsAndAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'News And announcements'**
  String get newsAndAnnouncements;

  /// No description provided for @noNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'No New Notifications'**
  String get noNewNotifications;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @openEmail.
  ///
  /// In en, this message translates to:
  /// **'Open Email App'**
  String get openEmail;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pictureUpdates.
  ///
  /// In en, this message translates to:
  /// **'Picture Updates'**
  String get pictureUpdates;

  /// No description provided for @pleaseHelp.
  ///
  /// In en, this message translates to:
  /// **'Please help'**
  String get pleaseHelp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Policy'**
  String get privacyPolicy;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @raised.
  ///
  /// In en, this message translates to:
  /// **'Raised'**
  String get raised;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sharedValues.
  ///
  /// In en, this message translates to:
  /// **'Feels good'**
  String get sharedValues;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @supportFeedback.
  ///
  /// In en, this message translates to:
  /// **'Support & Feedback'**
  String get supportFeedback;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @termOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termOfUse;

  /// No description provided for @thanksForSupport.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your Support'**
  String get thanksForSupport;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @verifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Please check you email address to verifiy your account'**
  String get verifyAccount;

  /// No description provided for @videoUpdates.
  ///
  /// In en, this message translates to:
  /// **'Video Updates'**
  String get videoUpdates;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @youSupported.
  ///
  /// In en, this message translates to:
  /// **'You Supported'**
  String get youSupported;

  /// No description provided for @yourDonation.
  ///
  /// In en, this message translates to:
  /// **'Total Donation'**
  String get yourDonation;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @podcast.
  ///
  /// In en, this message translates to:
  /// **'Podcast'**
  String get podcast;

  /// No description provided for @supportingKiind.
  ///
  /// In en, this message translates to:
  /// **'Supporting kiind, you support all charities in need'**
  String get supportingKiind;

  /// No description provided for @beKiind.
  ///
  /// In en, this message translates to:
  /// **'Be Kiind'**
  String get beKiind;

  /// No description provided for @charities.
  ///
  /// In en, this message translates to:
  /// **'Charities'**
  String get charities;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No Transactions'**
  String get noTransactions;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'FOR YOU'**
  String get forYou;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'categories'**
  String get categories;

  /// No description provided for @whDoYouWantToBeKindTo.
  ///
  /// In en, this message translates to:
  /// **'Who do you want to be kind to?'**
  String get whDoYouWantToBeKindTo;

  /// No description provided for @wellShowYouMorePosts.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show you more posts based on what you follow'**
  String get wellShowYouMorePosts;

  /// No description provided for @enterSearchKeyword.
  ///
  /// In en, this message translates to:
  /// **'Enter Search Keyword'**
  String get enterSearchKeyword;

  /// No description provided for @youMayWantToSetUpDonationPlan.
  ///
  /// In en, this message translates to:
  /// **'You may want to set up a donation plan. Kindly click on the button below to proceed'**
  String get youMayWantToSetUpDonationPlan;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get edit;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @oneOff.
  ///
  /// In en, this message translates to:
  /// **'One Off'**
  String get oneOff;

  /// No description provided for @wouldYouLikeToAdd25.
  ///
  /// In en, this message translates to:
  /// **'Would you like to add a gift aid of 25 ?'**
  String get wouldYouLikeToAdd25;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @searchCharityHint.
  ///
  /// In en, this message translates to:
  /// **'Search, charities, categories'**
  String get searchCharityHint;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQRCode;

  /// No description provided for @enterWithCharityId.
  ///
  /// In en, this message translates to:
  /// **'Enter with charity ID'**
  String get enterWithCharityId;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @howMuchToAdd.
  ///
  /// In en, this message translates to:
  /// **'How much Do you want to add'**
  String get howMuchToAdd;

  /// No description provided for @howMuchToDonate.
  ///
  /// In en, this message translates to:
  /// **'How much Do you want to donate'**
  String get howMuchToDonate;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'One Time'**
  String get oneTime;

  /// No description provided for @noCharitySupported.
  ///
  /// In en, this message translates to:
  /// **'You Have Not Supported Any Organization Yet'**
  String get noCharitySupported;

  /// No description provided for @enterpricemanually.
  ///
  /// In en, this message translates to:
  /// **'Enter price manually'**
  String get enterpricemanually;

  /// No description provided for @myPortfolio.
  ///
  /// In en, this message translates to:
  /// **'My Portfolio'**
  String get myPortfolio;

  /// No description provided for @createOrViewPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Create Or View Your Donationn Portfolio'**
  String get createOrViewPortfolio;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @emailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Email Or Username'**
  String get emailOrUsername;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No Messages'**
  String get noMessages;

  /// No description provided for @noPostFound.
  ///
  /// In en, this message translates to:
  /// **'No posts found for this category'**
  String get noPostFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @failedToGetCharities.
  ///
  /// In en, this message translates to:
  /// **'Failed to get Charities'**
  String get failedToGetCharities;

  /// No description provided for @shareALink.
  ///
  /// In en, this message translates to:
  /// **'Share A Link'**
  String get shareALink;

  /// No description provided for @shareId.
  ///
  /// In en, this message translates to:
  /// **'Share ID'**
  String get shareId;

  /// No description provided for @createKiindPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Create Kiind Portfolio'**
  String get createKiindPortfolio;

  /// No description provided for @youHaveNoKiindPortfolio.
  ///
  /// In en, this message translates to:
  /// **'You have no Kiind Portfolio'**
  String get youHaveNoKiindPortfolio;

  /// No description provided for @myKiindPortfolio.
  ///
  /// In en, this message translates to:
  /// **'My Kiind Portfolio'**
  String get myKiindPortfolio;

  /// No description provided for @errorOccuredPortfolio.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while fetching your Portfolio'**
  String get errorOccuredPortfolio;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @makeChangesToYourPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Making changes to your Portfolio will cancel your active subscription. Do you wish to continue?'**
  String get makeChangesToYourPortfolio;

  /// No description provided for @youMayWantToDonateToYourPortfolio.
  ///
  /// In en, this message translates to:
  /// **'You may want to donate to your Portfolio again. Kindly click on Be Kiind button to donate'**
  String get youMayWantToDonateToYourPortfolio;

  /// No description provided for @youHaveAnActive.
  ///
  /// In en, this message translates to:
  /// **'You have an active'**
  String get youHaveAnActive;

  /// No description provided for @subscriptionOf.
  ///
  /// In en, this message translates to:
  /// **'subscription of'**
  String get subscriptionOf;

  /// No description provided for @toYourPortfolio.
  ///
  /// In en, this message translates to:
  /// **'to your Portfolio'**
  String get toYourPortfolio;

  /// No description provided for @chooseYourDonationPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose your donation plan'**
  String get chooseYourDonationPlan;

  /// No description provided for @downloadAndShare.
  ///
  /// In en, this message translates to:
  /// **'Download & Share'**
  String get downloadAndShare;

  /// No description provided for @anErrorOccured.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get anErrorOccured;

  /// No description provided for @editPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Edit Portfolio'**
  String get editPortfolio;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @anErrorOccuredPortflio.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while fetching your Portfolio'**
  String get anErrorOccuredPortflio;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'cy', 'da', 'de', 'en', 'es', 'et', 'fil', 'fr', 'id', 'is', 'ja', 'ko', 'nl', 'pl', 'pt', 'sv', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
    // Lookup logic when language+script+country codes are specified.
  switch (locale.toString()) {
    case 'zh_Hans_CN': return AppLocalizationsZhHansCn();
  }


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'cy': return AppLocalizationsCy();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'et': return AppLocalizationsEt();
    case 'fil': return AppLocalizationsFil();
    case 'fr': return AppLocalizationsFr();
    case 'id': return AppLocalizationsId();
    case 'is': return AppLocalizationsIs();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'nl': return AppLocalizationsNl();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'sv': return AppLocalizationsSv();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
