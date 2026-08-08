# flutter_study

## Supabase setup

The app initializes `supabase_flutter` before rendering. Provide the project URL
and the **anon/publishable** key from the Supabase dashboard at run time; never
use the service-role key in a client app.

```powershell
flutter run --dart-define=SUPABASE_URL=https://your-project-ref.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-or-publishable-key
```

`.env.example` documents the expected values, but `.env` files are ignored and
are not loaded automatically. Configure your IDE launch settings with the same
two `--dart-define` values.

`ProviderScope` is installed at the app root. `authSessionProvider` listens to
Supabase authentication changes, so a `ConsumerWidget` can use
`ref.watch(authSessionProvider)` to react to sign-in and sign-out events.
