# discordsdk-beef
A port of the Discord Game SDK C-header to Beef with some additions to make interactions with it nicer.

## Additions
Fixed size `char8[]` buffers can also be accessed as `StringView`:
```cs
DiscordActivity activity = .();
// activity.details is of type char8[128], so using it as or setting it from
// a string is tedious. activity.Details does these conversions for you:
activity.Details = "A test string";
```

Fixed size `char8[]` buffers can be created from `StringView` to pass into functions:
```cs
// 128 is the size of the buffer to pass as seen in the function definition
lobbies.connect_lobby_with_activity_secret(
  lobbies, MakeCharBuffer!(128, secretString), null, => OnLobbyConnect);
```
