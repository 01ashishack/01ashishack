import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/inbox/chat_screen.dart';
import '../../features/inbox/inbox_screen.dart';
import '../../features/inbox/send_notice_screen.dart';
import '../../features/members/add_member_screen.dart';
import '../../features/members/attendance_screen.dart';
import '../../features/members/member_profile_screen.dart';
import '../../features/members/members_screen.dart';
import '../../features/members/seat_manager_screen.dart';
import '../../features/onboarding/library_setup_screen.dart';
import '../../features/onboarding/profile_setup_screen.dart';
import '../../features/onboarding/upi_setup_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/shell/main_shell.dart';

final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    final loc = state.matchedLocation;
    if (loc == '/splash') return null;
    if (user == null && !loc.startsWith('/auth')) return '/auth/login';
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/auth/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/auth/forgot-password', builder: (c, s) => const ForgotPasswordScreen()),
    GoRoute(path: '/onboarding/profile', builder: (c, s) => const ProfileSetupScreen()),
    GoRoute(path: '/onboarding/library', builder: (c, s) => const LibrarySetupScreen()),
    GoRoute(path: '/onboarding/upi', builder: (c, s) => const UpiSetupScreen()),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        GoRoute(path: '/members', builder: (c, s) => const MembersScreen()),
        GoRoute(path: '/members/seat-manager', builder: (c, s) => const SeatManagerScreen()),
        GoRoute(path: '/members/add', builder: (c, s) => const AddMemberScreen()),
        GoRoute(path: '/members/attendance', builder: (c, s) => const AttendanceScreen()),
        GoRoute(path: '/members/:memberId', builder: (c, s) => MemberProfileScreen(memberId: s.pathParameters['memberId']!)),
        GoRoute(path: '/reports', builder: (c, s) => const ReportsScreen()),
        GoRoute(path: '/inbox', builder: (c, s) => const InboxScreen()),
        GoRoute(path: '/inbox/:conversationId', builder: (c, s) => ChatScreen(conversationId: s.pathParameters['conversationId']!)),
        GoRoute(path: '/send-notice', builder: (c, s) => const SendNoticeScreen()),
        GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      ],
    ),
  ],
);
