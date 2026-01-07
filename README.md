# Roblox-Tower-Defense-prototype

## Overview
Gameplay systems prototype built in Roblox Studio using Luau.
This project focuses on core gameplay architecture and code quality rather than visual polish or content completeness.

## Features
- Data-driven wave system
- Server-authoritative enemy movement
- Tower placement via raycasting
- Modular tower targeting and damage logic

## Project Structure
This structure mirrors Roblox Studio services to keep client and server responsibilities clearly separated:

ServerScripts/ → ServerScriptService  
ClientScripts/ → StarterGui
StarterScripts/ → StarterPlayerScripts

## Design Goals
- Maintainability
- Clear server/client separation
- Low technical debt

## Known Limitations
- Minimal UI and animations
- No Rojo sync (code samples only)

## Engineering Notes
- Wave configurations are separated from execution logic to enable easy iteration without modifying core systems.
- Enemy movement and damage are handled server-side to prevent client authority issues.
- Tower placement previews are client-side, with final placement validated by the server.
