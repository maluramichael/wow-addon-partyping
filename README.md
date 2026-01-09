# PartyPing

A lightweight World of Warcraft addon that plays configurable sounds for party events. Never miss a party chat message, group join, or disband again.

## Features

### Sound Notifications
Play custom sounds when:
- **Party Chat**: Someone sends a message in party chat (excludes your own messages)
- **Player Joined**: A new player joins your group
- **Player Left**: A player leaves your group
- **Group Disbanded**: Your group is disbanded

### Customization
- Choose from built-in WoW sounds or any LibSharedMedia sound
- Configure sounds individually for each event type
- Select which audio channel to use (Master, SFX, Ambience, Music)
- Enable/disable individual events
- Master toggle to quickly enable/disable all sounds
- Test button to preview all configured sounds

### Built-in Sounds
- PP: Bell (Alliance bell toll)
- PP: Chime (Quest complete)
- PP: Raid Warning
- PP: Ready Check
- PP: Level Up
- PP: Auction Open/Close
- PP: PvP Enter Queue
- PP: Tell Message

### LibSharedMedia Support
Full integration with LibSharedMedia-3.0 - use any sound from your other addons!

## Installation

1. Download the latest release
2. Extract to `World of Warcraft\_classic_era_\Interface\AddOns\`
3. Restart WoW or `/reload`

## Usage

The addon starts enabled by default. Configure it using:
- `/pp` or `/partyping` - Show help
- `/pp config` - Open configuration panel
- `/pp toggle` - Toggle all sounds on/off
- `/pp test` - Play all enabled sounds

### Macro Support
```
/run PartyPing:Toggle()
```

## Slash Commands

| Command | Description |
|---------|-------------|
| `/pp help` | Show help |
| `/pp toggle` | Toggle sounds on/off |
| `/pp enable` or `/pp on` | Enable sounds |
| `/pp disable` or `/pp off` | Disable sounds |
| `/pp config` | Open configuration panel |
| `/pp test` | Play all configured sounds |
| `/pp debug` | Toggle debug output |

## Requirements

- World of Warcraft Classic Era (Interface 11508)
- Ace3 libraries (embedded)
- LibSharedMedia-3.0 (embedded)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
