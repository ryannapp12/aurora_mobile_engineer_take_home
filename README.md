# Aurora Senior Mobile Engineer (Flutter) Take-Home

Tiny mobile app that fetches a random image and displays it centered as a square, with a background that adapts to the image’s colors. Built with Flutter, BLoC/Cubit, repository pattern, and production-ready polish.

## Demo

- Video walkthrough: [Demo iOS video](docs/demo_ios.mp4)
- Video walkthrough: [Demo Android video](docs/demo_android.mp4)

## Repository details

- Repo URL: <https://github.com/ryannapp12/aurora_mobile_engineer_take_home>
- Default branch: `main`
- CI: GitHub Actions workflow runs analyze + unit/widget tests and a smoke build (`.github/workflows/flutter.yml`)
- Flutter: 3.32+ (stable)
- Platforms tested: iOS Simulator, Android Emulator

## Requirements Implemented

- Single-screen UI
- Square image centered; button “Another” to fetch a new image
- Background color adapts to the image (dominant color)
- Smooth transitions (image fade-in, animated background color)
- Loading state and graceful error handling
- Caching and placeholder for large remote images (Unsplash)
- Light/Dark mode support
- Basic accessibility (Semantics on image and button)

## Architecture

- State management: `flutter_bloc` (Cubit)
- Layers:
  - `features/random_image/domain`: entity + abstract repository
  - `features/random_image/data`: DTO/model + repository implementation (Dio)
  - `features/random_image/presentation`: Cubit + page + widgets
  - `app/`: app root and theming
- Image caching: `cached_network_image`
- Color extraction: `palette_generator`

Directory layout:

```
lib/
  bootstrap.dart
  app/
    app.dart
    widgets/
      animated_gradient_background.dart
    theme/
      app_theme.dart
      widgets/
        theme_mode_switch.dart
    di/
      service_locator.dart
    observer/
      app_bloc_observer.dart
  features/
    random_image/
      data/
        models/random_image_response.dart
        repositories/random_image_repository_impl.dart
      domain/
        entities/random_image.dart
        repositories/random_image_repository.dart
      presentation/
        cubit/
          random_image_cubit.dart
          random_image_state.dart
        view/
          random_image_page.dart
          random_image_view.dart
        widgets/
          another_button_widget.dart
          glass_action_bar_widget.dart
          image_square_widget.dart
          loading_square_widget.dart
          error_square_widget.dart
  core/
    shared/
      constants/
        app_colors.dart
        app_strings.dart
        app_sizes.dart
    utils/
      animation_utils.dart
      unsplash_url.dart
  main.dart
```

Folders at a glance
- app/: application shell
  - app.dart: root MaterialApp + providers
  - widgets/: shared app-level widgets (animated gradient background)
  - theme/: theme setup; widgets/theme_mode_switch.dart toggles light/dark
  - di/: service locator wiring for repositories/services
  - observer/: BlocObserver for structured logging
- core/: cross-cutting helpers
  - shared/constants/: design tokens (colors/strings/sizes)
  - utils/: small utilities (animations, Unsplash URL optimization)
- features/random_image/: the single-screen feature
  - data/: Dio repository + DTO
  - domain/: entity + abstract repository
  - presentation/: Cubit + page/view + split widgets (image, button, loading, error, glass bar)

## API

- GET `/image`  
  Docs: `https://november7-730026606190.europe-west1.run.app/docs#/default/get_random_image_image__get`

Example response:
```json
{ "url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb" }
```

## Tech & Packages

- flutter_bloc, hydrated_bloc, equatable
- dio, http
- cached_network_image, flutter_cache_manager
- palette_generator
- get_it, shared_preferences

## Running Locally

1. Install Flutter (3.32+ recommended).
2. Fetch dependencies:
   ```
   flutter pub get
   ```
3. Run:
   ```
   flutter run
   ```
4. Run unit/widget tests (excluding goldens):
   ```
   flutter test --tags 'not golden'
   ```
5. Generate/update goldens locally (optional):
   ```
   flutter test --update-goldens --tags golden
   ```
   Commit the generated files under `test/goldens/`.

## VS Code (optional)

You can use the provided workspace config to run with helpful Dart defines and formatting on save.

- .vscode/launch.json

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Aurora Mobile Engineer Take Home (development,)",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "args": [
                "--dart-define",
                "ENV=development",
                "--dart-define",
                "UTILS=on"
            ]
        },
        {
            "name": "Aurora Mobile Engineer Take Home (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile",
            "args": [
                "--dart-define",
                "ENV=production",
                "--dart-define",
                "UTILS=on"
            ]
        },
        {
            "name": "Aurora Mobile Engineer Take Home (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release",
            "args": [
                "--dart-define",
                "ENV=production",
                "--dart-define",
                "UTILS=on"
            ]
        }
    ]
}
```

- .vscode/settings.json

```json
{
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll": "explicit"
    },
    "java.configuration.updateBuildConfiguration": "automatic"
}
```

## Submission checklist

- [ ] Public GitHub repository URL shared (see “Repository details”)
- [ ] Demo video uploaded (see “Demo”)
- [ ] Instructions to run and test (see “Running Locally”)
- [ ] CI included (see `.github/workflows/flutter.yml`)
- [ ] Brief architecture overview (see “Architecture”)

## Notes

- CORS is enabled server-side; mobile apps aren’t constrained by browser CORS.
- Palette is computed off the image provider and animated onto the background.
- The first image loads on startup; tapping “Another” fetches a new one.
- Image URLs use direct Unsplash with smart runtime fallback if a variant fails.

## License

MIT
