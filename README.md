# Roblox Tower Defense Gameplay Prototype (Code Sample)

## Overview
This repository contains gameplay system code written in Luau for a Roblox tower defense prototype.
The focus of this project is clean architecture, modular gameplay systems, and maintainable code structure
rather than a fully published or asset-complete experience.

This repository is intended as a **code sample**, not a standalone runnable game.

## Systems Implemented
- Data-driven wave and enemy spawning system
- Server-authoritative enemy movement and lifecycle handling
- Modular tower targeting and damage logic
- Client-side tower placement via mouse raycasting with server validation and placement limit
- Base health, lose conditions, and basic gameplay UI
- Basic Economy system with updated placement conditions based on prices
- Clear separation of server and client responsibilities

## Project Structure
Scripts are organized as they would appear in Roblox Studio:
- Server-side logic → ServerScriptService
- Client-side logic → StarterGui / StarterPlayerScripts
- Shared modules → ReplicatedStorage

Only gameplay scripts are included in this repository.

## Design Goals
- Maintainable and extensible gameplay systems
- Clear separation of concerns
- Data-driven configuration over hard-coded behavior
- Server authority for core gameplay logic

## Notes
- Models, maps, animations, and UI assets are intentionally excluded.
- The prototype is currently private and under active development.
- This repository is meant to demonstrate gameplay engineering practices and system design decisions.
