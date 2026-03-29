import '../../community/models/community_models.dart';
import '../../community/models/mock_data.dart';
import 'chat_models.dart';

class MockChats {
  static const _myId = 'me';

  // Shared state — persists during app session
  static List<Conversation>? _cachedConversations;

  static List<Conversation> getConversations() {
    _cachedConversations ??= _createConversations();
    return _cachedConversations!;
  }

  static void updateConversation(Conversation updated) {
    if (_cachedConversations == null) return;
    final index = _cachedConversations!.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _cachedConversations![index] = updated;
    } else {
      _cachedConversations!.insert(0, updated);
    }
  }

  static List<Conversation> _createConversations() {
    return [
      Conversation(
        id: 'conv_1',
        otherUser: MockData.suraOfficial,
        unreadCount: 2,
        messages: [
          ChatMessage(
            id: 'm1',
            text: 'مرحبا! شكراً على انضمامك لمجتمع سُرى',
            senderId: MockData.suraOfficial.id,
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
          ),
          ChatMessage(
            id: 'm2',
            text: 'أهلاً وسهلاً! تطبيق رائع',
            senderId: _myId,
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
          ),
          ChatMessage(
            id: 'm3',
            text: 'شكراً لك! لا تنسى تجرب ميزة تحليل التلوث الضوئي',
            senderId: MockData.suraOfficial.id,
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 23)),
          ),
          ChatMessage(
            id: 'm4',
            text: 'وفيه رحلة قادمة للعلا الشهر الجاي، سجل من قسم الحجز',
            senderId: MockData.suraOfficial.id,
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            isRead: false,
          ),
          ChatMessage(
            id: 'm5',
            text: 'تقدر تشوف أفضل المواقع من خريطة التلوث الضوئي',
            senderId: MockData.suraOfficial.id,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isRead: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv_2',
        otherUser: MockData.norahStars,
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: 'm6',
            text: 'هلا! شفت صورك للسماء، تصوير رهيب',
            senderId: _myId,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
          ),
          ChatMessage(
            id: 'm7',
            text: 'شكراً! تستخدم أي كاميرا؟',
            senderId: MockData.norahStars.id,
            timestamp: DateTime.now().subtract(const Duration(hours: 20)),
          ),
          ChatMessage(
            id: 'm8',
            text: 'Sony A7III مع عدسة 24mm',
            senderId: _myId,
            timestamp: DateTime.now().subtract(const Duration(hours: 18)),
          ),
          ChatMessage(
            id: 'm9',
            text: 'اختيار ممتاز! أنا أستخدم نفس الكاميرا',
            senderId: MockData.norahStars.id,
            timestamp: DateTime.now().subtract(const Duration(hours: 17)),
          ),
        ],
      ),
      Conversation(
        id: 'conv_3',
        otherUser: MockData.khaledAstro,
        unreadCount: 1,
        messages: [
          ChatMessage(
            id: 'm10',
            text: 'مرحبا خالد، ايش أفضل تلسكوب للمبتدئين؟',
            senderId: _myId,
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
          ),
          ChatMessage(
            id: 'm11',
            text: 'أنصحك بـ Celestron NexStar 6SE',
            senderId: MockData.khaledAstro.id,
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
          ),
          ChatMessage(
            id: 'm12',
            text: 'سعره معقول وجودته ممتازة للمبتدئين',
            senderId: MockData.khaledAstro.id,
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
          ),
          ChatMessage(
            id: 'm13',
            text: 'وفيه عرض حالياً على أمازون',
            senderId: MockData.khaledAstro.id,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isRead: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv_4',
        otherUser: MockData.lailaGalaxy,
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: 'm14',
            text: 'رحلة ينبع كانت رهيبة! متى الرحلة الجاية؟',
            senderId: _myId,
            timestamp: DateTime.now().subtract(const Duration(days: 4)),
          ),
          ChatMessage(
            id: 'm15',
            text: 'إن شاء الله الشهر الجاي، بنروح تبوك',
            senderId: MockData.lailaGalaxy.id,
            timestamp: DateTime.now().subtract(const Duration(days: 4)),
          ),
          ChatMessage(
            id: 'm16',
            text: 'حلو! سجلني معاكم',
            senderId: _myId,
            timestamp: DateTime.now().subtract(const Duration(days: 4)),
          ),
        ],
      ),
      Conversation(
        id: 'conv_5',
        otherUser: MockData.faisalNebula,
        unreadCount: 0,
        messages: [
          ChatMessage(
            id: 'm17',
            text: 'فيصل، شفت المجرة أمس من العلا؟',
            senderId: _myId,
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
          ),
          ChatMessage(
            id: 'm18',
            text: 'إيه والله! كانت واضحة جداً، بورتل ٢',
            senderId: MockData.faisalNebula.id,
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
          ),
        ],
      ),
    ];
  }
}
