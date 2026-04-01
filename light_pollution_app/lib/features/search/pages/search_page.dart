import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../community/models/community_models.dart';
import '../../community/models/mock_data.dart';
import '../../community/providers/community_provider.dart';
import '../../community/widgets/sky_post_card.dart';
import '../../community/widgets/comments_sheet.dart';
import '../../community/pages/user_profile_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  String _query = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<MockUser> _searchUsers(String query) {
    if (query.isEmpty) return MockData.allUsers;
    final q = query.toLowerCase();
    return MockData.allUsers.where((user) {
      return user.name.toLowerCase().contains(q) ||
          user.username.toLowerCase().contains(q) ||
          user.bio.toLowerCase().contains(q);
    }).toList();
  }

  List<SkyPost> _searchPosts(String query, List<SkyPost> allPosts) {
    if (query.isEmpty) return allPosts;
    final q = query.toLowerCase();
    return allPosts.where((post) {
      return post.caption.toLowerCase().contains(q) ||
          post.user.name.toLowerCase().contains(q) ||
          post.user.username.toLowerCase().contains(q) ||
          (post.location?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  void _searchForTopic(String topic) {
    _searchController.text = topic;
    setState(() {
      _query = topic;
      _isSearching = true;
    });
    _tabController.animateTo(1); // Switch to Posts tab
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final postsAsync = ref.watch(postsStreamProvider);
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: c.background,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: c.divider),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search, color: c.textHint, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {
                          _query = value;
                          _isSearching = value.isNotEmpty;
                        }),
                        style: font(fontSize: 15, color: c.textPrimary),
                        decoration: InputDecoration(
                          hintText: l10n.searchHint,
                          hintStyle: font(fontSize: 15, color: c.textHint),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                            _isSearching = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.close, color: c.textHint, size: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Show discovery view or search results
            if (!_isSearching) ...[
              // Discovery / Explore view
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8),
                  children: [
                    // Astronomy News Section
                    _buildNewsSection(font, l10n),
                    const SizedBox(height: 8),
                    // Trending Topics
                    _buildTrendingTopics(font, l10n),
                    const SizedBox(height: 8),
                    // Suggested People
                    _buildSuggestedPeople(font, l10n),
                  ],
                ),
              ),
            ] else ...[
              // Tabs for search results
              TabBar(
                controller: _tabController,
                labelColor: c.accent,
                unselectedLabelColor: c.textSecondary,
                indicatorColor: c.accent,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: font(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle: font(fontSize: 14, fontWeight: FontWeight.w400),
                tabs: [
                  Tab(text: l10n.people),
                  Tab(text: l10n.posts),
                ],
              ),
              Divider(height: 1, color: c.divider),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPeopleTab(font, l10n),
                    _buildPostsTab(postsAsync, font, l10n),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── News Section ──

  Widget _buildNewsSection(
      TextStyle Function({Color? color, double? fontSize, FontWeight? fontWeight, double? height, double? letterSpacing, TextDecoration? decoration}) font,
      AppLocalizations l10n) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final news = isArabic ? _arabicNews : _englishNews;
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: c.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.astronomyNews,
                style: font(
                  color: c.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: news.length,
            itemBuilder: (context, index) {
              final item = news[index];
              return _NewsCard(
                title: item['title']!,
                source: item['source']!,
                gradient: _newsGradients[index % _newsGradients.length],
                icon: _newsIcons[index % _newsIcons.length],
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Trending Topics ──

  Widget _buildTrendingTopics(
      TextStyle Function({Color? color, double? fontSize, FontWeight? fontWeight, double? height, double? letterSpacing, TextDecoration? decoration}) font,
      AppLocalizations l10n) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final topics = isArabic ? _arabicTopics : _englishTopics;
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Icon(Icons.trending_up, color: c.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.trendingTopics,
                style: font(
                  color: c.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topics.map((topic) {
              return ActionChip(
                label: Text(
                  '#$topic',
                  style: font(color: c.accent, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                backgroundColor: c.accent.withValues(alpha: 0.08),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: () => _searchForTopic(topic),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Suggested People ──

  Widget _buildSuggestedPeople(
      TextStyle Function({Color? color, double? fontSize, FontWeight? fontWeight, double? height, double? letterSpacing, TextDecoration? decoration}) font,
      AppLocalizations l10n) {
    final users = MockData.allUsers.where((u) => u.isVerified).take(5).toList();
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Icon(Icons.people_outline, color: c.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.people,
                style: font(
                  color: c.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        ...users.map((user) => _buildUserTile(user, font)),
      ],
    );
  }

  // ── People Tab (search results) ──

  Widget _buildPeopleTab(
      TextStyle Function({Color? color, double? fontSize, FontWeight? fontWeight, double? height, double? letterSpacing, TextDecoration? decoration}) font,
      AppLocalizations l10n) {
    final users = _searchUsers(_query);
    final c = context.colors;

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 48, color: c.textHint),
            const SizedBox(height: 12),
            Text(
              l10n.noUsersFound,
              style: font(color: c.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => _buildUserTile(users[index], font),
    );
  }

  Widget _buildUserTile(MockUser user,
      TextStyle Function({Color? color, double? fontSize, FontWeight? fontWeight, double? height, double? letterSpacing, TextDecoration? decoration}) font) {
    final c = context.colors;
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => UserProfilePage(user: user)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.navy,
              child: Text(
                user.avatarInitials,
                style: font(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.name,
                          style: font(color: c.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, color: c.accent, size: 16),
                      ],
                      if (user.isPremium) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(user.username, style: font(color: c.textSecondary, fontSize: 13)),
                  if (user.bio.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.bio,
                      style: font(color: c.textSecondary, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Posts Tab (search results) ──

  Widget _buildPostsTab(AsyncValue<List<SkyPost>> postsAsync,
      TextStyle Function({Color? color, double? fontSize, FontWeight? fontWeight, double? height, double? letterSpacing, TextDecoration? decoration}) font,
      AppLocalizations l10n) {
    final c = context.colors;
    return postsAsync.when(
      loading: () => Center(child: CircularProgressIndicator(color: c.accent)),
      error: (e, _) => Center(
        child: Text(l10n.failedToLoadPosts, style: font(color: c.textSecondary)),
      ),
      data: (posts) {
        final filtered = _searchPosts(_query, posts);
        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 48, color: c.textHint),
                const SizedBox(height: 12),
                Text(l10n.noPostsFound, style: font(color: c.textSecondary, fontSize: 16)),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final post = filtered[index];
            return SkyPostCard(
              post: post,
              onLike: () => ref.read(communityProvider.notifier).toggleLike(post.id),
              onComment: () => _showComments(context, post),
              onDelete: () => ref.read(communityProvider.notifier).deletePost(post.id),
              onUserTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => UserProfilePage(user: post.user)),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showComments(BuildContext context, SkyPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => CommentsSheet(post: post),
      ),
    );
  }
}

// ── News Card Widget ──

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.title,
    required this.source,
    required this.gradient,
    required this.icon,
  });

  final String title;
  final String source;
  final List<Color> gradient;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final font = AppFonts.style(context);
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 28),
            const Spacer(),
            Text(
              title,
              style: font(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600, height: 1.3),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              source,
              style: font(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Static Data ──

const _newsGradients = [
  [Color(0xFF0a0a2e), Color(0xFF1a1a4e)],
  [Color(0xFF000814), Color(0xFF001d3d)],
  [Color(0xFF0a0020), Color(0xFF2d1b69)],
  [Color(0xFF1a0a00), Color(0xFF3d1a00)],
];

const _newsIcons = [
  Icons.rocket_launch,
  Icons.public,
  Icons.satellite_alt,
  Icons.stars,
];

const _englishNews = [
  {'title': 'Saturn\'s rings will disappear from view in 2025 due to orbital tilt', 'source': 'NASA'},
  {'title': 'James Webb Telescope discovers high-redshift galaxies challenging early universe models', 'source': 'ESA'},
  {'title': 'Perseid meteor shower peaks in August with up to 100 meteors per hour', 'source': 'Sky & Telescope'},
  {'title': 'New dark sky reserves established across the Arabian Peninsula', 'source': 'Sura Community'},
];

const _arabicNews = [
  {'title': 'حلقات زحل ستختفي عن الأنظار في ٢٠٢٥ بسبب ميل المدار', 'source': 'ناسا'},
  {'title': 'تلسكوب جيمس ويب يكتشف مجرات تتحدى نماذج الكون المبكر', 'source': 'وكالة الفضاء الأوروبية'},
  {'title': 'زخات شهب البرشاويات تبلغ ذروتها في أغسطس بمعدل ١٠٠ شهاب في الساعة', 'source': 'سكاي آند تلسكوب'},
  {'title': 'إنشاء محميات سماء مظلمة جديدة في أنحاء الجزيرة العربية', 'source': 'مجتمع سُرى'},
];

const _englishTopics = [
  'MilkyWay', 'Astrophotography', 'DarkSky', 'Bortle1',
  'StarTrail', 'LunarEclipse', 'NightSky', 'Stargazing',
  'Nebula', 'AlUla', 'LightPollution', 'Telescope',
];

const _arabicTopics = [
  'درب_التبانة', 'تصوير_فلكي', 'سماء_مظلمة', 'بورتل١',
  'أثر_النجوم', 'خسوف_القمر', 'سماء_الليل', 'رصد_النجوم',
  'سديم', 'العلا', 'تلوث_ضوئي', 'تلسكوب',
];
