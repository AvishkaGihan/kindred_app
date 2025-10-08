# Front-End Specification: Kindred AI

**Version:** 3.0
**Status:** In Development
**Last Updated:** October 7, 2025
**Owner:** Avishka Gihan

---

## Overview

This front-end specification defines the user interface and user experience implementation for Kindred AI, a cross-platform AI chatbot powered by Gemini 2.5 Flash via Firebase AI Logic SDK. The application is built with Flutter 3.22+ and follows Material Design 3 principles with platform-specific adaptations for Android, iOS, Web, and macOS.

**Technology Context:**

- **Framework**: Flutter 3.22+ (Dart 3.4+)
- **State Management**: Riverpod 3.1+ with AsyncValue pattern
- **AI Integration**: Gemini 2.5 Flash via Firebase AI Logic SDK
- **Backend Services**: Firebase (Auth, Firestore, Analytics, App Check)

---

## 1. Design System & Visual Foundation

### 1.1 Design Tokens & Semantic Variables

```dart
// lib/presentation/theme/design_tokens.dart
class DesignTokens {
  // Color Palette - Semantic Naming
  static const Color primary = Color(0xFF6366F1);  // Indigo
  static const Color primaryVariant = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFFEC4899); // Pink
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color error = Color(0xFFEF4444);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors - WCAG Compliant
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray900 = Color(0xFF111827);

  // Dark Theme Colors
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkGray200 = Color(0xFFE2E8F0);
  static const Color darkGray500 = Color(0xFF64748B);

  // Typography Scale - Dynamic Type Ready
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2Xl = 24.0;
  static const double fontSize3Xl = 30.0;

  // Spacing Scale - 8pt Grid System
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2Xl = 48.0;

  // Border Radius
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationBase = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Shadows - Material 3 Elevation
  static const BoxShadow shadowSm = BoxShadow(
    blurRadius: 4,
    offset: Offset(0, 1),
    color: Color(0x1A000000),
  );

  static const BoxShadow shadowMd = BoxShadow(
    blurRadius: 8,
    offset: Offset(0, 2),
    color: Color(0x1A000000),
  );

  static const BoxShadow shadowLg = BoxShadow(
    blurRadius: 16,
    offset: Offset(0, 4),
    color: Color(0x1A000000),
  );
}
```

### 1.2 Adaptive Theme System with Platform Awareness

```dart
// lib/presentation/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);

    return baseTheme.copyWith(
      colorScheme: ColorScheme.light(
        primary: DesignTokens.primary,
        primaryContainer: DesignTokens.primaryVariant,
        secondary: DesignTokens.secondary,
        surface: DesignTokens.surface,
        background: DesignTokens.background,
        error: DesignTokens.error,
        onSurface: DesignTokens.gray900,
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme),
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      // Platform-specific adaptations
      platform: Theme.of(context).platform,
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final baseTheme = ThemeData.dark(useMaterial3: true);

    return baseTheme.copyWith(
      colorScheme: ColorScheme.dark(
        primary: DesignTokens.primary,
        primaryContainer: DesignTokens.primaryVariant,
        secondary: DesignTokens.secondary,
        surface: DesignTokens.darkSurface,
        background: DesignTokens.darkBackground,
        error: DesignTokens.error,
        onSurface: DesignTokens.darkGray200,
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme),
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      platform: Theme.of(context).platform,
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: DesignTokens.fontSize2Xl,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
```

---

## 2. Component Library

### 2.1 Core Components

#### Adaptive App Bar with Platform Intelligence

```dart
// lib/presentation/widgets/adaptive_app_bar.dart
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
  });

  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return platform == TargetPlatform.iOS
        ? CupertinoNavigationBar(
            middle: Semantics(
              header: true,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: DesignTokens.fontSizeLg,
                ),
              ),
            ),
            trailing: actions.isNotEmpty
                ? Row(mainAxisSize: MainAxisSize.min, children: actions)
                : null,
            leading: leading,
            backgroundColor: Theme.of(context).colorScheme.surface,
            border: null,
          )
        : AppBar(
            title: Semantics(
              header: true,
              child: Text(title),
            ),
            actions: actions,
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            elevation: elevation,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          );
  }
}
```

#### Message Bubble with Status Indicators

```dart
// lib/presentation/screens/chat/widgets/message_bubble.dart
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.status,
    this.onRetry,
  });

  final String message;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: DesignTokens.spacingXs,
        horizontal: DesignTokens.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Semantics(
              label: 'AI assistant avatar',
              child: _buildAvatar(context),
            ),

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingMd),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: _getBorderRadius(context),
                      boxShadow: [DesignTokens.shadowSm],
                    ),
                    child: Semantics(
                      liveRegion: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isUser
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                              height: 1.4,
                            ),
                          ),
                          if (status == MessageStatus.failed)
                            _buildErrorRetry(context),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingXs),
                  _buildTimestampAndStatus(context),
                ],
              ),
            ),
          ),

          if (isUser)
            Semantics(
              label: 'User message status: ${_getStatusLabel(status)}',
              child: _buildStatusIndicator(context),
            ),
        ],
      ),
    );
  }

  String _getStatusLabel(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 'Sending';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.failed:
        return 'Failed to send';
      case MessageStatus.queued:
        return 'Queued for sending';
      case MessageStatus.retrying:
        return 'Retrying to send';
    }
  }
}
```

### 2.2 Enhanced Chat Input with Offline Support

```dart
// lib/presentation/screens/chat/widgets/chat_input.dart
class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.isOnline,
    this.queuedMessageCount = 0,
  });

  final Function(String) onSendMessage;
  final bool isOnline;
  final int queuedMessageCount;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + DesignTokens.spacingSm,
        left: DesignTokens.spacingMd,
        right: DesignTokens.spacingMd,
        top: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [DesignTokens.shadowMd],
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isOnline && widget.queuedMessageCount > 0)
              _buildOfflineIndicator(context),

            Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(DesignTokens.borderRadiusLg),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingMd,
                          vertical: DesignTokens.spacingSm,
                        ),
                        suffixIcon: _buildAttachmentButton(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: DesignTokens.spacingSm),

                _buildSendButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingXs,
      ),
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: DesignTokens.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.signal_wifi_off,
            size: DesignTokens.fontSizeSm,
            color: DesignTokens.warning,
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          Text(
            'Offline - ${widget.queuedMessageCount} message${widget.queuedMessageCount == 1 ? '' : 's'} queued',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: DesignTokens.warning,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 3. Enhanced Screen Specifications

### 3.1 Authentication Screens with Error Handling

#### Login Screen with Comprehensive States

```dart
// lib/presentation/screens/auth/login_screen.dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Welcome Back',
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingXl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and branding
                _buildHeader(context),
                const SizedBox(height: DesignTokens.spacing2Xl),

                // Email field
                Semantics(
                  label: 'Email address',
                  textField: true,
                  child: AdaptiveTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    autofillHints: const [AutofillHints.email],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),

                // Password field
                Semantics(
                  label: 'Password',
                  textField: true,
                  child: AdaptiveTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: true,
                    validator: _validatePassword,
                    autofillHints: const [AutofillHints.password],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingLg),

                // Login button
                Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authProvider);
                    return ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      child: authState.isLoading
                          ? AdaptiveLoadingIndicator()
                          : Text('Sign In'),
                    );
                  },
                ),
                const SizedBox(height: DesignTokens.spacingLg),

                // Social sign-in
                _buildSocialSignIn(context),
                const SizedBox(height: DesignTokens.spacingLg),

                // Sign up link
                _buildSignUpLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(AuthError? error) {
    if (error == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: DesignTokens.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: DesignTokens.error),
          const SizedBox(width: DesignTokens.spacingSm),
          Expanded(
            child: Text(
              error.message,
              style: TextStyle(color: DesignTokens.error),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3.2 Enhanced Chat Screen with Performance Optimizations

```dart
// lib/presentation/screens/chat/chat_screen.dart
class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  final _messageFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Kindred AI',
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status banner
          Consumer(
            builder: (context, ref, child) {
              final connectionState = ref.watch(connectionProvider);
              return AnimatedSwitcher(
                duration: DesignTokens.durationBase,
                child: connectionState.isConnected
                    ? const SizedBox.shrink()
                    : _buildConnectionBanner(context),
              );
            },
          ),

          // Messages list
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final chatState = ref.watch(chatProvider);
                final messages = chatState.messages;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return ChatMessageList(
                      messages: messages,
                      scrollController: _scrollController,
                      onLoadMore: _loadMoreMessages,
                      hasMore: chatState.hasMoreMessages,
                    );
                  },
                );
              },
            ),
          ),

          // Chat input
          Consumer(
            builder: (context, ref, child) {
              final chatState = ref.watch(chatProvider);
              final connectionState = ref.watch(connectionProvider);

              return ChatInput(
                onSendMessage: _handleSendMessage,
                isOnline: connectionState.isConnected,
                queuedMessageCount: chatState.queuedMessages.length,
              );
            },
          ),
        ],
      ),
    );
  }
}

// Optimized message list with pagination
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.onLoadMore,
    required this.hasMore,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final VoidCallback onLoadMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            hasMore) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
        reverse: true,
        itemCount: messages.length + (hasMore ? 1 : 0),
        cacheExtent: 1000,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          if (index == messages.length && hasMore) {
            return const LoadingMoreIndicator();
          }

          final message = messages[messages.length - 1 - index];
          return ChatMessageItem(
            key: ValueKey('${message.id}-${message.updatedAt}'),
            message: message,
          );
        },
      ),
    );
  }
}
```

---

## 4. Enhanced Interaction Patterns & States

### 4.1 Comprehensive Message Status System

```dart
// lib/domain/entities/message_status.dart
enum MessageStatus {
  sending,    // Initial send attempt
  queued,     // Offline - waiting for connection
  retrying,   // Previous send failed, retrying
  sent,       // Successfully sent to AI service
  delivered,  // AI response received
  failed,     // Permanent failure
}

extension MessageStatusExtension on MessageStatus {
  String get displayText {
    switch (this) {
      case MessageStatus.sending:
        return 'Sending...';
      case MessageStatus.queued:
        return 'Queued (offline)';
      case MessageStatus.retrying:
        return 'Retrying...';
      case MessageStatus.sent:
        return 'Sent';
      case MessageStatus.delivered:
        return 'Delivered';
      case MessageStatus.failed:
        return 'Failed - Tap to retry';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageStatus.sending:
      case MessageStatus.retrying:
        return Icons.access_time;
      case MessageStatus.queued:
        return Icons.schedule;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }

  Color get color {
    switch (this) {
      case MessageStatus.sending:
      case MessageStatus.retrying:
      case MessageStatus.queued:
        return DesignTokens.warning;
      case MessageStatus.sent:
        return DesignTokens.info;
      case MessageStatus.delivered:
        return DesignTokens.success;
      case MessageStatus.failed:
        return DesignTokens.error;
    }
  }
}
```

### 4.2 Enhanced Loading States with Skeleton Screens

```dart
// lib/presentation/widgets/skeleton_loading.dart
class SkeletonLoading extends StatelessWidget {
  const SkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          _buildMessageSkeleton(true),
          _buildMessageSkeleton(false),
          _buildMessageSkeleton(true),
        ],
      ),
    );
  }

  Widget _buildMessageSkeleton(bool isUser) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: DesignTokens.spacingXs,
        horizontal: DesignTokens.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          Container(
            width: 200,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? DesignTokens.borderRadiusLg : DesignTokens.borderRadiusSm),
                topRight: Radius.circular(isUser ? DesignTokens.borderRadiusSm : DesignTokens.borderRadiusLg),
                bottomLeft: const Radius.circular(DesignTokens.borderRadiusLg),
                bottomRight: const Radius.circular(DesignTokens.borderRadiusLg),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 5. Enhanced Performance Optimizations

### 5.1 Memory-Efficient Message Rendering

```dart
// lib/presentation/screens/chat/widgets/chat_message_item.dart
class ChatMessageItem extends StatefulWidget {
  const ChatMessageItem({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  State<ChatMessageItem> createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return MessageBubble(
      message: widget.message.content,
      isUser: widget.message.isUser,
      timestamp: widget.message.timestamp,
      status: widget.message.status,
      onRetry: widget.message.status == MessageStatus.failed
          ? _handleRetry
          : null,
    );
  }

  void _handleRetry() {
    context.read(chatProvider.notifier).retryMessage(widget.message.id);
  }
}
```

---

## 6. Enhanced Accessibility Specifications

### 6.1 Comprehensive Screen Reader Support

```dart
// lib/presentation/utils/accessibility_utils.dart
class AccessibilityUtils {
  static String formatMessageForScreenReader({
    required String content,
    required bool isUser,
    required DateTime timestamp,
    required MessageStatus status,
  }) {
    final userLabel = isUser ? 'You said' : 'AI assistant said';
    final statusLabel = _getStatusLabel(status);
    final timeLabel = _formatTimeForAccessibility(timestamp);

    return '$userLabel: $content. Status: $statusLabel. Time: $timeLabel';
  }

  static String _getStatusLabel(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 'sending';
      case MessageStatus.queued:
        return 'queued for sending when online';
      case MessageStatus.retrying:
        return 'retrying to send';
      case MessageStatus.sent:
        return 'sent';
      case MessageStatus.delivered:
        return 'delivered';
      case MessageStatus.failed:
        return 'failed to send';
    }
  }
}
```

---

## 7. Enhanced Error Handling & Empty States

### 7.1 Comprehensive Error Scenarios

```dart
// lib/presentation/widgets/error_states.dart
class ErrorStates {
  static Widget networkError(VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64,
              color: DesignTokens.gray500,
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            Text(
              'Connection Lost',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXl,
                fontWeight: FontWeight.w600,
                color: DesignTokens.gray700,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DesignTokens.gray500,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget aiServiceError(VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.smart_toy_outlined,
              size: 64,
              color: DesignTokens.error,
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            Text(
              'AI Service Unavailable',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXl,
                fontWeight: FontWeight.w600,
                color: DesignTokens.error,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              'We\'re experiencing high demand. Please try again in a moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DesignTokens.gray500,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            OutlinedButton(
              onPressed: onRetry,
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget emptyState({
    required String title,
    required String message,
    IconData? icon,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 64,
                color: DesignTokens.gray500,
              ),
            const SizedBox(height: DesignTokens.spacingLg),
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXl,
                fontWeight: FontWeight.w600,
                color: DesignTokens.gray700,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DesignTokens.gray500,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: DesignTokens.spacingLg),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 8. Enhanced Testing Specifications

### 8.1 Comprehensive Widget Test Coverage

```dart
// test/presentation/screens/chat/chat_screen_test.dart
void main() {
  group('ChatScreen', () {
    testWidgets('displays messages from provider', (tester) async {
      // Arrange
      final mockMessages = [
        ChatMessage.user('Hello', id: '1'),
        ChatMessage.ai('Hi there!', id: '2'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatProvider.overrideWithValue(
              FakeChatProvider(messages: mockMessages),
            ),
          ],
          child: const MaterialApp(home: ChatScreen()),
        ),
      );

      // Assert
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi there!'), findsOneWidget);
    });

    testWidgets('handles offline state correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            connectionProvider.overrideWithValue(
              FakeConnectionProvider(isConnected: false),
            ),
          ],
          child: const MaterialApp(home: ChatScreen()),
        ),
      );

      // Assert
      expect(find.text('Offline'), findsOneWidget);
    });

    testWidgets('sends message when send button is pressed', (tester) async {
      // Arrange
      final mockChatProvider = MockChatProvider();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatProvider.overrideWithValue(mockChatProvider),
          ],
          child: const MaterialApp(home: ChatScreen()),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'Test message');
      await tester.tap(find.byType(SendButton));
      await tester.pump();

      // Assert
      verify(mockChatProvider.sendMessage('Test message')).called(1);
    });

    testWidgets('handles message retry correctly', (tester) async {
      // Arrange
      final failedMessage = ChatMessage.user(
        'Failed message',
        id: '1',
        status: MessageStatus.failed,
      );
      final mockChatProvider = MockChatProvider();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatProvider.overrideWithValue(mockChatProvider),
          ],
          child: MaterialApp(
            home: MessageBubble(
              message: failedMessage.content,
              isUser: failedMessage.isUser,
              timestamp: failedMessage.timestamp,
              status: failedMessage.status,
              onRetry: () => mockChatProvider.retryMessage('1'),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Tap to retry'));
      await tester.pump();

      // Assert
      verify(mockChatProvider.retryMessage('1')).called(1);
    });

    testWidgets('loads more messages when scrolled to top', (tester) async {
      // Arrange
      final mockChatProvider = MockChatProvider();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatProvider.overrideWithValue(mockChatProvider),
          ],
          child: const MaterialApp(home: ChatScreen()),
        ),
      );

      // Act
      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pumpAndSettle();

      // Assert
      verify(mockChatProvider.loadMoreMessages()).called(1);
    });
  });

  group('MessageBubble', () {
    testWidgets('displays user message correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MessageBubble(
            message: 'Test message',
            isUser: true,
            timestamp: DateTime.now(),
            status: MessageStatus.sent,
          ),
        ),
      );

      expect(find.text('Test message'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays AI message correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MessageBubble(
            message: 'AI response',
            isUser: false,
            timestamp: DateTime.now(),
            status: MessageStatus.delivered,
          ),
        ),
      );

      expect(find.text('AI response'), findsOneWidget);
      expect(find.byWidgetPredicate(
        (widget) => widget is Semantics &&
                    widget.properties.label == 'AI assistant avatar',
      ), findsOneWidget);
    });

    testWidgets('shows retry option for failed messages', (tester) async {
      var retryTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MessageBubble(
            message: 'Failed message',
            isUser: true,
            timestamp: DateTime.now(),
            status: MessageStatus.failed,
            onRetry: () => retryTapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Tap to retry'));
      await tester.pump();

      expect(retryTapped, isTrue);
    });
  });

  group('ChatInput', () {
    testWidgets('displays offline indicator when offline', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInput(
              onSendMessage: (_) {},
              isOnline: false,
              queuedMessageCount: 3,
            ),
          ),
        ),
      );

      expect(find.text('Offline - 3 messages queued'), findsOneWidget);
      expect(find.byIcon(Icons.signal_wifi_off), findsOneWidget);
    });

    testWidgets('sends message on submit', (tester) async {
      String? sentMessage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInput(
              onSendMessage: (msg) => sentMessage = msg,
              isOnline: true,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hello AI');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();

      expect(sentMessage, equals('Hello AI'));
    });
  });
}
```

### 8.2 Accessibility Testing

```dart
// test/presentation/accessibility/accessibility_test.dart
void main() {
  group('Accessibility Tests', () {
    testWidgets('All interactive elements have semantic labels', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChatScreen()));

      final handle = tester.ensureSemantics();

      expect(tester.getSemantics(find.byType(SendButton)),
             matchesSemantics(label: 'Send message'));
      expect(tester.getSemantics(find.byType(ProfileButton)),
             matchesSemantics(label: 'Profile'));

      handle.dispose();
    });

    testWidgets('Messages have live region semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MessageBubble(
            message: 'Test',
            isUser: false,
            timestamp: DateTime.now(),
            status: MessageStatus.delivered,
          ),
        ),
      );

      final handle = tester.ensureSemantics();

      expect(tester.getSemantics(find.text('Test')),
             matchesSemantics(liveRegion: true));

      handle.dispose();
    });

    testWidgets('Color contrast meets WCAG AA standards', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ChatScreen()));

      // Test primary text on background
      final textColor = DesignTokens.gray900;
      final backgroundColor = DesignTokens.background;

      expect(_contrastRatio(textColor, backgroundColor), greaterThan(4.5));
    });
  });
}

double _contrastRatio(Color foreground, Color background) {
  final fgLuminance = foreground.computeLuminance();
  final bgLuminance = background.computeLuminance();

  final lighter = max(fgLuminance, bgLuminance);
  final darker = min(fgLuminance, bgLuminance);

  return (lighter + 0.05) / (darker + 0.05);
}
```

---

## 9. Responsive Design Specifications

### 9.1 Breakpoint System

```dart
// lib/presentation/utils/responsive_utils.dart
class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isDesktop(context)) {
      return min(screenWidth * 0.6, 900);
    } else if (isTablet(context)) {
      return screenWidth * 0.8;
    }
    return screenWidth;
  }
}
```

### 9.2 Adaptive Layout Example

```dart
// lib/presentation/widgets/adaptive_layout.dart
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    this.desktopBody,
  });

  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget? desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtils.isDesktop(context) && desktopBody != null) {
          return desktopBody!;
        } else if (ResponsiveUtils.isTablet(context) && tabletBody != null) {
          return tabletBody!;
        }
        return mobileBody;
      },
    );
  }
}
```

---

## 10. Animation Specifications

### 10.1 Standard Animations

```dart
// lib/presentation/utils/animations.dart
class AppAnimations {
  // Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration duration = DesignTokens.durationBase,
    Curve curve = Curves.easeIn,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide up animation
  static Widget slideUp({
    required Widget child,
    Duration duration = DesignTokens.durationBase,
    double offset = 20.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: offset, end: 0.0),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: child,
    );
  }

  // Message bubble entrance
  static Widget messageBubbleEntrance({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: DesignTokens.durationFast,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
```

---

## 11. Platform-Specific Considerations

### 11.1 iOS-Specific Adjustments

```dart
// lib/presentation/utils/platform_utils.dart
class PlatformUtils {
  static EdgeInsets getSystemPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return EdgeInsets.only(
        top: mediaQuery.padding.top,
        bottom: max(mediaQuery.padding.bottom, 20),
      );
    }

    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
    );
  }

  static Widget platformButton({
    required VoidCallback onPressed,
    required Widget child,
    required BuildContext context,
  }) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoButton(
        onPressed: onPressed,
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
```

---

## 12. Documentation Requirements

### 12.1 Component Documentation Template

````dart
/// A custom message bubble widget that displays chat messages.
///
/// This widget handles both user and AI messages with appropriate styling,
/// status indicators, and accessibility features.
///
/// Example:
/// ```dart
/// MessageBubble(
///   message: 'Hello, world!',
///   isUser: true,
///   timestamp: DateTime.now(),
///   status: MessageStatus.sent,
/// )
/// ```
///
/// See also:
///  * [ChatScreen], which uses this widget to display conversations
///  * [MessageStatus], which defines the available message states
class MessageBubble extends StatelessWidget {
  // Implementation...
}
````

---

## Document References

_This Front-End Specification addresses all alignment gaps with the PRD and Architecture documents, providing comprehensive coverage of performance targets, offline behavior, error handling, and accessibility requirements while maintaining platform-specific optimizations and production-ready component implementations._
