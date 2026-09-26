# CakeList

A small iOS app that loads a list of cakes from a remote endpoint and shows them in a list. Built for the Waracle mobile coding exercise.

- SwiftUI, Swift Concurrency, `@Observable`
- MVVM with a repository layer
- No third-party dependencies
- iOS 17.6+, Xcode 26

## Running

1. Clone the repository.
2. Open `CakeList.xcodeproj` in Xcode 26 or later.
3. Select the `CakeList` scheme and an iPhone simulator, then Run (⌘R).

To run the unit tests use Test (⌘U), or from the command line:

```sh
xcodebuild test -project CakeList.xcodeproj -scheme CakeList \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Features

| Requirement | Where |
| --- | --- |
| Load and display cakes on launch | `CakeListView` → `CakeListViewModel.load()` |
| Remove duplicates, order by name | `Sequence.uniqued()`, `Sequence<Cake>.sortedByTitle()` |
| Image and title per row, divider between rows | `CakeRow` inside a plain `List` |
| Description popup on tap | `.alert` in `CakeListView` |
| Refresh | Pull-to-refresh and a toolbar button |
| Error message when loading fails | `ContentUnavailableView` with a Retry action |
| Orientation changes without reloading | State lives in the view model, not the view hierarchy |
| Animated list items | `appearTransition(index:)` — staggered fade and slide, respects Reduce Motion |

## Architecture

```
View (SwiftUI)  →  ViewModel (@Observable, main actor)  →  CakeRepository  →  APIClient  →  HTTPClient (URLSession)
```

- **Networking/** — `HTTPClient` (raw transport), `Endpoint`, `NetworkError`, `APIClient` / `DefaultAPIClient` (typed requests: builds the URL, validates the status code, decodes). Depends only on Foundation, so it can be extracted into a Swift package as-is.
- **Repositories/** — `CakeRepository` protocol and `RemoteCakeRepository`. The view model depends on the protocol, never on the network stack.
- **ViewModels/** — `CakeListViewModel` exposes a single `State` enum (`idle`, `loading`, `loaded`, `failed`). Dedupe and sorting are applied here so the presentation rule is covered by the view model tests.
- **Views/** — `CakeListView`, `CakeRow`, `AppearTransition`. Selection for the popup is plain view state.
- **App/** — composition root: `CakeListApp` wires `DefaultAPIClient` → `RemoteCakeRepository` → `CakeListViewModel`.

The project uses Xcode's default main-actor isolation. Types that must run off the main actor (networking, models, helpers) are marked `nonisolated` explicitly.

## Tests

Swift Testing, fast and isolated; no network or UI tests. Each layer is tested against a stub of the layer below (`StubHTTPClient`, `StubAPIClient`, `StubCakeRepository`).

- `CakeListViewModelTests` — load succeeds → cakes presented deduplicated and sorted; load fails → error presented; reload after failure recovers
- `DefaultAPIClientTests` — request building, decoding, non-2xx, non-HTTP response, transport and decoding error mapping
- `RemoteCakeRepositoryTests`, `CakeTests`, `SequenceUniquedTests`

## Notes and trade-offs

- The endpoint currently returns no duplicates; the dedupe rule (exact match on all fields) is still applied and unit tested.
- The endpoint serves `text/plain`, so the client does not validate the content type.
- If a refresh fails, the error view replaces the list. Keeping stale content visible is a noted TODO.
- `AsyncImage` is used deliberately to avoid dependencies; it has no disk cache or downsampling.

Remaining work is marked with `TODO:` comments in the code.

## AI disclosure

This exercise was built with AI assistance (Claude Code) used as a pair-programming tool. The scope, stack, architecture and step-by-step plan were set by the author; the assistant drafted code, tests and documentation under that direction, and every step was reviewed, built, unit tested and run on the simulator before being committed.
