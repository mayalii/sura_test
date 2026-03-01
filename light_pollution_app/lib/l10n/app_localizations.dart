import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Light Pollution Detector'**
  String get appTitle;

  /// No description provided for @sura.
  ///
  /// In en, this message translates to:
  /// **'Sura'**
  String get sura;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpLink;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLink;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join the stargazing community'**
  String get joinCommunity;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterAPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get enterAPassword;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @chooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Choose a username'**
  String get chooseUsername;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameTooShort;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @errorNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get errorNoAccount;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errorWrongPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get errorInvalidEmail;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get errorTooManyRequests;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get errorLoginFailed;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @resetEmailSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to'**
  String get resetEmailSentTo;

  /// No description provided for @resetEmailInstructions.
  ///
  /// In en, this message translates to:
  /// **'Open the email and tap the link to set a new password. Then come back and log in.'**
  String get resetEmailInstructions;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @didntGetEmail.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the email? '**
  String get didntGetEmail;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email. Check your email address.'**
  String get resetPasswordFailed;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get errorWeakPassword;

  /// No description provided for @errorSignUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed. Please try again.'**
  String get errorSignUpFailed;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get navCamera;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navReserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get navReserve;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @lists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get lists;

  /// No description provided for @communities.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get communities;

  /// No description provided for @myReservations.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myReservations;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Settings and privacy'**
  String get settingsPrivacy;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @failedToLoadPosts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load posts.'**
  String get failedToLoadPosts;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet. Be the first to share!'**
  String get noPostsYet;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @whatsHappening.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening?'**
  String get whatsHappening;

  /// No description provided for @everyoneCanReply.
  ///
  /// In en, this message translates to:
  /// **'Everyone can reply'**
  String get everyoneCanReply;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete post'**
  String get deletePost;

  /// No description provided for @failedToPost.
  ///
  /// In en, this message translates to:
  /// **'Failed to post: {error}'**
  String failedToPost(String error);

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @repliesTab.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get repliesTab;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @likesTab.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likesTab;

  /// No description provided for @noPostsYetSimple.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYetSimple;

  /// No description provided for @noRepliesYet.
  ///
  /// In en, this message translates to:
  /// **'No replies yet'**
  String get noRepliesYet;

  /// No description provided for @noPhotosYet.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get noPhotosYet;

  /// No description provided for @noLikesYet.
  ///
  /// In en, this message translates to:
  /// **'No likes yet'**
  String get noLikesYet;

  /// No description provided for @loadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingText;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @bioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @websiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// No description provided for @addWebsite.
  ///
  /// In en, this message translates to:
  /// **'Add your website'**
  String get addWebsite;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birthDate;

  /// No description provided for @addBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Add your birth date'**
  String get addBirthDate;

  /// No description provided for @switchToProfessional.
  ///
  /// In en, this message translates to:
  /// **'Switch to Professional'**
  String get switchToProfessional;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String failedToSave(String error);

  /// No description provided for @pollutionDetection.
  ///
  /// In en, this message translates to:
  /// **'Pollution Detection'**
  String get pollutionDetection;

  /// No description provided for @takeOrUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take or upload a photo of the night sky\nto detect light pollution level'**
  String get takeOrUploadPhoto;

  /// No description provided for @photoButton.
  ///
  /// In en, this message translates to:
  /// **'PHOTO'**
  String get photoButton;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis Failed'**
  String get analysisFailed;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @reExamine.
  ///
  /// In en, this message translates to:
  /// **'Re-examine'**
  String get reExamine;

  /// No description provided for @skyQualityLabel.
  ///
  /// In en, this message translates to:
  /// **'Sky Quality:'**
  String get skyQualityLabel;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @bortleValue.
  ///
  /// In en, this message translates to:
  /// **'Bortle {value}'**
  String bortleValue(int value);

  /// No description provided for @aiModelScore.
  ///
  /// In en, this message translates to:
  /// **'AI Model Score'**
  String get aiModelScore;

  /// No description provided for @pixelAnalysisScore.
  ///
  /// In en, this message translates to:
  /// **'Pixel Analysis Score'**
  String get pixelAnalysisScore;

  /// No description provided for @meanBrightness.
  ///
  /// In en, this message translates to:
  /// **'Mean Brightness'**
  String get meanBrightness;

  /// No description provided for @brightPixels.
  ///
  /// In en, this message translates to:
  /// **'Bright Pixels'**
  String get brightPixels;

  /// No description provided for @darkPixels.
  ///
  /// In en, this message translates to:
  /// **'Dark Pixels'**
  String get darkPixels;

  /// No description provided for @blueRatio.
  ///
  /// In en, this message translates to:
  /// **'Blue Ratio'**
  String get blueRatio;

  /// No description provided for @orangeRatio.
  ///
  /// In en, this message translates to:
  /// **'Orange Ratio'**
  String get orangeRatio;

  /// No description provided for @brightnessDistribution.
  ///
  /// In en, this message translates to:
  /// **'Brightness Distribution'**
  String get brightnessDistribution;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @bright.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get bright;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @toggleLegend.
  ///
  /// In en, this message translates to:
  /// **'Toggle legend'**
  String get toggleLegend;

  /// No description provided for @lightPollutionOverlay.
  ///
  /// In en, this message translates to:
  /// **'Light Pollution Overlay'**
  String get lightPollutionOverlay;

  /// No description provided for @opacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get opacity;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year: '**
  String get yearLabel;

  /// No description provided for @bortleScale.
  ///
  /// In en, this message translates to:
  /// **'Bortle Scale'**
  String get bortleScale;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get searchLocation;

  /// No description provided for @tapLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap a location on the map'**
  String get tapLocation;

  /// No description provided for @orSearchCity.
  ///
  /// In en, this message translates to:
  /// **'or search for a city above'**
  String get orSearchCity;

  /// No description provided for @someDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Some data couldn\'t be loaded. Showing available info.'**
  String get someDataFailed;

  /// No description provided for @stargazingScore.
  ///
  /// In en, this message translates to:
  /// **'Stargazing Score'**
  String get stargazingScore;

  /// No description provided for @outOf100.
  ///
  /// In en, this message translates to:
  /// **'out of 100'**
  String get outOf100;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @veryPoor.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get veryPoor;

  /// No description provided for @clouds.
  ///
  /// In en, this message translates to:
  /// **'Clouds'**
  String get clouds;

  /// No description provided for @moon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get moon;

  /// No description provided for @bortle.
  ///
  /// In en, this message translates to:
  /// **'Bortle'**
  String get bortle;

  /// No description provided for @skyPhotoAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Sky Photo Analyzer'**
  String get skyPhotoAnalyzer;

  /// No description provided for @uploadSkyPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a sky photo'**
  String get uploadSkyPhoto;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select from gallery'**
  String get tapToSelect;

  /// No description provided for @skyQuality.
  ///
  /// In en, this message translates to:
  /// **'Sky Quality'**
  String get skyQuality;

  /// No description provided for @avgBrightness.
  ///
  /// In en, this message translates to:
  /// **'Avg Brightness'**
  String get avgBrightness;

  /// No description provided for @warmGlow.
  ///
  /// In en, this message translates to:
  /// **'Warm Glow'**
  String get warmGlow;

  /// No description provided for @skyColor.
  ///
  /// In en, this message translates to:
  /// **'Sky Color: '**
  String get skyColor;

  /// No description provided for @analyzeAnotherPhoto.
  ///
  /// In en, this message translates to:
  /// **'Analyze another photo'**
  String get analyzeAnotherPhoto;

  /// No description provided for @lightPollutionBortle.
  ///
  /// In en, this message translates to:
  /// **'Light Pollution (Bortle Scale)'**
  String get lightPollutionBortle;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class {value} — {name}'**
  String classLabel(int value, String name);

  /// No description provided for @currentWeather.
  ///
  /// In en, this message translates to:
  /// **'Current Weather'**
  String get currentWeather;

  /// No description provided for @cloudCover.
  ///
  /// In en, this message translates to:
  /// **'Cloud Cover'**
  String get cloudCover;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @cloudCover24h.
  ///
  /// In en, this message translates to:
  /// **'Cloud Cover (24h)'**
  String get cloudCover24h;

  /// No description provided for @sunTwilight.
  ///
  /// In en, this message translates to:
  /// **'Sun & Twilight'**
  String get sunTwilight;

  /// No description provided for @dayDuration.
  ///
  /// In en, this message translates to:
  /// **'Day: {duration}'**
  String dayDuration(String duration);

  /// No description provided for @nightDuration.
  ///
  /// In en, this message translates to:
  /// **'Night: {duration}'**
  String nightDuration(String duration);

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @solarNoon.
  ///
  /// In en, this message translates to:
  /// **'Solar Noon'**
  String get solarNoon;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @civilTwilightEnd.
  ///
  /// In en, this message translates to:
  /// **'Civil Twilight End'**
  String get civilTwilightEnd;

  /// No description provided for @nauticalTwilightEnd.
  ///
  /// In en, this message translates to:
  /// **'Nautical Twilight End'**
  String get nauticalTwilightEnd;

  /// No description provided for @astroTwilightEnd.
  ///
  /// In en, this message translates to:
  /// **'Astro. Twilight End'**
  String get astroTwilightEnd;

  /// No description provided for @moonPhase.
  ///
  /// In en, this message translates to:
  /// **'Moon Phase'**
  String get moonPhase;

  /// No description provided for @illuminated.
  ///
  /// In en, this message translates to:
  /// **'{percent}% illuminated'**
  String illuminated(int percent);

  /// No description provided for @impact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impact;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @daysValue.
  ///
  /// In en, this message translates to:
  /// **'{value} days'**
  String daysValue(String value);

  /// No description provided for @visiblePlanets.
  ///
  /// In en, this message translates to:
  /// **'Visible Planets'**
  String get visiblePlanets;

  /// No description provided for @visible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get visible;

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hidden;

  /// No description provided for @mapLegendRadiance.
  ///
  /// In en, this message translates to:
  /// **'Map Legend — Radiance'**
  String get mapLegendRadiance;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @underDevelopment.
  ///
  /// In en, this message translates to:
  /// **'{title} is under development'**
  String underDevelopment(String title);

  /// No description provided for @bortleClass1Name.
  ///
  /// In en, this message translates to:
  /// **'Excellent Dark Sky'**
  String get bortleClass1Name;

  /// No description provided for @bortleClass1Desc.
  ///
  /// In en, this message translates to:
  /// **'The Milky Way casts shadows. Zodiacal light, gegenschein visible.'**
  String get bortleClass1Desc;

  /// No description provided for @bortleClass2Name.
  ///
  /// In en, this message translates to:
  /// **'Typical Dark Sky'**
  String get bortleClass2Name;

  /// No description provided for @bortleClass2Desc.
  ///
  /// In en, this message translates to:
  /// **'Milky Way highly structured. Zodiacal light bright.'**
  String get bortleClass2Desc;

  /// No description provided for @bortleClass3Name.
  ///
  /// In en, this message translates to:
  /// **'Rural Sky'**
  String get bortleClass3Name;

  /// No description provided for @bortleClass3Desc.
  ///
  /// In en, this message translates to:
  /// **'Milky Way still appears complex. Some light pollution on horizon.'**
  String get bortleClass3Desc;

  /// No description provided for @bortleClass4Name.
  ///
  /// In en, this message translates to:
  /// **'Rural/Suburban Transition'**
  String get bortleClass4Name;

  /// No description provided for @bortleClass4Desc.
  ///
  /// In en, this message translates to:
  /// **'Milky Way visible but lacks detail. Light domes visible.'**
  String get bortleClass4Desc;

  /// No description provided for @bortleClass5Name.
  ///
  /// In en, this message translates to:
  /// **'Suburban Sky'**
  String get bortleClass5Name;

  /// No description provided for @bortleClass5Desc.
  ///
  /// In en, this message translates to:
  /// **'Milky Way weak or invisible near horizon. Light domes prominent.'**
  String get bortleClass5Desc;

  /// No description provided for @bortleClass6Name.
  ///
  /// In en, this message translates to:
  /// **'Bright Suburban Sky'**
  String get bortleClass6Name;

  /// No description provided for @bortleClass6Desc.
  ///
  /// In en, this message translates to:
  /// **'Milky Way only visible near zenith. Sky glow across entire horizon.'**
  String get bortleClass6Desc;

  /// No description provided for @bortleClass7Name.
  ///
  /// In en, this message translates to:
  /// **'Suburban/Urban Transition'**
  String get bortleClass7Name;

  /// No description provided for @bortleClass7Desc.
  ///
  /// In en, this message translates to:
  /// **'Milky Way invisible. Sky has vague grayish-white hue.'**
  String get bortleClass7Desc;

  /// No description provided for @bortleClass8Name.
  ///
  /// In en, this message translates to:
  /// **'City Sky'**
  String get bortleClass8Name;

  /// No description provided for @bortleClass8Desc.
  ///
  /// In en, this message translates to:
  /// **'Sky glows white or orange. Only bright constellations visible.'**
  String get bortleClass8Desc;

  /// No description provided for @bortleClass9Name.
  ///
  /// In en, this message translates to:
  /// **'Inner City Sky'**
  String get bortleClass9Name;

  /// No description provided for @bortleClass9Desc.
  ///
  /// In en, this message translates to:
  /// **'Only Moon, planets, and a few bright stars visible.'**
  String get bortleClass9Desc;

  /// No description provided for @pristineDarkSky.
  ///
  /// In en, this message translates to:
  /// **'Pristine Dark Sky'**
  String get pristineDarkSky;

  /// No description provided for @darkSky.
  ///
  /// In en, this message translates to:
  /// **'Dark Sky'**
  String get darkSky;

  /// No description provided for @ruralSky.
  ///
  /// In en, this message translates to:
  /// **'Rural Sky'**
  String get ruralSky;

  /// No description provided for @suburbanSky.
  ///
  /// In en, this message translates to:
  /// **'Suburban Sky'**
  String get suburbanSky;

  /// No description provided for @brightSuburban.
  ///
  /// In en, this message translates to:
  /// **'Bright Suburban'**
  String get brightSuburban;

  /// No description provided for @urbanSky.
  ///
  /// In en, this message translates to:
  /// **'Urban Sky'**
  String get urbanSky;

  /// No description provided for @innerCitySky.
  ///
  /// In en, this message translates to:
  /// **'Inner City Sky'**
  String get innerCitySky;

  /// No description provided for @cloudyOvercast.
  ///
  /// In en, this message translates to:
  /// **'Cloudy / Overcast'**
  String get cloudyOvercast;

  /// No description provided for @impactMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get impactMinimal;

  /// No description provided for @impactLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get impactLow;

  /// No description provided for @impactModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get impactModerate;

  /// No description provided for @impactHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get impactHigh;

  /// No description provided for @impactSevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get impactSevere;

  /// No description provided for @impactDescExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent for stargazing'**
  String get impactDescExcellent;

  /// No description provided for @impactDescGood.
  ///
  /// In en, this message translates to:
  /// **'Good conditions'**
  String get impactDescGood;

  /// No description provided for @impactDescSome.
  ///
  /// In en, this message translates to:
  /// **'Some sky brightness'**
  String get impactDescSome;

  /// No description provided for @impactDescFaint.
  ///
  /// In en, this message translates to:
  /// **'Faint objects washed out'**
  String get impactDescFaint;

  /// No description provided for @impactDescBright.
  ///
  /// In en, this message translates to:
  /// **'Bright moonlight limits visibility'**
  String get impactDescBright;

  /// No description provided for @veryBright.
  ///
  /// In en, this message translates to:
  /// **'Very bright'**
  String get veryBright;

  /// No description provided for @brightLabel.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get brightLabel;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @dim.
  ///
  /// In en, this message translates to:
  /// **'Dim'**
  String get dim;

  /// No description provided for @faint.
  ///
  /// In en, this message translates to:
  /// **'Faint'**
  String get faint;

  /// No description provided for @reserveTitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve a Trip'**
  String get reserveTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get filterUpcoming;

  /// No description provided for @filterPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get filterPopular;

  /// No description provided for @guidedBy.
  ///
  /// In en, this message translates to:
  /// **'Guided by'**
  String get guidedBy;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @bortleClassLabel.
  ///
  /// In en, this message translates to:
  /// **'Bortle Class'**
  String get bortleClassLabel;

  /// No description provided for @groupSize.
  ///
  /// In en, this message translates to:
  /// **'Group Size'**
  String get groupSize;

  /// No description provided for @spotsLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Spots Left'**
  String get spotsLeftLabel;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String durationHours(int count);

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @aboutTrip.
  ///
  /// In en, this message translates to:
  /// **'About this trip'**
  String get aboutTrip;

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s included'**
  String get whatsIncluded;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'per person'**
  String get perPerson;

  /// No description provided for @noTripsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No trips available'**
  String get noTripsAvailable;

  /// No description provided for @tripBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get tripBooked;

  /// No description provided for @tripBookedMsg.
  ///
  /// In en, this message translates to:
  /// **'Trip booked successfully!'**
  String get tripBookedMsg;

  /// No description provided for @createTrip.
  ///
  /// In en, this message translates to:
  /// **'Create Trip'**
  String get createTrip;

  /// No description provided for @tripTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Title'**
  String get tripTitle;

  /// No description provided for @tripTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Milky Way Photography Night'**
  String get tripTitleHint;

  /// No description provided for @tripLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. AlUla, Saudi Arabia'**
  String get tripLocationHint;

  /// No description provided for @tripDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get tripDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get hours;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @addItemHint.
  ///
  /// In en, this message translates to:
  /// **'Add an item...'**
  String get addItemHint;

  /// No description provided for @tripCreated.
  ///
  /// In en, this message translates to:
  /// **'Trip posted successfully!'**
  String get tripCreated;

  /// No description provided for @darkSkySite.
  ///
  /// In en, this message translates to:
  /// **'Dark Sky Site'**
  String get darkSkySite;

  /// No description provided for @reserveTrip.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserveTrip;

  /// No description provided for @certifiedDarkSky.
  ///
  /// In en, this message translates to:
  /// **'Certified Dark Sky'**
  String get certifiedDarkSky;

  /// No description provided for @bortleClassInfo.
  ///
  /// In en, this message translates to:
  /// **'Bortle {value} — {certification}'**
  String bortleClassInfo(int value, String certification);

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Sura Premium'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For dedicated astronomers and sky photographers'**
  String get premiumSubtitle;

  /// No description provided for @premiumFeatureTrips.
  ///
  /// In en, this message translates to:
  /// **'Create & Post Trips'**
  String get premiumFeatureTrips;

  /// No description provided for @premiumFeatureTripsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create stargazing trips and share them with the community'**
  String get premiumFeatureTripsDesc;

  /// No description provided for @premiumFeatureBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium Badge'**
  String get premiumFeatureBadge;

  /// No description provided for @premiumFeatureBadgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand out with a premium star badge on your profile'**
  String get premiumFeatureBadgeDesc;

  /// No description provided for @premiumFeaturePriority.
  ///
  /// In en, this message translates to:
  /// **'Priority Booking'**
  String get premiumFeaturePriority;

  /// No description provided for @premiumFeaturePriorityDesc.
  ///
  /// In en, this message translates to:
  /// **'Get early access to popular stargazing trips'**
  String get premiumFeaturePriorityDesc;

  /// No description provided for @premiumFeatureAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Advanced Analysis'**
  String get premiumFeatureAnalysis;

  /// No description provided for @premiumFeatureAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock detailed AI sky quality reports'**
  String get premiumFeatureAnalysisDesc;

  /// No description provided for @premiumCriteriaTitle.
  ///
  /// In en, this message translates to:
  /// **'How to become Premium'**
  String get premiumCriteriaTitle;

  /// No description provided for @premiumCriteria1.
  ///
  /// In en, this message translates to:
  /// **'Active interest in astronomy and astrophotography'**
  String get premiumCriteria1;

  /// No description provided for @premiumCriteria2.
  ///
  /// In en, this message translates to:
  /// **'Regular posts about sky photos and stargazing locations'**
  String get premiumCriteria2;

  /// No description provided for @premiumCriteria3.
  ///
  /// In en, this message translates to:
  /// **'Strong community presence with engaged followers'**
  String get premiumCriteria3;

  /// No description provided for @applyForPremium.
  ///
  /// In en, this message translates to:
  /// **'Apply for Premium'**
  String get applyForPremium;

  /// No description provided for @premiumApplied.
  ///
  /// In en, this message translates to:
  /// **'Application submitted! We\'ll review your profile.'**
  String get premiumApplied;

  /// No description provided for @premiumAlreadyActive.
  ///
  /// In en, this message translates to:
  /// **'You\'re a Premium member!'**
  String get premiumAlreadyActive;

  /// No description provided for @premiumApplicationFailed.
  ///
  /// In en, this message translates to:
  /// **'Application failed. Please try again.'**
  String get premiumApplicationFailed;

  /// No description provided for @premiumMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMemberSince;

  /// No description provided for @premiumYourBenefits.
  ///
  /// In en, this message translates to:
  /// **'Your Benefits'**
  String get premiumYourBenefits;

  /// No description provided for @myTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTripsTitle;

  /// No description provided for @noBookedTrips.
  ///
  /// In en, this message translates to:
  /// **'No booked trips yet'**
  String get noBookedTrips;

  /// No description provided for @noBookedTripsDesc.
  ///
  /// In en, this message translates to:
  /// **'Trips you book will appear here'**
  String get noBookedTripsDesc;

  /// No description provided for @pickFromMap.
  ///
  /// In en, this message translates to:
  /// **'Pick from map'**
  String get pickFromMap;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @changeCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Change cover image'**
  String get changeCoverImage;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading image...'**
  String get uploadingImage;

  /// No description provided for @verdictExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent for stargazing! Milky Way should be visible.'**
  String get verdictExcellent;

  /// No description provided for @verdictGood.
  ///
  /// In en, this message translates to:
  /// **'Good for stargazing. Many stars and constellations visible.'**
  String get verdictGood;

  /// No description provided for @verdictDecent.
  ///
  /// In en, this message translates to:
  /// **'Decent for stargazing. Bright stars and planets visible.'**
  String get verdictDecent;

  /// No description provided for @verdictPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor for stargazing. Only the brightest stars visible.'**
  String get verdictPoor;

  /// No description provided for @verdictVeryPoor.
  ///
  /// In en, this message translates to:
  /// **'Very poor for stargazing. Only a few stars visible.'**
  String get verdictVeryPoor;

  /// No description provided for @verdictNotSuitable.
  ///
  /// In en, this message translates to:
  /// **'Not suitable for stargazing. Too much light pollution.'**
  String get verdictNotSuitable;

  /// No description provided for @verdictCloudy.
  ///
  /// In en, this message translates to:
  /// **'Not suitable for stargazing. Sky is cloudy or overcast.'**
  String get verdictCloudy;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
