class Endpoints {
  Endpoints._();

  // auth
  static const register = '/auth/register';
  static const login = '/auth/login';

  static const appleLogin = '/auth/apple/login';
  static const googleLogin = '/auth/google/login';
  static const facebookLogin = '/auth/facebook/login';

  static const forgotPassword = '/auth/forget-password';
  static const verifyOtp = '/auth/verify-otp';
  static const resetPassword = '/auth/reset-password'; // otp is sent to email

  static const updateProfile = '/auth/user'; // user enters old password
  static const updateAvatar = '/auth/avatar';
  static const logout = '/auth/logout';

  static const resendVerificationEmail = '/auth/email/verification';

  static const userProfile = '/user';

  // push notification registration
  static const syncDevice = '/sync-device';

  // groups
  // static const joinGroup = '/group/join';
  // static const joinSubgroup = '/subgroup/join';
  // static const leaveSubgroup = '/subgroup/leave';
  // static const subgroups = '/sub-groups';
  // static const checkGroup = '/check/status';

  // home
  static const homeFeed = '/user/home';
  static const guestFeed = '/group';

  static const guestGroupFeed = '/guest/group';
  static const news = '/news';
  static const videos = '/videos';
  static const adoptions = '/adoptions';
  static const podcasts = '/podcasts';
  static const live = '/live-events';
  static const events = '/events';
  static const podcastEpisodes = '/podcast';
  static const likePodcastEpisode = '/like/podcast';
  static const commentPodcastEpisode = '/comment/podcast';

  static const search = '/search';

  static const campaign = '/campaign';
  static const campaigns = '/campaigns';

  static const guestCampaignDetail = '/campaign';

  static const campaignDetail = '/view-campaign';
  static const campaignUpdates = '/campaign/updates';
  static const campaignUpdateDetail = '/campaign/update';

  static const posts = '/posts/all';
  static const postDetail = '/post';

  static const likePost = '/post/like';
  static const commentOnPost = '/post/comment';

  static const donations = '/my-donations';

  static const messages = '/conversations';
  static const likeMessage = '/conversation/like';
  static const thread = '/conversation';

  static const notifications = '/notifications';

  static const getPaymentMethods = '/get/payment-methods';

  // static const getPaymentToken = '/user/deposit';
  // static const verifyTopUp = '/user/deposit';

  static const initiateDeposit = '/user/deposit/initiate';
  static const finalizeDeposit = '/user/deposit/finalize';

  static const initiatePayment = '/campaign/payment/initiate';
  static const finalizePayment = '/campaign/payment/finalize';

  static const initiateCharityDonation = '/charity/payment/initiate';
  static const finalizeCharityDonation = '/charity/payment/finalize';

  static const initiateSubscription = '/campaign/subscription/initiate';
  static const finalizeSubscription = '/campaign/subscription/finalize';
  static const cancelSubscription = '/campaign/subscription/cancel';

  static const initiateEcarePay = '/live/gift/initiate';
  static const finalizeEcarePay = '/live/gift/finalize';

  static const transactionHistory = '/wallet/history';
  static const allCharities = '/charities/all';
  static const categoryCharities = '/charities/category';
  static const categoriesList = '/categories/list';
  static const searchCharities = '/charities/search';
  static const portfolioSync = '/portfolio/sync';
  static const initiateKiindDonation = '/kiind/donation/initiate';
  static const finalizeKiindDonation = '/kiind/donation/finalize';
  static const philanthropyPortfolio = '/my-portfolio';
  static const cancelKiindSubscription = '/kiind/subscription/cancel';

  static const categoriesAll = '/categories/all';
  static const guestCategoriesList = '/guest/categories/all';

  static const getCharityDonationTypes = '/v2/charity-categories';

  static const categoryHomeFeed = '/home/category';
  static const categoryPosts = '/posts/category';
  static const categoryLive = '/live-events/category';
  static const categoryPodcasts = '/podcasts/category';
  static const categoryVideos = '/videos/category/';
  static const categoryNews = '/news/category/';
  static const categoryAdoptions = '/adoptions/category/';
  static const categoryCampaigns = '/campaigns-only/category/';
  static const categoryCampaignsOnly = '/campaigns/category/';

  static const addSubCategories = '/interests/sync';
  static const guestAddSubCategories = '/guest/interests';

  static const featuredAll = '/featured/all';
  static const featuredPosts = '/featured/posts';
  static const featuredCampaigns = '/featured/campaigns';
  static const deleteAccountInit = '/auth/delete/init';
  static const deleteAccountComplete = '/auth/delete/confirm';

  static const openEndpoints = {
    register: true,
    login: true,
    appleLogin: true,
    googleLogin: true,
    facebookLogin: true,
    forgotPassword: true,
    verifyOtp: true,
    resetPassword: true,
  };
}
