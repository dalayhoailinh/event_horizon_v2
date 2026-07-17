import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String _log = 'Chưa chạy kiểm tra nào.';

  Future<void> _testFirestore() async {
    setState(() {
      _log = 'Đang ghi Firestore...';
    });
    try {
      final db = getIt<FirebaseFirestore>();
      await db.collection('debug').doc('ping').set({
        'at': FieldValue.serverTimestamp(),
        'from': kIsWeb ? 'web' : 'app',
      });
      final snap = await db.collection('debug').doc('ping').get();
      setState(() {
        _log = 'Ghi Firestore thành công: ${snap.data()}';
      });
    } catch (e) {
      setState(() {
        _log = 'Lỗi khi ghi Firestore: $e';
      });
    }
  }

  Future<void> _testPing() async {
    setState(() {
      _log = 'Đang ping server...';
    });
    try {
      final functions = getIt<FirebaseFunctions>();
      final result = await functions.httpsCallable('ping').call();
      setState(() {
        _log = 'Server trả lời: ${result.data}';
      });
    } catch (e) {
      setState(() {
        _log = 'Lỗi khi ping server: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: _testFirestore,
              child: const Text('Ghi thử Firestore'),
            ),
            AppSpacing.vSm,
            FilledButton(
              onPressed: _testPing,
              child: const Text('Ping thử server'),
            ),
            AppSpacing.vSm,
            OutlinedButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(const AuthRefreshRequested()),
              child: const Text('Làm mới vai trò (đọc lại claims)'),
            ),
            AppSpacing.vMd,
            Text(_log),
          ],
        ),
      ),
    );
  }
}
