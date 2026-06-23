import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/chat_message.dart';
import 'ai_chat_providers.dart';

/// Local mock chat with the ODDEM designer. Type Arabic, press send, see your
/// message, and receive a mock designer reply. No backend / no AI API.
///
/// UI/UX patterns (bubbles with directional tails, sender/assistant alignment,
/// avatar, composer bar, typing indicator, quick-reply chips) are inspired by
/// common chat UIs — implemented from scratch for ODDEM, fully RTL.
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  /// Quick starter prompts (Arabic) — tapping sends them immediately.
  static const _suggestions = <String>[
    'صمّم لي مجلس حديث',
    'أفكار لغرفة نوم',
    'اقتراح ضمن ٢٠٠٠٠ ريال',
    'طاولة طعام لـ٦ أشخاص',
  ];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty) return;
    _input.clear();
    await ref.read(aiChatControllerProvider.notifier).send(text);
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(aiChatControllerProvider);
    _scrollToBottom();

    final itemCount = chat.messages.length + (chat.isTyping ? 1 : 0);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const _DesignerAvatar(size: 34),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('مصمم Odem', style: AppTextStyles.subtitle),
                Text('مساعد تصميم • تجريبي', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxBubble = constraints.maxWidth * 0.78;
                  return ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                    itemCount: itemCount,
                    itemBuilder: (context, i) {
                      if (chat.isTyping && i == chat.messages.length) {
                        return _MessageRow(
                          isUser: false,
                          maxBubbleWidth: maxBubble,
                          child: const _TypingDots(),
                        );
                      }
                      final m = chat.messages[i];
                      return _MessageRow(
                        isUser: m.isUser,
                        maxBubbleWidth: maxBubble,
                        time: _hhmm(m.time),
                        child: Text(
                          m.text,
                          style: AppTextStyles.body.copyWith(
                            color: m.isUser
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _SuggestionBar(
              suggestions: _suggestions,
              enabled: !chat.isTyping,
              onTap: _send,
            ),
            _Composer(
              controller: _input,
              enabled: !chat.isTyping,
              onSend: () => _send(_input.text),
            ),
          ],
        ),
      ),
    );
  }

  String _hhmm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

/// Small circular designer avatar (brand mark).
class _DesignerAvatar extends StatelessWidget {
  const _DesignerAvatar({this.size = 28});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.auto_awesome,
          color: AppColors.white, size: size * 0.55),
    );
  }
}

/// One chat row: assistant rows carry an avatar on the start side; user rows
/// align to the end side. Uses directional radii so tails flip correctly in RTL.
class _MessageRow extends StatelessWidget {
  const _MessageRow({
    required this.isUser,
    required this.maxBubbleWidth,
    required this.child,
    this.time,
  });

  final bool isUser;
  final double maxBubbleWidth;
  final Widget child;
  final String? time;

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadiusDirectional.only(
          topStart: const Radius.circular(16),
          topEnd: const Radius.circular(16),
          bottomStart: Radius.circular(isUser ? 16 : 4),
          bottomEnd: Radius.circular(isUser ? 4 : 16),
        ),
        border: isUser ? null : Border.all(color: AppColors.border),
      ),
      child: child,
    );

    final column = Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        bubble,
        if (time != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(
                top: 4, start: 6, end: 6),
            child: Text(time!, style: AppTextStyles.caption),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const _DesignerAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(child: column),
        ],
      ),
    );
  }
}

/// Animated three-dot "typing" indicator shown inside an assistant bubble.
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 14,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) {
              final t = ((_c.value + i * 0.2) % 1.0);
              final opacity = 0.3 + 0.7 * (t < 0.5 ? t * 2 : (1 - t) * 2);
              return Opacity(
                opacity: opacity.clamp(0.3, 1.0),
                child: const CircleAvatar(
                    radius: 4, backgroundColor: AppColors.midGrey),
              );
            }),
          );
        },
      ),
    );
  }
}

/// Horizontal quick-reply chips above the composer.
class _SuggestionBar extends StatelessWidget {
  const _SuggestionBar({
    required this.suggestions,
    required this.enabled,
    required this.onTap,
  });

  final List<String> suggestions;
  final bool enabled;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final s = suggestions[i];
          return ActionChip(
            label: Text(s),
            onPressed: enabled ? () => onTap(s) : null,
          );
        },
      ),
    );
  }
}

/// Rounded message composer with a send button.
class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.scaffold,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                minLines: 1,
                maxLines: 4,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالتك للمصمم...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: enabled ? AppColors.primary : AppColors.midGrey,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: enabled ? onSend : null,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.send, color: AppColors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
