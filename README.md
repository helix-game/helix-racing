# Race World Documentation

Welcome to Race World, a non-conventional competitive racing game template designed to pit players against each other in various novel ways. This documentation will guide you through the features, functions, and how to customize your own game modes using the HELIX API.

## Introduction

Race World features stunt races where you can compete against friends or other players. With a dynamic placement system, players vie for the top positions or strive to be the last standing winner, potentially earning prizes depending on the game mode.

We've opened up this code to empower users to create their own game modes and deepen their understanding of the HELIX API.

## Features

Race World comes with three unique and fast-paced game modes:

- **Track Race**: A traditional race with 3 laps, various checkpoints, and only one winner.
- **Face2Face**: A head-to-head race where players start from different points and race towards each other's starting positions.
- **Sumo**: Players drive vehicles with the goal of pushing opponents out of a designated area.

## Functions & Methods

### Getting Information

- `Racing_World:GetPlayers()`: Returns all players (spectators & racers).
- `Racing_World:GetRacers()`: Returns all racers.
- `Racing_World:GetPlayerFromLobby(player)`: Gets the player's lobby index.
- `Racing_World:GetRaceFromPlayer(player)`: Retrieves race metadata for the specified player.

### Utilities

- `Racing_World:AddRacer(...)`: Adds a player as a racer.
- `Racing_World:BroadcastRacers(event_name, ...)`: Sends remote events to racers.
- `Racing_World:FreezeRacers(freeze_type)`: Freezes racers to prevent movement.
- `Racing_World:RemoveRacer(player, has_particle)`: Removes a racer, with optional explosion.
- `Racing_World:EliminatePlayer(player, explode_vehicle)`: Deletes a racer, optionally adding an explosion.
- `Racing_World:RespawnPlayer(player)`: Respawns a racer at their last checkpoint.

### Lobby

- `Racing_World:PlayerReady(player)`: Toggles player ready status in the lobby.
- `Racing_World:AddPlayer(player)`: Adds a player to the lobby.
- `Racing_World:RemovePlayer(player)`: Removes a player from the lobby.

### Miscellaneous

- `Racing_World:Rewards()`: Customizable method for assigning rewards.
- `Racing_World.GetRaceFromID(gameID)`: Retrieves race data by ID.
- `Racing_World.GetLobbyLength(tab)`: Gets the length of a race's lobby.
- `Racing_World.GetGamemodeFromMap()`: Determines the game mode from the map.

## Insert Objects & Obstacles

Race World allows the insertion of dynamic objects and obstacles like Nitro Boosts, Gravity Walls, Windmills, Hammers, and Spikes, enhancing the gameplay and challenge.

## Installation

1. Clone or download the Race World template from this repository into your Server/Packages folder.
2. Extract the template into your server Packages folder and rename it to `racing-world`.
3. Make sure to add this package as a game-mode to start on your server Config.toml file.
4. Start your server with racing-world as a game-mode on your Config.toml file.
![image](https://github.com/helix-game/helix-racing/assets/67294331/e3c7079f-f59d-4139-8ee7-63cfdc8c2154)

## Usage

Leverage the documented functions and methods to customize game modes, integrate new obstacles, or enhance player interactions within your racing world.

## License


This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

```markdown
MIT License

Copyright (c) [Year] [Your Name or Organization]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
