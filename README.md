# Roblox-First-Person-Accessory-Scripts
My Roblox First Person View Accessory Scripts
# Roblox First-Person Body Awareness (FPBA) Implementations

Modular Luau client scripts designed to display the player's body and equipped gear while locked in first-person camera mode (`Enum.CameraMode.LockFirstPerson`). This repository includes two distinct solutions for overcoming Roblox's default behavior of hiding character limbs in first-person view.

---

## Technical Overview & Comparison

| Feature | Method 1: Direct LTM Manipulation | Method 2: Proxy Body Instance |
| --- | --- | --- |
| **Core Architecture** | Overrides default `LocalTransparencyModifier` on existing character parts | Spawns a secondary proxy model (`[PlayerName]FPA`) in `workspace` |
| **Resource Overhead** | Extremely low (no extra part instantiation) | Moderate (clones limbs, clothing, and valid accessories) |
| **Camera Dynamics** | Smoothly interpolates `Humanoid.CameraOffset.Z` forward by `-1` stud | Syncs relative limb CFrame to `HumanoidRootPart` on `RenderStepped` |
| **Tool Handling** | Retains visibility while preserving tool animations | Hides proxy arms dynamically when a `Tool` child is detected |
| **Shadow Casting** | Relies on default character shadow behavior | Toggles explicit `CastShadow` on proxy limbs based on camera state |

---

## Script Breakdown

### Method 1: Direct LTM & Camera Offset (`FirstPersonLTM.client.luau`)

Modifies the default rendering pipeline by resetting `LocalTransparencyModifier` back to `0` on every `RenderStepped` frame for non-head limbs and non-head accessories.

* **Proximity-Based Filtering:** Listens for added models and uses spatial distance calculations (`math.min`) between the model's `Middle` part and character joints to ignore head-attached items while rendering torso/limb gear.
* **Camera Adjustment:** Smoothly transitions `Humanoid.CameraOffset.Z` toward `-1` to eliminate internal head clipping without breaking character immersion.
* **Dynamic Mode Detection:** Binds to `Head.LocalTransparencyModifier` property changes to automatically toggle first-person rendering states.

### Method 2: Proxy Body Model (`FirstPersonProxy.client.luau`)

Creates a dedicated, collision-free visual rig in `workspace` that mimics player movement while avoiding standard camera occlusion issues.

* **Proxy Rig Construction:** Dynamically builds non-collidable (`CanCollide = false`, `CanTouch = false`), anchored limb parts synced with the main character's clothing (`Shirt`, `Pants`) and limb colors.
* **Accessory Cloning & Filtering:** Filters models and accessories by volume (`X * Y * Z < 48`) and proximity to non-head body parts before cloning and welding them to the proxy body.
* **Render Stepping & CFrame Syncing:** Re-calculates proxy limb CFrames relative to the character's `HumanoidRootPart` inside `RenderStepped`, updating accessory welds periodically via a throttled task loop.

---

## Installation & Setup

1. Choose **one** of the two scripts based on your project's performance and visual requirements.
2. Place the selected script into **`StarterPlayer` > `StarterPlayerScripts**` (or **`StarterCharacterScripts`**).
3. Ensure your game setting or player camera mode allows first-person locking (`Player.CameraMode = Enum.CameraMode.LockFirstPerson`).

> **Note:** Both scripts rely on standard R6 body part naming (`Torso`, `Left Arm`, `Right Arm`, `Left Leg`, `Right Leg`). For R15 character support, update the limb reference strings to match R15 bone names (e.g., `UpperTorso`, `LowerTorso`, `LeftUpperArm`).
