import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
      (ref) => Supabase.instance.client,
);

final authSessionProvider = StreamProvider<Session?>((ref) {
  return ref
      .watch(supabaseClientProvider)
      .auth
      .onAuthStateChange
      .map((authState) => authState.session);
});