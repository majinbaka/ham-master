# ADR-0004: Local profile card preferences

Status: accepted for the customizable showcase card.

The profile feature stores cosmetics and its public friend code in one versioned
`profile.card` preferences entry via `SharedPreferencesAsync` on Android and
web. The adapter encodes JSON behind `ProfileCardStore`. App composition
injects the adapter, and the controller publishes edits after a successful write.
An unreadable record or failed read leaves the stored entry intact and offers a
retry. The first record uses version 1. There are no earlier records to migrate.

The controller generates a random code when it creates the local card. The QR
contains that exact text and is the sole visible representation of the code.
Sharing renders the card as PNG. Saved titles, bios, badges and the stats
visibility preference stay in the version 1 record for compatibility. The
card shows the count of entries in the sample roster. Code lookup, friend
requests and cross-device profile sync require a future service. Progression
persistence remains governed by
[ADR-0003](0003-offline-game-core.md).
