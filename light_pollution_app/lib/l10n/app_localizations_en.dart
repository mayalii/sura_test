// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Light Pollution Detector';

  @override
  String get sura => 'Sura';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUpLink => 'Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginLink => 'Login';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinCommunity => 'Join the stargazing community';

  @override
  String get fullName => 'Full Name';

  @override
  String get username => 'Username';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterAPassword => 'Enter a password';

  @override
  String get enterName => 'Enter your name';

  @override
  String get chooseUsername => 'Choose a username';

  @override
  String get usernameTooShort => 'Username must be at least 3 characters';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get errorNoAccount => 'No account found with this email.';

  @override
  String get errorWrongPassword => 'Incorrect email or password.';

  @override
  String get errorInvalidEmail => 'Please enter a valid email.';

  @override
  String get errorTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get errorLoginFailed => 'Login failed. Please try again.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get checkYourEmail => 'Check Your Email';

  @override
  String get resetEmailSentTo => 'We\'ve sent a password reset link to';

  @override
  String get resetEmailInstructions =>
      'Open the email and tap the link to set a new password. Then come back and log in.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get didntGetEmail => 'Didn\'t get the email? ';

  @override
  String get resend => 'Resend';

  @override
  String get resetPasswordFailed =>
      'Failed to send reset email. Check your email address.';

  @override
  String get errorEmailInUse => 'This email is already registered.';

  @override
  String get errorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get errorSignUpFailed => 'Sign up failed. Please try again.';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navCamera => 'Camera';

  @override
  String get navMap => 'Map';

  @override
  String get navReserve => 'Reserve';

  @override
  String get navChat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get premium => 'Premium';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get lists => 'Lists';

  @override
  String get communities => 'Communities';

  @override
  String get myReservations => 'My Trips';

  @override
  String get settingsPrivacy => 'Settings and privacy';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get failedToLoadPosts => 'Failed to load posts.';

  @override
  String get noPostsYet => 'No posts yet. Be the first to share!';

  @override
  String get cancel => 'Cancel';

  @override
  String get post => 'Post';

  @override
  String get whatsHappening => 'What\'s happening?';

  @override
  String get everyoneCanReply => 'Everyone can reply';

  @override
  String get deletePost => 'Delete post';

  @override
  String failedToPost(String error) {
    return 'Failed to post: $error';
  }

  @override
  String get comments => 'Comments';

  @override
  String get noCommentsYet => 'No comments yet';

  @override
  String get addComment => 'Add a comment...';

  @override
  String get posts => 'Posts';

  @override
  String get repliesTab => 'Replies';

  @override
  String get photos => 'Photos';

  @override
  String get likesTab => 'Likes';

  @override
  String get noPostsYetSimple => 'No posts yet';

  @override
  String get noRepliesYet => 'No replies yet';

  @override
  String get noPhotosYet => 'No photos yet';

  @override
  String get noLikesYet => 'No likes yet';

  @override
  String get loadingText => 'Loading...';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get save => 'Save';

  @override
  String get nameLabel => 'Name';

  @override
  String get bioLabel => 'Bio';

  @override
  String get locationLabel => 'Location';

  @override
  String get websiteLabel => 'Website';

  @override
  String get addWebsite => 'Add your website';

  @override
  String get birthDate => 'Birth date';

  @override
  String get addBirthDate => 'Add your birth date';

  @override
  String get switchToProfessional => 'Switch to Professional';

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String failedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get pollutionDetection => 'Pollution Detection';

  @override
  String get takeOrUploadPhoto =>
      'Take or upload a photo of the night sky\nto detect light pollution level';

  @override
  String get photoButton => 'PHOTO';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analysisFailed => 'Analysis Failed';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get reExamine => 'Re-examine';

  @override
  String get skyQualityLabel => 'Sky Quality:';

  @override
  String get details => 'Details';

  @override
  String bortleValue(int value) {
    return 'Bortle $value';
  }

  @override
  String get aiModelScore => 'AI Model Score';

  @override
  String get pixelAnalysisScore => 'Pixel Analysis Score';

  @override
  String get meanBrightness => 'Mean Brightness';

  @override
  String get brightPixels => 'Bright Pixels';

  @override
  String get darkPixels => 'Dark Pixels';

  @override
  String get blueRatio => 'Blue Ratio';

  @override
  String get orangeRatio => 'Orange Ratio';

  @override
  String get brightnessDistribution => 'Brightness Distribution';

  @override
  String get dark => 'Dark';

  @override
  String get bright => 'Bright';

  @override
  String get explore => 'Explore';

  @override
  String get toggleLegend => 'Toggle legend';

  @override
  String get lightPollutionOverlay => 'Light Pollution Overlay';

  @override
  String get opacity => 'Opacity';

  @override
  String get yearLabel => 'Year: ';

  @override
  String get bortleScale => 'Bortle Scale';

  @override
  String get searchLocation => 'Search location...';

  @override
  String get tapLocation => 'Tap a location on the map';

  @override
  String get orSearchCity => 'or search for a city above';

  @override
  String get someDataFailed =>
      'Some data couldn\'t be loaded. Showing available info.';

  @override
  String get stargazingScore => 'Stargazing Score';

  @override
  String get outOf100 => 'out of 100';

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Good';

  @override
  String get fair => 'Fair';

  @override
  String get poor => 'Poor';

  @override
  String get veryPoor => 'Very Poor';

  @override
  String get clouds => 'Clouds';

  @override
  String get moon => 'Moon';

  @override
  String get bortle => 'Bortle';

  @override
  String get skyPhotoAnalyzer => 'Sky Photo Analyzer';

  @override
  String get uploadSkyPhoto => 'Upload a sky photo';

  @override
  String get tapToSelect => 'Tap to select from gallery';

  @override
  String get skyQuality => 'Sky Quality';

  @override
  String get avgBrightness => 'Avg Brightness';

  @override
  String get warmGlow => 'Warm Glow';

  @override
  String get skyColor => 'Sky Color: ';

  @override
  String get analyzeAnotherPhoto => 'Analyze another photo';

  @override
  String get lightPollutionBortle => 'Light Pollution (Bortle Scale)';

  @override
  String classLabel(int value, String name) {
    return 'Class $value — $name';
  }

  @override
  String get currentWeather => 'Current Weather';

  @override
  String get cloudCover => 'Cloud Cover';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get cloudCover24h => 'Cloud Cover (24h)';

  @override
  String get sunTwilight => 'Sun & Twilight';

  @override
  String dayDuration(String duration) {
    return 'Day: $duration';
  }

  @override
  String nightDuration(String duration) {
    return 'Night: $duration';
  }

  @override
  String get sunrise => 'Sunrise';

  @override
  String get solarNoon => 'Solar Noon';

  @override
  String get sunset => 'Sunset';

  @override
  String get civilTwilightEnd => 'Civil Twilight End';

  @override
  String get nauticalTwilightEnd => 'Nautical Twilight End';

  @override
  String get astroTwilightEnd => 'Astro. Twilight End';

  @override
  String get moonPhase => 'Moon Phase';

  @override
  String illuminated(int percent) {
    return '$percent% illuminated';
  }

  @override
  String get impact => 'Impact';

  @override
  String get ageLabel => 'Age';

  @override
  String daysValue(String value) {
    return '$value days';
  }

  @override
  String get visiblePlanets => 'Visible Planets';

  @override
  String get visible => 'Visible';

  @override
  String get hidden => 'Hidden';

  @override
  String get mapLegendRadiance => 'Map Legend — Radiance';

  @override
  String get low => 'Low';

  @override
  String get high => 'High';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String underDevelopment(String title) {
    return '$title is under development';
  }

  @override
  String get bortleClass1Name => 'Excellent Dark Sky';

  @override
  String get bortleClass1Desc =>
      'The Milky Way casts shadows. Zodiacal light, gegenschein visible.';

  @override
  String get bortleClass2Name => 'Typical Dark Sky';

  @override
  String get bortleClass2Desc =>
      'Milky Way highly structured. Zodiacal light bright.';

  @override
  String get bortleClass3Name => 'Rural Sky';

  @override
  String get bortleClass3Desc =>
      'Milky Way still appears complex. Some light pollution on horizon.';

  @override
  String get bortleClass4Name => 'Rural/Suburban Transition';

  @override
  String get bortleClass4Desc =>
      'Milky Way visible but lacks detail. Light domes visible.';

  @override
  String get bortleClass5Name => 'Suburban Sky';

  @override
  String get bortleClass5Desc =>
      'Milky Way weak or invisible near horizon. Light domes prominent.';

  @override
  String get bortleClass6Name => 'Bright Suburban Sky';

  @override
  String get bortleClass6Desc =>
      'Milky Way only visible near zenith. Sky glow across entire horizon.';

  @override
  String get bortleClass7Name => 'Suburban/Urban Transition';

  @override
  String get bortleClass7Desc =>
      'Milky Way invisible. Sky has vague grayish-white hue.';

  @override
  String get bortleClass8Name => 'City Sky';

  @override
  String get bortleClass8Desc =>
      'Sky glows white or orange. Only bright constellations visible.';

  @override
  String get bortleClass9Name => 'Inner City Sky';

  @override
  String get bortleClass9Desc =>
      'Only Moon, planets, and a few bright stars visible.';

  @override
  String get pristineDarkSky => 'Pristine Dark Sky';

  @override
  String get darkSky => 'Dark Sky';

  @override
  String get ruralSky => 'Rural Sky';

  @override
  String get suburbanSky => 'Suburban Sky';

  @override
  String get brightSuburban => 'Bright Suburban';

  @override
  String get urbanSky => 'Urban Sky';

  @override
  String get innerCitySky => 'Inner City Sky';

  @override
  String get cloudyOvercast => 'Cloudy / Overcast';

  @override
  String get impactMinimal => 'Minimal';

  @override
  String get impactLow => 'Low';

  @override
  String get impactModerate => 'Moderate';

  @override
  String get impactHigh => 'High';

  @override
  String get impactSevere => 'Severe';

  @override
  String get impactDescExcellent => 'Excellent for stargazing';

  @override
  String get impactDescGood => 'Good conditions';

  @override
  String get impactDescSome => 'Some sky brightness';

  @override
  String get impactDescFaint => 'Faint objects washed out';

  @override
  String get impactDescBright => 'Bright moonlight limits visibility';

  @override
  String get veryBright => 'Very bright';

  @override
  String get brightLabel => 'Bright';

  @override
  String get moderate => 'Moderate';

  @override
  String get dim => 'Dim';

  @override
  String get faint => 'Faint';

  @override
  String get reserveTitle => 'Reserve a Trip';

  @override
  String get filterAll => 'All';

  @override
  String get filterUpcoming => 'Upcoming';

  @override
  String get filterPopular => 'Popular';

  @override
  String get guidedBy => 'Guided by';

  @override
  String get rating => 'Rating';

  @override
  String get bortleClassLabel => 'Bortle Class';

  @override
  String get groupSize => 'Group Size';

  @override
  String get spotsLeftLabel => 'Spots Left';

  @override
  String durationHours(int count) {
    return '$count hours';
  }

  @override
  String get bookNow => 'Book Now';

  @override
  String get aboutTrip => 'About this trip';

  @override
  String get whatsIncluded => 'What\'s included';

  @override
  String get perPerson => 'per person';

  @override
  String get noTripsAvailable => 'No trips available';

  @override
  String get tripBooked => 'Booked';

  @override
  String get tripBookedMsg => 'Trip booked successfully!';

  @override
  String get createTrip => 'Create Trip';

  @override
  String get tripTitle => 'Trip Title';

  @override
  String get tripTitleHint => 'e.g. Milky Way Photography Night';

  @override
  String get tripLocationHint => 'e.g. AlUla, Saudi Arabia';

  @override
  String get tripDate => 'Date';

  @override
  String get selectDate => 'Select a date';

  @override
  String get duration => 'Duration';

  @override
  String get hours => 'hrs';

  @override
  String get price => 'Price';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get addItemHint => 'Add an item...';

  @override
  String get tripCreated => 'Trip posted successfully!';

  @override
  String get darkSkySite => 'Dark Sky Site';

  @override
  String get reserveTrip => 'Reserve';

  @override
  String get certifiedDarkSky => 'Certified Dark Sky';

  @override
  String bortleClassInfo(int value, String certification) {
    return 'Bortle $value — $certification';
  }

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get premiumTitle => 'Sura Premium';

  @override
  String get premiumSubtitle =>
      'For dedicated astronomers and sky photographers';

  @override
  String get premiumFeatureTrips => 'Create & Post Trips';

  @override
  String get premiumFeatureTripsDesc =>
      'Create stargazing trips and share them with the community';

  @override
  String get premiumFeatureBadge => 'Premium Badge';

  @override
  String get premiumFeatureBadgeDesc =>
      'Stand out with a premium star badge on your profile';

  @override
  String get premiumFeaturePriority => 'Priority Booking';

  @override
  String get premiumFeaturePriorityDesc =>
      'Get early access to popular stargazing trips';

  @override
  String get premiumFeatureAnalysis => 'Advanced Analysis';

  @override
  String get premiumFeatureAnalysisDesc =>
      'Unlock detailed AI sky quality reports';

  @override
  String get premiumCriteriaTitle => 'How to become Premium';

  @override
  String get premiumCriteria1 =>
      'Active interest in astronomy and astrophotography';

  @override
  String get premiumCriteria2 =>
      'Regular posts about sky photos and stargazing locations';

  @override
  String get premiumCriteria3 =>
      'Strong community presence with engaged followers';

  @override
  String get applyForPremium => 'Apply for Premium';

  @override
  String get premiumApplied =>
      'Application submitted! We\'ll review your profile.';

  @override
  String get premiumAlreadyActive => 'You\'re a Premium member!';

  @override
  String get premiumApplicationFailed =>
      'Application failed. Please try again.';

  @override
  String get premiumMemberSince => 'Premium Member';

  @override
  String get premiumYourBenefits => 'Your Benefits';

  @override
  String get myTripsTitle => 'My Trips';

  @override
  String get noBookedTrips => 'No booked trips yet';

  @override
  String get noBookedTripsDesc => 'Trips you book will appear here';

  @override
  String get pickFromMap => 'Pick from map';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get changeCoverImage => 'Change cover image';

  @override
  String get uploadingImage => 'Uploading image...';

  @override
  String get verdictExcellent =>
      'Excellent for stargazing! Milky Way should be visible.';

  @override
  String get verdictGood =>
      'Good for stargazing. Many stars and constellations visible.';

  @override
  String get verdictDecent =>
      'Decent for stargazing. Bright stars and planets visible.';

  @override
  String get verdictPoor =>
      'Poor for stargazing. Only the brightest stars visible.';

  @override
  String get verdictVeryPoor =>
      'Very poor for stargazing. Only a few stars visible.';

  @override
  String get verdictNotSuitable =>
      'Not suitable for stargazing. Too much light pollution.';

  @override
  String get verdictCloudy =>
      'Not suitable for stargazing. Sky is cloudy or overcast.';
}
