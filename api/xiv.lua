---@meta
-- Generated from XivMcp tools/list. Definitions only; runtime uses the bridge.
---@class Xiv_add_plugin_repository_args
---@field ["url"] string Explicit HTTPS pluginmaster URL.

---@class Xiv_add_plugin_repository_result
---@field ["added"] boolean 
---@field ["alreadyConfigured"] boolean 
---@field ["existingEnabled"] boolean|nil 
---@field ["settingsOpened"] boolean 
---@field ["copiedToClipboard"] boolean 
---@field ["url"] string|nil 
---@field ["nextStep"] string|nil 

---@class Xiv_append_wayfinder_stops_args
---@field ["stopsJson"] string Versioned JSON batch of world-coordinate stops.

---@class Xiv_append_wayfinder_stops_result
---@field ["accepted"] boolean 

---@class Xiv_apply_terminal_layout_args
---@field ["name"] string Layout name from get_terminal_layouts.

---@class Xiv_apply_terminal_layout_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_ask_almanac_args
---@field ["question"] string The question, shown verbatim to the player (up to 4000 bytes).
---@field ["newThread"] boolean|nil Start a new conversation instead of continuing the current one (needs the JSON gate).

---@class Xiv_ask_almanac_result
---@field ["accepted"] boolean 
---@field ["via"] string|nil 
---@field ["threadId"] string|nil 
---@field ["turn"] integer|nil 
---@field ["reason"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_ask_npc_assistant_args
---@field ["text"] string The /ask argument, shown verbatim to the player.

---@class Xiv_ask_npc_assistant_result
---@field ["gate"] string|nil 
---@field ["ok"] boolean 
---@field ["message"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_bookmark_hud_quest_args
---@field ["questId"] integer Accepted Quest sheet row ID.
---@field ["bookmarked"] boolean Explicit desired bookmark state.

---@class Xiv_bookmark_hud_quest_result
---@field ["result"] any Any JSON value.

---@class Xiv_cancel_ticket_args
---@field ["id"] string Ticket id from request_action.

---@class Xiv_cancel_ticket_result
---@field ["id"] string|nil 
---@field ["state"] string|nil 
---@field ["tool"] string|nil 
---@field ["tier"] string|nil 
---@field ["reason"] string|nil 
---@field ["resumeToken"] string|nil 
---@field ["client"] string|nil 
---@field ["createdAt"] string 
---@field ["expiresAt"] string|nil 
---@field ["decidedBy"] string|nil 
---@field ["decidedAt"] string|nil 
---@field ["completedAt"] string|nil 
---@field ["queuePosition"] integer|nil 
---@field ["arguments"] any|nil Any JSON value.
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["uri"] string|nil 

---@class Xiv_capture_terminal_clip_args
---@field ["seconds"] integer|nil Length in seconds (1-30).
---@field ["format"] "gif"|"mp4"|nil File format.
---@field ["panel"] boolean|nil Record only the focused panel.
---@field ["clean"] boolean|nil Hide the game's own UI while recording.

---@class Xiv_capture_terminal_clip_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_capture_terminal_screenshot_args
---@field ["target"] "full"|"panel"|nil What to capture.
---@field ["clean"] boolean|nil Hide the game's own UI for the capture.

---@class Xiv_capture_terminal_screenshot_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_clear_macro_args
---@field ["set"] "individual"|"shared" Which macro page: individual or shared.
---@field ["index"] integer Slot number 0-99 as shown in list_macros.

---@class Xiv_clear_macro_result_previous
---@field ["title"] string|nil 
---@field ["iconId"] integer 
---@field ["lines"] (string)[]|nil 
---@field ["restorable"] boolean 

---@class Xiv_clear_macro_result
---@field ["set"] string|nil 
---@field ["index"] integer 
---@field ["wasEmpty"] boolean 
---@field ["previous"] Xiv_clear_macro_result_previous|nil 

---@class Xiv_clear_objectives_args
---@field ["id"] string|nil Objective id; omit for all.
---@field ["completedOnly"] boolean|nil Only remove completed objectives.

---@class Xiv_clear_objectives_result
---@field ["removed"] integer 
---@field ["remaining"] integer 

---@class Xiv_clear_status_args
---@field ["agent"] string|nil Agent name to remove; omit to clear the whole board.

---@class Xiv_clear_status_result
---@field ["removed"] integer 
---@field ["remaining"] integer 

---@class Xiv_clear_target_result
---@field ["hadTarget"] boolean 
---@field ["previousName"] string|nil 

---@class Xiv_close_terminal_panel_args
---@field ["id"] integer Panel id from list_terminal_panels.

---@class Xiv_close_terminal_panel_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_compare_items_args
---@field ["itemIds"] (integer)[] Item ids to compare (2-6). Use search_items or get_item to find them.
---@field ["hq"] boolean|nil Use the high-quality stat values where the item has them.

---@class Xiv_compare_items_result_items_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["itemLevel"] integer 
---@field ["equipLevel"] integer 
---@field ["category"] string|nil 
---@field ["jobs"] string|nil 
---@field ["materiaSlots"] integer 
---@field ["canBeHq"] boolean 
---@field ["physicalDamage"] integer|nil 
---@field ["magicDamage"] integer|nil 
---@field ["physicalDefense"] integer|nil 
---@field ["magicDefense"] integer|nil 
---@field ["stats"] table<string, any>|nil 

---@class Xiv_compare_items_result_differences_item
---@field ["stat"] string|nil 
---@field ["values"] table<string, any>|nil 
---@field ["spread"] integer 
---@field ["best"] string|nil 

---@class Xiv_compare_items_result
---@field ["items"] (Xiv_compare_items_result_items_item)[]|nil 
---@field ["differences"] (Xiv_compare_items_result_differences_item)[]|nil 
---@field ["sameStats"] (string)[]|nil 
---@field ["slotWarning"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_configure_hud_tracker_args
---@field ["enabled"] boolean Whether to display the tracker when current quest data is available.
---@field ["locked"] boolean|nil True passes game clicks through; false permits dragging and opening quest pages.
---@field ["filter"] "tracked"|"bookmarks"|nil Source of accepted quests; never edits native tracking.
---@field ["limit"] integer|nil Maximum quest entries.

---@class Xiv_configure_hud_tracker_result
---@field ["result"] any Any JSON value.

---@class Xiv_control_hud_window_args
---@field ["module"] "hud"|"journal"|"character"|"vitals" HUD module.
---@field ["action"] "open"|"close"|"settings"|"original"|"mode" Explicit operation.
---@field ["mode"] "screen"|"native_frame"|"world"|nil Required only for action=mode.
---@field ["placement"] "Hud"|"Companion"|"World"|"Ground"|nil Optional only for world mode.

---@class Xiv_control_hud_window_result
---@field ["result"] any Any JSON value.

---@class Xiv_control_wayfinder_journey_args
---@field ["action"] "resume"|"pause"|"next"|"previous" Explicit itinerary action.

---@class Xiv_control_wayfinder_journey_result
---@field ["accepted"] boolean 

---@class Xiv_convert_coordinates_args
---@field ["x"] number|nil Map X as the game displays it. Use with y.
---@field ["y"] number|nil Map Y as the game displays it. Use with x.
---@field ["worldX"] number|nil World X position. Use with worldZ instead of x/y.
---@field ["worldZ"] number|nil World Z position (the horizontal axis that maps to map Y). Use with worldX.
---@field ["territoryId"] integer|nil TerritoryType row id; default is the player's current zone.
---@field ["mapId"] integer|nil Map row id; takes precedence over territoryId.

---@class Xiv_convert_coordinates_result
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["mapId"] integer 
---@field ["mapName"] string|nil 
---@field ["mapX"] number 
---@field ["mapY"] number 
---@field ["worldX"] number 
---@field ["worldZ"] number 
---@field ["sizeFactor"] integer 
---@field ["flagText"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_desktop_command_args
---@field ["method"] "launch"|"window"|"workspace" What to do.
---@field ["argument"] string Argument for the method: an app id or search text, a window-action JSON object, or a workspace number.

---@class Xiv_desktop_command_result
---@field ["bridge"] string|nil 
---@field ["method"] string|nil 
---@field ["ok"] boolean 
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["raw"] string|nil 

---@class Xiv_desktop_query_args
---@field ["method"] "status"|"windows"|"apps"|"palette"|nil What to read.
---@field ["query"] string|nil Search text, only used by palette.

---@class Xiv_desktop_query_result
---@field ["bridge"] string|nil 
---@field ["method"] string|nil 
---@field ["ok"] boolean 
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["raw"] string|nil 

---@class Xiv_desktop_window_action_args
---@field ["action"] "focus"|"close"|"pet"|"pin"|"toggle"|"place"|"move" What to do.
---@field ["id"] integer|nil Window id from list_desktop_windows; 0 = the focused (else last focused) window.
---@field ["pin"] string|nil Placement for action place, e.g. "orbit 3.5".
---@field ["workspace"] integer|nil Workspace for action move (1-9).

---@class Xiv_desktop_window_action_result
---@field ["gate"] string|nil 
---@field ["ok"] boolean 
---@field ["message"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_equip_gearset_args
---@field ["id"] integer|nil Gear set number (1-100) as shown in list_gearsets.
---@field ["name"] string|nil Gear set name.

---@class Xiv_equip_gearset_result_gearset
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["classJobId"] integer 
---@field ["classJob"] string|nil 
---@field ["classJobName"] string|nil 
---@field ["itemLevel"] integer 
---@field ["glamourPlate"] integer|nil 
---@field ["mainHandMissing"] boolean|nil 
---@field ["isCurrent"] boolean 

---@class Xiv_equip_gearset_result
---@field ["gearset"] Xiv_equip_gearset_result_gearset|nil 
---@field ["resultCode"] integer 
---@field ["note"] string|nil 

---@class Xiv_execute_command_args
---@field ["command"] string The full command line, starting with '/'.

---@class Xiv_execute_command_result
---@field ["command"] string|nil 
---@field ["handledBy"] string|nil 
---@field ["usedChatTier"] boolean|nil 
---@field ["note"] string|nil 

---@class Xiv_find_nearest_aetheryte_args
---@field ["x"] number|nil Map X of the point. Use with y.
---@field ["y"] number|nil Map Y of the point. Use with x.
---@field ["worldX"] number|nil World X of the point. Use with worldZ.
---@field ["worldZ"] number|nil World Z of the point. Use with worldX.
---@field ["territoryId"] integer|nil TerritoryType row id; default is the player's current zone.
---@field ["limit"] integer|nil Maximum entries (1-50).
---@field ["excludeAethernet"] boolean|nil Leave out city aethernet shards.

---@class Xiv_find_nearest_aetheryte_result_aetherytes_item
---@field ["aetheryteId"] integer 
---@field ["name"] string|nil 
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["mapX"] number|nil 
---@field ["mapY"] number|nil 
---@field ["distanceOnMap"] number|nil 
---@field ["isAethernetShard"] boolean 

---@class Xiv_find_nearest_aetheryte_result
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["fromMapX"] number 
---@field ["fromMapY"] number 
---@field ["total"] integer 
---@field ["aetherytes"] (Xiv_find_nearest_aetheryte_result_aetherytes_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_find_owned_items_args
---@field ["query"] string|nil Item name text to search for (any case). Provide this and/or itemIds.
---@field ["itemIds"] (integer)[]|nil Exact item ids to look for.
---@field ["limit"] integer|nil Maximum distinct items returned (1-500).

---@class Xiv_find_owned_items_result_items_item_locations_item
---@field ["group"] string|nil 
---@field ["container"] string|nil 
---@field ["quantity"] integer 
---@field ["slots"] integer 
---@field ["hqQuantity"] integer|nil 

---@class Xiv_find_owned_items_result_items_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["total"] integer 
---@field ["hq"] integer|nil 
---@field ["locations"] (Xiv_find_owned_items_result_items_item_locations_item)[]|nil 

---@class Xiv_find_owned_items_result
---@field ["total"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["items"] (Xiv_find_owned_items_result_items_item)[]|nil 
---@field ["notSearched"] (string)[]|nil 
---@field ["retainer"] string|nil 

---@class Xiv_find_weather_windows_args
---@field ["zone"] string Zone: TerritoryType id or zone name (any case), e.g. "Eastern La Noscea".
---@field ["weather"] string Wanted weather: name in the client language (any case) or Weather row id.
---@field ["previousWeather"] string|nil Weather the previous 8-bell window must have had (name or id). Omit for no requirement.
---@field ["eorzeaHourStart"] integer|nil First Eorzea hour that counts (0-23). Give together with eorzeaHourEnd.
---@field ["eorzeaHourEnd"] integer|nil Eorzea hour at which it stops counting (0-24, exclusive). A value below eorzeaHourStart wraps past midnight.
---@field ["count"] integer|nil How many windows to return (1-50).
---@field ["horizonDays"] integer|nil How many real days ahead to search (1-60).
---@field ["afterUtc"] string|nil Search from this instant instead of now: ISO 8601 UTC, e.g. 2026-01-31T18:00:00Z.

---@class Xiv_find_weather_windows_result_wanted_item
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_find_weather_windows_result_previousWanted_item
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_find_weather_windows_result_possibleWeather_item
---@field ["weatherId"] integer 
---@field ["name"] string|nil 
---@field ["chancePercent"] integer 

---@class Xiv_find_weather_windows_result_windows_item_weather
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_find_weather_windows_result_windows_item_previousWeather
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_find_weather_windows_result_windows_item
---@field ["startUtc"] string 
---@field ["endUtc"] string 
---@field ["eorzeaStart"] string|nil 
---@field ["eorzeaEnd"] string|nil 
---@field ["durationSeconds"] integer 
---@field ["secondsUntilStart"] integer 
---@field ["activeNow"] boolean 
---@field ["weather"] Xiv_find_weather_windows_result_windows_item_weather|nil 
---@field ["previousWeather"] Xiv_find_weather_windows_result_windows_item_previousWeather|nil 
---@field ["windows"] integer 

---@class Xiv_find_weather_windows_result
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["wanted"] (Xiv_find_weather_windows_result_wanted_item)[]|nil 
---@field ["previousWanted"] (Xiv_find_weather_windows_result_previousWanted_item)[]|nil 
---@field ["eorzeaHours"] string|nil 
---@field ["afterUtc"] string 
---@field ["horizonDays"] integer 
---@field ["chancePercent"] integer 
---@field ["possibleWeather"] (Xiv_find_weather_windows_result_possibleWeather_item)[]|nil 
---@field ["windows"] (Xiv_find_weather_windows_result_windows_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_focus_terminal_panel_args
---@field ["id"] integer Panel id from list_terminal_panels.

---@class Xiv_focus_terminal_panel_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_get_achievements_args
---@field ["completed"] "all"|"completed"|"missing"|nil Filter by completion.
---@field ["nameContains"] string|nil Case-insensitive substring matched against the achievement name or description.
---@field ["category"] string|nil Case-insensitive substring matched against the achievement category.
---@field ["limit"] integer|nil Maximum entries (1-200).
---@field ["offset"] integer|nil Entries to skip for paging.

---@class Xiv_get_achievements_result_achievements_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["description"] string|nil 
---@field ["category"] string|nil 
---@field ["points"] integer 
---@field ["completed"] boolean 

---@class Xiv_get_achievements_result
---@field ["loaded"] boolean 
---@field ["totalInGame"] integer 
---@field ["completed"] integer 
---@field ["pointsEarned"] integer 
---@field ["pointsAvailable"] integer 
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["achievements"] (Xiv_get_achievements_result_achievements_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_action_args
---@field ["actionId"] integer Action id (row id in the Action sheet).

---@class Xiv_get_action_result_classJob
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_action_result_comboFrom
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_action_result
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["description"] string|nil 
---@field ["icon"] integer 
---@field ["classJob"] Xiv_get_action_result_classJob|nil 
---@field ["classJobAbbreviation"] string|nil 
---@field ["usableBy"] string|nil 
---@field ["level"] integer 
---@field ["category"] string|nil 
---@field ["castSeconds"] number 
---@field ["recastSeconds"] number 
---@field ["range"] integer 
---@field ["radius"] integer 
---@field ["castType"] integer 
---@field ["primaryCostType"] integer 
---@field ["primaryCostValue"] integer 
---@field ["cooldownGroup"] integer 
---@field ["additionalCooldownGroup"] integer 
---@field ["maxCharges"] integer 
---@field ["isRoleAction"] boolean 
---@field ["isPvp"] boolean 
---@field ["isPlayerAction"] boolean 
---@field ["comboFrom"] Xiv_get_action_result_comboFrom|nil 
---@field ["canTargetSelf"] boolean 
---@field ["canTargetParty"] boolean 
---@field ["canTargetHostile"] boolean 
---@field ["targetsArea"] boolean 

---@class Xiv_get_addon_text_args
---@field ["addonName"] string Internal addon name from list_addons, e.g. "JournalDetail" or "ItemDetail".
---@field ["includeHidden"] boolean|nil Also return text from hidden nodes.
---@field ["limit"] integer|nil Maximum text entries to return.
---@field ["index"] integer|nil 1-based instance when several addons share the name (rare).

---@class Xiv_get_addon_text_result_texts_item
---@field ["nodeId"] integer 
---@field ["path"] string|nil 
---@field ["text"] string|nil 
---@field ["visible"] boolean 
---@field ["x"] integer 
---@field ["y"] integer 

---@class Xiv_get_addon_text_result
---@field ["addon"] string|nil 
---@field ["id"] integer 
---@field ["visible"] boolean 
---@field ["ready"] boolean 
---@field ["texts"] (Xiv_get_addon_text_result_texts_item)[]|nil 
---@field ["total"] integer 
---@field ["truncated"] boolean 

---@class Xiv_get_almanac_benchmark_args
---@field ["runId"] string|nil Run id, or "last".

---@class Xiv_get_almanac_benchmark_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_almanac_model_status_result
---@field ["model"] any|nil Any JSON value.
---@field ["backends"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_get_almanac_status_result_bridge
---@field ["key"] string|nil 
---@field ["name"] string|nil 
---@field ["purpose"] string|nil 
---@field ["installed"] boolean 
---@field ["loaded"] boolean 
---@field ["version"] string|nil 
---@field ["ipcAvailable"] boolean 
---@field ["apiVersion"] string|nil 
---@field ["unavailable"] string|nil 
---@field ["verified"] boolean 

---@class Xiv_get_almanac_status_result
---@field ["bridge"] Xiv_get_almanac_status_result_bridge|nil 
---@field ["askGate"] boolean 
---@field ["callGate"] boolean 
---@field ["api"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_get_almanac_thread_args
---@field ["id"] string Thread id from list_almanac_threads.
---@field ["limit"] integer|nil Maximum turns (1-100).

---@class Xiv_get_almanac_thread_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_almanac_turn_args
---@field ["threadId"] string Thread id from ask_almanac.
---@field ["turn"] integer Turn number from ask_almanac.

---@class Xiv_get_almanac_turn_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_attributes_args
---@field ["includeZero"] boolean|nil Include attributes whose value is 0.

---@class Xiv_get_attributes_result_crafting
---@field ["craftsmanship"] integer 
---@field ["control"] integer 
---@field ["cp"] integer 
---@field ["gatheringStat"] integer 
---@field ["perception"] integer 
---@field ["gp"] integer 

---@class Xiv_get_attributes_result_attributes_item
---@field ["baseParamId"] integer 
---@field ["name"] string|nil 
---@field ["value"] integer 

---@class Xiv_get_attributes_result
---@field ["classJobId"] integer 
---@field ["job"] string|nil 
---@field ["crafting"] Xiv_get_attributes_result_crafting|nil 
---@field ["attributes"] (Xiv_get_attributes_result_attributes_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_bridge_state_args
---@field ["bridge"] "penumbra"|"glamourer"|"mare"|"lifestream"|"autoretainer"|"artisan"|"deliveroo"|"ghostty"|"xivdesktop"|"almanac"|"umbra"|"xivhud"|"xivhud_journal"|"xivhud_character"|"xivhud_vitals"|"xivpiano"|"xivlantern"|"xivwayfinder"|"xivrug" Bridge key from list_bridges.
---@field ["limit"] integer|nil Maximum entries kept from any list-shaped value (1-500).

---@class Xiv_get_bridge_state_result_bridge
---@field ["key"] string|nil 
---@field ["name"] string|nil 
---@field ["purpose"] string|nil 
---@field ["installed"] boolean 
---@field ["loaded"] boolean 
---@field ["version"] string|nil 
---@field ["ipcAvailable"] boolean 
---@field ["apiVersion"] string|nil 
---@field ["unavailable"] string|nil 
---@field ["verified"] boolean 

---@class Xiv_get_bridge_state_result_values_item
---@field ["field"] string|nil 
---@field ["description"] string|nil 
---@field ["value"] any|nil Any JSON value.
---@field ["error"] string|nil 

---@class Xiv_get_bridge_state_result
---@field ["bridge"] Xiv_get_bridge_state_result_bridge|nil 
---@field ["values"] (Xiv_get_bridge_state_result_values_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_character_sheet_args
---@field ["topCurrencies"] integer|nil How many non-zero currencies to include (0-50).
---@field ["includeRetainers"] boolean|nil Include the retainer summary.

---@class Xiv_get_character_sheet_result_identity
---@field ["name"] string|nil 
---@field ["homeWorld"] string|nil 
---@field ["dataCenter"] string|nil 
---@field ["currentWorld"] string|nil 
---@field ["title"] string|nil 
---@field ["grandCompany"] string|nil 
---@field ["grandCompanyRank"] string|nil 
---@field ["freeCompanyTag"] string|nil 

---@class Xiv_get_character_sheet_result_job
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 
---@field ["level"] integer 
---@field ["syncedLevel"] integer|nil 
---@field ["maxHp"] integer 
---@field ["maxMp"] integer|nil 

---@class Xiv_get_character_sheet_result_attributes_item
---@field ["name"] string|nil 
---@field ["value"] integer 

---@class Xiv_get_character_sheet_result_gear_pieces_item
---@field ["slot"] string|nil 
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["itemLevel"] integer 
---@field ["hq"] boolean|nil 
---@field ["conditionPercent"] number|nil 
---@field ["materia"] (string)[]|nil 

---@class Xiv_get_character_sheet_result_gear
---@field ["averageItemLevel"] integer 
---@field ["averageItemLevelNote"] string|nil 
---@field ["lowestItemLevel"] integer|nil 
---@field ["lowestItemLevelSlot"] string|nil 
---@field ["lowestConditionPercent"] number|nil 
---@field ["materiaMelded"] integer 
---@field ["pieces"] (Xiv_get_character_sheet_result_gear_pieces_item)[]|nil 
---@field ["emptySlots"] (string)[]|nil 

---@class Xiv_get_character_sheet_result_currencies_top_item
---@field ["name"] string|nil 
---@field ["count"] integer 
---@field ["max"] integer|nil 
---@field ["weeklyAcquired"] integer|nil 
---@field ["weeklyLimit"] integer|nil 

---@class Xiv_get_character_sheet_result_currencies
---@field ["gil"] integer 
---@field ["grandCompanySeals"] string|nil 
---@field ["nonZero"] integer 
---@field ["top"] (Xiv_get_character_sheet_result_currencies_top_item)[]|nil 

---@class Xiv_get_character_sheet_result_retainers_retainers_item
---@field ["name"] string|nil 
---@field ["classJob"] string|nil 
---@field ["level"] integer 
---@field ["gil"] integer 
---@field ["marketItems"] integer 
---@field ["venture"] string|nil 
---@field ["ventureComplete"] boolean|nil 

---@class Xiv_get_character_sheet_result_retainers
---@field ["loaded"] boolean 
---@field ["note"] string|nil 
---@field ["count"] integer 
---@field ["totalGil"] integer 
---@field ["venturesComplete"] integer 
---@field ["retainers"] (Xiv_get_character_sheet_result_retainers_retainers_item)[]|nil 

---@class Xiv_get_character_sheet_result
---@field ["identity"] Xiv_get_character_sheet_result_identity|nil 
---@field ["job"] Xiv_get_character_sheet_result_job|nil 
---@field ["attributes"] (Xiv_get_character_sheet_result_attributes_item)[]|nil 
---@field ["gear"] Xiv_get_character_sheet_result_gear|nil 
---@field ["currencies"] Xiv_get_character_sheet_result_currencies|nil 
---@field ["retainers"] Xiv_get_character_sheet_result_retainers|nil 
---@field ["unavailable"] (string)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_collection_progress_args
---@field ["kind"] "mounts"|"minions"|"orchestrion"|"emotes"|"fashionAccessories"|"triadCards"|"bardings"|"glasses"|"ornaments" Collection kind.
---@field ["owned"] "all"|"owned"|"missing"|nil Filter the returned list by ownership.
---@field ["nameContains"] string|nil Case-insensitive name substring filter for the returned list.
---@field ["limit"] integer|nil Maximum entries (1-500).
---@field ["offset"] integer|nil Entries to skip for paging.

---@class Xiv_get_collection_progress_result_items_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["owned"] boolean 

---@class Xiv_get_collection_progress_result
---@field ["kind"] string|nil 
---@field ["totalInGame"] integer 
---@field ["owned"] integer 
---@field ["missing"] integer 
---@field ["matching"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["items"] (Xiv_get_collection_progress_result_items_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_conditions_result
---@field ["loggedIn"] boolean 
---@field ["active"] (string)[]|nil 
---@field ["inCombat"] boolean 
---@field ["boundByDuty"] boolean 
---@field ["mounted"] boolean 
---@field ["inFlight"] boolean 
---@field ["swimming"] boolean 
---@field ["casting"] boolean 
---@field ["crafting"] boolean 
---@field ["gathering"] boolean 
---@field ["fishing"] boolean 
---@field ["betweenAreas"] boolean 
---@field ["inCutscene"] boolean 
---@field ["watchingCutscene"] boolean 
---@field ["occupiedInQuestEvent"] boolean 
---@field ["occupied"] boolean 
---@field ["performing"] boolean 
---@field ["dead"] boolean 
---@field ["inDutyQueue"] boolean 
---@field ["isClientIdle"] boolean 
---@field ["idleBlockedBy"] string|nil 

---@class Xiv_get_currencies_result_grandCompany
---@field ["grandCompanyId"] integer 
---@field ["name"] string|nil 
---@field ["sealItemId"] integer 
---@field ["seals"] integer 
---@field ["max"] integer 

---@class Xiv_get_currencies_result_currencies_item
---@field ["category"] string|nil 
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 
---@field ["max"] integer|nil 
---@field ["weeklyAcquired"] integer|nil 
---@field ["weeklyLimit"] integer|nil 

---@class Xiv_get_currencies_result
---@field ["gil"] integer 
---@field ["grandCompany"] Xiv_get_currencies_result_grandCompany|nil 
---@field ["currencies"] (Xiv_get_currencies_result_currencies_item)[]|nil 

---@class Xiv_get_dalamud_info_result
---@field ["dalamudVersion"] string|nil 
---@field ["dalamudApiLevel"] integer|nil 
---@field ["dalamudScmVersion"] string|nil 
---@field ["dalamudGitHash"] string|nil 
---@field ["dalamudBetaTrack"] string|nil 
---@field ["gameVersion"] string|nil 
---@field ["expansionVersions"] table<string, any>|nil 
---@field ["clientLanguage"] string|nil 
---@field ["dalamudUiLanguage"] string|nil 
---@field ["loggedIn"] boolean 
---@field ["isPvP"] boolean 
---@field ["inGpose"] boolean 
---@field ["inCutscene"] boolean 
---@field ["gameUiHidden"] boolean 
---@field ["globalUiScale"] number|nil 
---@field ["colorTheme"] string|nil 
---@field ["hasModifiedGameDataFiles"] boolean 
---@field ["installedPlugins"] integer 
---@field ["loadedPlugins"] integer 
---@field ["dalamudTrack"] string|nil 
---@field ["clientStructsGitHash"] string|nil 
---@field ["pluginSafeMode"] boolean|nil 

---@class Xiv_get_desktop_panels_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_desktop_status_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_dialogue_result_talk
---@field ["speaker"] string|nil 
---@field ["text"] string|nil 

---@class Xiv_get_dialogue_result_selectString
---@field ["options"] (string)[]|nil 
---@field ["texts"] (string)[]|nil 

---@class Xiv_get_dialogue_result_selectIconString
---@field ["options"] (string)[]|nil 
---@field ["texts"] (string)[]|nil 

---@class Xiv_get_dialogue_result_cutSceneSelectString
---@field ["options"] (string)[]|nil 
---@field ["texts"] (string)[]|nil 

---@class Xiv_get_dialogue_result_selectYesno
---@field ["prompt"] string|nil 
---@field ["buttons"] (string)[]|nil 

---@class Xiv_get_dialogue_result_selectOk
---@field ["prompt"] string|nil 
---@field ["buttons"] (string)[]|nil 

---@class Xiv_get_dialogue_result_journalAccept
---@field ["title"] string|nil 
---@field ["texts"] (string)[]|nil 

---@class Xiv_get_dialogue_result_journalResult
---@field ["title"] string|nil 
---@field ["texts"] (string)[]|nil 

---@class Xiv_get_dialogue_result_request
---@field ["title"] string|nil 
---@field ["texts"] (string)[]|nil 

---@class Xiv_get_dialogue_result_contextMenu
---@field ["title"] string|nil 
---@field ["texts"] (string)[]|nil 

---@class Xiv_get_dialogue_result
---@field ["anyOpen"] boolean 
---@field ["talk"] Xiv_get_dialogue_result_talk|nil 
---@field ["subtitle"] string|nil 
---@field ["selectString"] Xiv_get_dialogue_result_selectString|nil 
---@field ["selectIconString"] Xiv_get_dialogue_result_selectIconString|nil 
---@field ["cutSceneSelectString"] Xiv_get_dialogue_result_cutSceneSelectString|nil 
---@field ["selectYesno"] Xiv_get_dialogue_result_selectYesno|nil 
---@field ["selectOk"] Xiv_get_dialogue_result_selectOk|nil 
---@field ["journalAccept"] Xiv_get_dialogue_result_journalAccept|nil 
---@field ["journalResult"] Xiv_get_dialogue_result_journalResult|nil 
---@field ["request"] Xiv_get_dialogue_result_request|nil 
---@field ["contextMenu"] Xiv_get_dialogue_result_contextMenu|nil 

---@class Xiv_get_duty_args
---@field ["contentFinderConditionId"] integer ContentFinderCondition id (from search_duties).

---@class Xiv_get_duty_result_type
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_duty_result_unlockQuest
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_duty_result
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["description"] string|nil 
---@field ["type"] Xiv_get_duty_result_type|nil 
---@field ["level"] integer 
---@field ["itemLevelRequired"] integer 
---@field ["levelSync"] integer 
---@field ["itemLevelSync"] integer 
---@field ["partySize"] integer 
---@field ["tanks"] integer|nil 
---@field ["healers"] integer|nil 
---@field ["dps"] integer|nil 
---@field ["parties"] integer|nil 
---@field ["highEnd"] boolean 
---@field ["pvp"] boolean 
---@field ["allowUndersized"] boolean 
---@field ["allowExplorerMode"] boolean 
---@field ["inDutyFinder"] boolean 
---@field ["expansion"] string|nil 
---@field ["jobs"] string|nil 
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["unlockQuest"] Xiv_get_duty_result_unlockQuest|nil 
---@field ["roulettes"] (string)[]|nil 

---@class Xiv_get_duty_state_result_territory
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_duty_state_result_content_contentType
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_duty_state_result_content
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["contentType"] Xiv_get_duty_state_result_content_contentType|nil 
---@field ["levelRequired"] integer 
---@field ["levelSync"] integer 
---@field ["itemLevelRequired"] integer 
---@field ["itemLevelSync"] integer 
---@field ["partySize"] integer|nil 
---@field ["isAllianceContent"] boolean 
---@field ["highEndDuty"] boolean 
---@field ["isPvp"] boolean 
---@field ["dutyRecorderAllowed"] boolean 

---@class Xiv_get_duty_state_result_tracking
---@field ["lastEvent"] string|nil 
---@field ["enteredAtUtc"] string|nil 
---@field ["startedAtUtc"] string|nil 
---@field ["completedAtUtc"] string|nil 
---@field ["lastWipeAtUtc"] string|nil 
---@field ["recommencedAtUtc"] string|nil 
---@field ["wipes"] integer 
---@field ["elapsedSinceStartSeconds"] number|nil 
---@field ["observedSinceEntry"] boolean 

---@class Xiv_get_duty_state_result_director
---@field ["title"] string|nil 
---@field ["objective"] string|nil 
---@field ["timeRemainingSeconds"] number|nil 
---@field ["contentKind"] string|nil 

---@class Xiv_get_duty_state_result_party
---@field ["size"] integer 
---@field ["isAlliance"] boolean 
---@field ["tanks"] integer 
---@field ["healers"] integer 
---@field ["dps"] integer 
---@field ["other"] integer 

---@class Xiv_get_duty_state_result
---@field ["inDuty"] boolean 
---@field ["isDutyStarted"] boolean 
---@field ["isCompleted"] boolean 
---@field ["isPvp"] boolean 
---@field ["territory"] Xiv_get_duty_state_result_territory|nil 
---@field ["territoryIntendedUse"] string|nil 
---@field ["content"] Xiv_get_duty_state_result_content|nil 
---@field ["tracking"] Xiv_get_duty_state_result_tracking|nil 
---@field ["director"] Xiv_get_duty_state_result_director|nil 
---@field ["party"] Xiv_get_duty_state_result_party|nil 

---@class Xiv_get_duty_unlock_args
---@field ["contentFinderConditionId"] integer ContentFinderCondition id (from search_duties).

---@class Xiv_get_duty_unlock_result_unlockQuests_item_issuerLocation
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["mapId"] integer 
---@field ["x"] number|nil 
---@field ["y"] number|nil 
---@field ["region"] string|nil 

---@class Xiv_get_duty_unlock_result_unlockQuests_item_previousQuests_item
---@field ["questId"] integer 
---@field ["name"] string|nil 
---@field ["level"] integer 

---@class Xiv_get_duty_unlock_result_unlockQuests_item
---@field ["questId"] integer 
---@field ["name"] string|nil 
---@field ["level"] integer 
---@field ["genre"] string|nil 
---@field ["issuer"] string|nil 
---@field ["issuerLocation"] Xiv_get_duty_unlock_result_unlockQuests_item_issuerLocation|nil 
---@field ["previousQuestsJoin"] string|nil 
---@field ["previousQuests"] (Xiv_get_duty_unlock_result_unlockQuests_item_previousQuests_item)[]|nil 

---@class Xiv_get_duty_unlock_result_roulettes_item
---@field ["rouletteId"] integer|nil 
---@field ["name"] string|nil 

---@class Xiv_get_duty_unlock_result
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["type"] string|nil 
---@field ["level"] integer 
---@field ["itemLevelRequired"] integer 
---@field ["levelSync"] integer 
---@field ["itemLevelSync"] integer 
---@field ["expansion"] string|nil 
---@field ["inDutyFinder"] boolean 
---@field ["unlockQuests"] (Xiv_get_duty_unlock_result_unlockQuests_item)[]|nil 
---@field ["roulettes"] (Xiv_get_duty_unlock_result_roulettes_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_duty_unlocks_args
---@field ["contentType"] string|nil Content type name (partial ok, e.g. "Dungeon", "Trial", "Raid") or ContentType id.
---@field ["minLevel"] integer|nil Lowest required level to include.
---@field ["maxLevel"] integer|nil Highest required level to include; 0 = no upper bound.
---@field ["onlyLocked"] boolean|nil Only duties that are still locked.
---@field ["onlyIncomplete"] boolean|nil Only duties that are unlocked but have never been cleared.
---@field ["nameContains"] string|nil Case-insensitive duty name substring filter.
---@field ["limit"] integer|nil Maximum duties (1-500).
---@field ["offset"] integer|nil Duties to skip for paging.

---@class Xiv_get_duty_unlocks_result_byContentType_item
---@field ["contentType"] string|nil 
---@field ["known"] integer 
---@field ["unlocked"] integer 
---@field ["completed"] integer 

---@class Xiv_get_duty_unlocks_result_duties_item
---@field ["dutyId"] integer 
---@field ["name"] string|nil 
---@field ["contentType"] string|nil 
---@field ["level"] integer 
---@field ["itemLevel"] integer|nil 
---@field ["unlocked"] boolean|nil 
---@field ["completed"] boolean|nil 
---@field ["contentKind"] string|nil 
---@field ["contentId"] integer 

---@class Xiv_get_duty_unlocks_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["known"] integer 
---@field ["unlocked"] integer 
---@field ["completed"] integer 
---@field ["byContentType"] (Xiv_get_duty_unlocks_result_byContentType_item)[]|nil 
---@field ["duties"] (Xiv_get_duty_unlocks_result_duties_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_enmity_list_result_enemies_item
---@field ["position"] integer 
---@field ["name"] string|nil 
---@field ["entityId"] integer 
---@field ["enmityPercent"] integer 
---@field ["isCurrentTarget"] boolean|nil 

---@class Xiv_get_enmity_list_result_targetEnmity_item
---@field ["rank"] integer 
---@field ["name"] string|nil 
---@field ["entityId"] integer 
---@field ["enmity"] integer 
---@field ["percentOfTop"] number 
---@field ["isPlayer"] boolean|nil 

---@class Xiv_get_enmity_list_result
---@field ["enemyCount"] integer 
---@field ["enemies"] (Xiv_get_enmity_list_result_enemies_item)[]|nil 
---@field ["targetEntityId"] integer|nil 
---@field ["targetName"] string|nil 
---@field ["targetEnmity"] (Xiv_get_enmity_list_result_targetEnmity_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_equipment_result_slots_item
---@field ["slot"] string|nil 
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["itemLevel"] integer 
---@field ["equipLevel"] integer 
---@field ["hq"] boolean|nil 
---@field ["conditionPercent"] number|nil 
---@field ["spiritbondPercent"] number|nil 
---@field ["materia"] (string)[]|nil 
---@field ["glamourItemId"] integer|nil 
---@field ["glamour"] string|nil 
---@field ["dyes"] (string)[]|nil 

---@class Xiv_get_equipment_result
---@field ["classJob"] string|nil 
---@field ["averageItemLevel"] integer 
---@field ["averageItemLevelNote"] string|nil 
---@field ["soulCrystal"] string|nil 
---@field ["slots"] (Xiv_get_equipment_result_slots_item)[]|nil 
---@field ["emptySlots"] (string)[]|nil 

---@class Xiv_get_events_args
---@field ["afterSeq"] integer|nil Return only events after this sequence number. Use the cursor from the previous call.
---@field ["kinds"] (string)[]|nil Only these kinds, e.g. ["duty", "combat"]. Omit for all.
---@field ["limit"] integer|nil Maximum events to return (1-500).

---@class Xiv_get_events_result_events_item
---@field ["seq"] integer 
---@field ["at"] string 
---@field ["kind"] string|nil 
---@field ["summary"] string|nil 
---@field ["data"] table<string, any>|nil 

---@class Xiv_get_events_result
---@field ["events"] (Xiv_get_events_result_events_item)[]|nil 
---@field ["cursor"] integer 
---@field ["returned"] integer 
---@field ["remaining"] integer 
---@field ["missedEvents"] boolean 
---@field ["buffered"] integer 
---@field ["capacity"] integer 
---@field ["droppedTotal"] integer 
---@field ["note"] string|nil 

---@class Xiv_get_gathering_info_args
---@field ["itemId"] integer Item id to look up. Use search_items with isGatherable=true to find one.
---@field ["timedOnly"] boolean|nil Only return nodes that are timed (unspoiled or ephemeral).
---@field ["pointLimit"] integer|nil Maximum node locations per source (1-12).

---@class Xiv_get_gathering_info_result_sources_item_points_item_window
---@field ["start"] string|nil 
---@field ["end"] string|nil 
---@field ["openNow"] boolean 
---@field ["nextStartUtc"] string 
---@field ["nextEndUtc"] string 
---@field ["secondsUntilStart"] integer 
---@field ["secondsUntilEnd"] integer 

---@class Xiv_get_gathering_info_result_sources_item_points_item
---@field ["gatheringPointBaseId"] integer 
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["place"] string|nil 
---@field ["mapId"] integer 
---@field ["mapX"] number|nil 
---@field ["mapY"] number|nil 
---@field ["radiusYalms"] integer|nil 
---@field ["level"] integer 
---@field ["gatheringType"] string|nil 
---@field ["timed"] boolean 
---@field ["window"] Xiv_get_gathering_info_result_sources_item_points_item_window|nil 
---@field ["windowKind"] string|nil 

---@class Xiv_get_gathering_info_result_sources_item
---@field ["gatheringItemId"] integer 
---@field ["gatheringItemLevel"] integer 
---@field ["stars"] integer 
---@field ["hidden"] boolean 
---@field ["perceptionRequired"] integer 
---@field ["isTimed"] boolean 
---@field ["totalPoints"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["points"] (Xiv_get_gathering_info_result_sources_item_points_item)[]|nil 

---@class Xiv_get_gathering_info_result
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["gatherable"] boolean 
---@field ["eorzeaTime"] string|nil 
---@field ["asOfUtc"] string 
---@field ["sources"] (Xiv_get_gathering_info_result_sources_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_glamour_plates_args
---@field ["plateNumber"] integer|nil Only this plate (1-20). Omit for all.
---@field ["includeEmpty"] boolean|nil Include plates with no items in them.

---@class Xiv_get_glamour_plates_result_plates_item_slots_item
---@field ["slot"] string|nil 
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["hq"] boolean 
---@field ["dye1"] integer|nil 
---@field ["dye2"] integer|nil 

---@class Xiv_get_glamour_plates_result_plates_item
---@field ["plateNumber"] integer 
---@field ["empty"] boolean 
---@field ["filledSlots"] integer 
---@field ["slots"] (Xiv_get_glamour_plates_result_plates_item_slots_item)[]|nil 

---@class Xiv_get_glamour_plates_result
---@field ["loaded"] boolean 
---@field ["total"] integer 
---@field ["nonEmpty"] integer 
---@field ["plates"] (Xiv_get_glamour_plates_result_plates_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_housing_info_result
---@field ["inHousingArea"] boolean 
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["ward"] integer|nil 
---@field ["plot"] integer|nil 
---@field ["division"] integer|nil 
---@field ["room"] integer|nil 
---@field ["houseId"] string|nil 
---@field ["inside"] boolean 
---@field ["outside"] boolean 
---@field ["inWorkshop"] boolean 
---@field ["hasPermissions"] boolean 
---@field ["freeCompanyTag"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_hud_family_status_result_modules_item_plugin
---@field ["key"] string|nil 
---@field ["name"] string|nil 
---@field ["purpose"] string|nil 
---@field ["installed"] boolean 
---@field ["loaded"] boolean 
---@field ["version"] string|nil 
---@field ["ipcAvailable"] boolean 
---@field ["apiVersion"] string|nil 
---@field ["unavailable"] string|nil 
---@field ["verified"] boolean 

---@class Xiv_get_hud_family_status_result_modules_item
---@field ["module"] string|nil 
---@field ["plugin"] Xiv_get_hud_family_status_result_modules_item_plugin|nil 
---@field ["capabilities"] any|nil Any JSON value.
---@field ["snapshot"] any|nil Any JSON value.
---@field ["error"] string|nil 

---@class Xiv_get_hud_family_status_result
---@field ["modules"] (Xiv_get_hud_family_status_result_modules_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_hud_module_status_args
---@field ["module"] "hud"|"journal"|"character"|"vitals" HUD module.

---@class Xiv_get_hud_module_status_result_plugin
---@field ["key"] string|nil 
---@field ["name"] string|nil 
---@field ["purpose"] string|nil 
---@field ["installed"] boolean 
---@field ["loaded"] boolean 
---@field ["version"] string|nil 
---@field ["ipcAvailable"] boolean 
---@field ["apiVersion"] string|nil 
---@field ["unavailable"] string|nil 
---@field ["verified"] boolean 

---@class Xiv_get_hud_module_status_result
---@field ["module"] string|nil 
---@field ["plugin"] Xiv_get_hud_module_status_result_plugin|nil 
---@field ["capabilities"] any|nil Any JSON value.
---@field ["snapshot"] any|nil Any JSON value.
---@field ["error"] string|nil 

---@class Xiv_get_hud_request_args
---@field ["module"] "hud"|"journal"|"character"|"vitals" Originating module.
---@field ["requestId"] string requestId returned by a HUD change.

---@class Xiv_get_hud_request_result
---@field ["result"] any Any JSON value.

---@class Xiv_get_inventory_args
---@field ["containers"] ("bags"|"equipped"|"armory"|"crystals"|"currency"|"keyItems"|"saddlebag"|"premiumSaddlebag"|"retainer"|"retainerEquipped"|"retainerMarket"|"all")[]|nil Container groups to list; default ["bags"]. "all" selects every group.
---@field ["includeEmpty"] boolean|nil Include empty slots (itemId 0) in items.
---@field ["limit"] integer|nil Maximum slot entries (1-500).
---@field ["offset"] integer|nil Entries to skip for paging.

---@class Xiv_get_inventory_result_containers_item
---@field ["container"] string|nil 
---@field ["group"] string|nil 
---@field ["loaded"] boolean 
---@field ["size"] integer 
---@field ["used"] integer 

---@class Xiv_get_inventory_result_items_item
---@field ["container"] string|nil 
---@field ["group"] string|nil 
---@field ["slot"] integer 
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["quantity"] integer 
---@field ["hq"] boolean|nil 
---@field ["collectable"] boolean|nil 
---@field ["collectability"] integer|nil 
---@field ["conditionPercent"] number|nil 
---@field ["spiritbondPercent"] number|nil 
---@field ["materia"] (string)[]|nil 
---@field ["glamourItemId"] integer|nil 
---@field ["glamour"] string|nil 
---@field ["dyes"] (string)[]|nil 
---@field ["marketPrice"] integer|nil 
---@field ["itemLevel"] integer|nil 

---@class Xiv_get_inventory_result
---@field ["containers"] (Xiv_get_inventory_result_containers_item)[]|nil 
---@field ["unavailable"] (string)[]|nil 
---@field ["retainer"] string|nil 
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["items"] (Xiv_get_inventory_result_items_item)[]|nil 

---@class Xiv_get_item_args
---@field ["itemId"] integer Item id (row id in the Item sheet). HQ ids (1,000,000+) are accepted.

---@class Xiv_get_item_result_category
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_item_result_marketCategory
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_item_result_jobs
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_item_result_stats_item
---@field ["name"] string|nil 
---@field ["value"] integer 
---@field ["hqValue"] integer|nil 

---@class Xiv_get_item_result_vendors_item_location
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["mapId"] integer 
---@field ["x"] number|nil 
---@field ["y"] number|nil 
---@field ["region"] string|nil 

---@class Xiv_get_item_result_vendors_item
---@field ["npc"] string|nil 
---@field ["npcId"] integer 
---@field ["shop"] string|nil 
---@field ["shopId"] integer 
---@field ["priceGil"] integer 
---@field ["location"] Xiv_get_item_result_vendors_item_location|nil 

---@class Xiv_get_item_result_exchanges_item_costs_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 

---@class Xiv_get_item_result_exchanges_item
---@field ["shop"] string|nil 
---@field ["shopId"] integer 
---@field ["receiveCount"] integer 
---@field ["costs"] (Xiv_get_item_result_exchanges_item_costs_item)[]|nil 
---@field ["npcs"] (string)[]|nil 

---@class Xiv_get_item_result_craftedBy_item
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 
---@field ["quantity"] integer|nil 
---@field ["yield"] integer|nil 

---@class Xiv_get_item_result_usedIn_item
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 
---@field ["quantity"] integer|nil 
---@field ["yield"] integer|nil 

---@class Xiv_get_item_result_gathering_item_points_item
---@field ["zone"] string|nil 
---@field ["place"] string|nil 
---@field ["level"] integer 
---@field ["type"] string|nil 
---@field ["territoryId"] integer 
---@field ["timed"] string|nil 

---@class Xiv_get_item_result_gathering_item
---@field ["gatheringItemId"] integer 
---@field ["itemLevel"] integer 
---@field ["stars"] integer 
---@field ["hidden"] boolean 
---@field ["perceptionRequired"] integer 
---@field ["totalPoints"] integer 
---@field ["points"] (Xiv_get_item_result_gathering_item_points_item)[]|nil 

---@class Xiv_get_item_result
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["description"] string|nil 
---@field ["icon"] integer 
---@field ["category"] Xiv_get_item_result_category|nil 
---@field ["marketCategory"] Xiv_get_item_result_marketCategory|nil 
---@field ["itemLevel"] integer 
---@field ["equipLevel"] integer 
---@field ["jobs"] Xiv_get_item_result_jobs|nil 
---@field ["equipSlots"] (string)[]|nil 
---@field ["rarity"] integer 
---@field ["stackSize"] integer 
---@field ["isUnique"] boolean 
---@field ["isUntradable"] boolean 
---@field ["isMarketable"] boolean 
---@field ["canBeHq"] boolean 
---@field ["isCollectable"] boolean 
---@field ["isGlamourous"] boolean 
---@field ["isCrestWorthy"] boolean 
---@field ["dyeCount"] integer 
---@field ["materiaSlots"] integer 
---@field ["advancedMeldingPermitted"] boolean 
---@field ["vendorBuyPrice"] integer|nil 
---@field ["vendorSellPrice"] integer 
---@field ["desynthesizable"] boolean 
---@field ["aetherialReducible"] boolean 
---@field ["repairClass"] string|nil 
---@field ["itemSeries"] string|nil 
---@field ["physicalDamage"] integer|nil 
---@field ["magicDamage"] integer|nil 
---@field ["delaySeconds"] number|nil 
---@field ["defense"] integer|nil 
---@field ["magicDefense"] integer|nil 
---@field ["block"] integer|nil 
---@field ["blockRate"] integer|nil 
---@field ["stats"] (Xiv_get_item_result_stats_item)[]|nil 
---@field ["specialBonus"] string|nil 
---@field ["vendors"] (Xiv_get_item_result_vendors_item)[]|nil 
---@field ["vendorTotal"] integer 
---@field ["exchanges"] (Xiv_get_item_result_exchanges_item)[]|nil 
---@field ["exchangeTotal"] integer 
---@field ["craftedBy"] (Xiv_get_item_result_craftedBy_item)[]|nil 
---@field ["usedIn"] (Xiv_get_item_result_usedIn_item)[]|nil 
---@field ["usedInTotal"] integer 
---@field ["gathering"] (Xiv_get_item_result_gathering_item)[]|nil 

---@class Xiv_get_item_sources_args
---@field ["itemId"] integer Item id (use search_items to find it). The HQ offset (1,000,000) is ignored.
---@field ["limit"] integer|nil Maximum entries per paged list (1-100).
---@field ["offset"] integer|nil Entries to skip in each paged list.

---@class Xiv_get_item_sources_result_recipes_item
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 
---@field ["quantity"] integer|nil 
---@field ["yield"] integer|nil 

---@class Xiv_get_item_sources_result_gathering_item_points_item
---@field ["zone"] string|nil 
---@field ["place"] string|nil 
---@field ["level"] integer 
---@field ["type"] string|nil 
---@field ["territoryId"] integer 
---@field ["timed"] string|nil 

---@class Xiv_get_item_sources_result_gathering_item
---@field ["gatheringItemId"] integer 
---@field ["itemLevel"] integer 
---@field ["stars"] integer 
---@field ["hidden"] boolean 
---@field ["perceptionRequired"] integer 
---@field ["totalPoints"] integer 
---@field ["points"] (Xiv_get_item_sources_result_gathering_item_points_item)[]|nil 

---@class Xiv_get_item_sources_result_vendors_results_item_location
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["mapId"] integer 
---@field ["x"] number|nil 
---@field ["y"] number|nil 
---@field ["region"] string|nil 

---@class Xiv_get_item_sources_result_vendors_results_item
---@field ["npc"] string|nil 
---@field ["npcId"] integer 
---@field ["shop"] string|nil 
---@field ["shopId"] integer 
---@field ["priceGil"] integer 
---@field ["location"] Xiv_get_item_sources_result_vendors_results_item_location|nil 

---@class Xiv_get_item_sources_result_vendors
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_sources_result_vendors_results_item)[]|nil 

---@class Xiv_get_item_sources_result_exchanges_results_item_costs_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 

---@class Xiv_get_item_sources_result_exchanges_results_item
---@field ["shop"] string|nil 
---@field ["shopId"] integer 
---@field ["receiveCount"] integer 
---@field ["costs"] (Xiv_get_item_sources_result_exchanges_results_item_costs_item)[]|nil 
---@field ["npcs"] (string)[]|nil 

---@class Xiv_get_item_sources_result_exchanges
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_sources_result_exchanges_results_item)[]|nil 

---@class Xiv_get_item_sources_result_gcSeals
---@field ["seals"] integer 
---@field ["requiredRankId"] integer 

---@class Xiv_get_item_sources_result_ventures_results_item
---@field ["retainerTaskId"] integer 
---@field ["retainerLevel"] integer 
---@field ["jobs"] string|nil 
---@field ["ventureCost"] integer 
---@field ["maxMinutes"] integer 
---@field ["quantities"] (integer)[]|nil 

---@class Xiv_get_item_sources_result_ventures
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_sources_result_ventures_results_item)[]|nil 

---@class Xiv_get_item_sources_result_quests_results_item
---@field ["questId"] integer 
---@field ["name"] string|nil 
---@field ["level"] integer 
---@field ["count"] integer 
---@field ["optional"] boolean 

---@class Xiv_get_item_sources_result_quests
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_sources_result_quests_results_item)[]|nil 

---@class Xiv_get_item_sources_result_achievements_results_item
---@field ["achievementId"] integer 
---@field ["name"] string|nil 
---@field ["description"] string|nil 

---@class Xiv_get_item_sources_result_achievements
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_sources_result_achievements_results_item)[]|nil 

---@class Xiv_get_item_sources_result
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["kinds"] (string)[]|nil 
---@field ["gilPrice"] integer|nil 
---@field ["recipes"] (Xiv_get_item_sources_result_recipes_item)[]|nil 
---@field ["gathering"] (Xiv_get_item_sources_result_gathering_item)[]|nil 
---@field ["vendors"] Xiv_get_item_sources_result_vendors|nil 
---@field ["exchanges"] Xiv_get_item_sources_result_exchanges|nil 
---@field ["gcSeals"] Xiv_get_item_sources_result_gcSeals|nil 
---@field ["ventures"] Xiv_get_item_sources_result_ventures|nil 
---@field ["quests"] Xiv_get_item_sources_result_quests|nil 
---@field ["achievements"] Xiv_get_item_sources_result_achievements|nil 
---@field ["notCovered"] string|nil 

---@class Xiv_get_item_uses_args
---@field ["itemId"] integer Item id (use search_items to find it). The HQ offset (1,000,000) is ignored.
---@field ["limit"] integer|nil Maximum entries per paged list (1-200).
---@field ["offset"] integer|nil Entries to skip in each paged list.

---@class Xiv_get_item_uses_result_recipes_results_item
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 
---@field ["quantity"] integer|nil 
---@field ["yield"] integer|nil 

---@class Xiv_get_item_uses_result_recipes
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_uses_result_recipes_results_item)[]|nil 

---@class Xiv_get_item_uses_result_tradeIns_results_item_gives_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 

---@class Xiv_get_item_uses_result_tradeIns_results_item_otherCosts_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 

---@class Xiv_get_item_uses_result_tradeIns_results_item
---@field ["shop"] string|nil 
---@field ["shopId"] integer 
---@field ["amount"] integer 
---@field ["gives"] (Xiv_get_item_uses_result_tradeIns_results_item_gives_item)[]|nil 
---@field ["otherCosts"] (Xiv_get_item_uses_result_tradeIns_results_item_otherCosts_item)[]|nil 
---@field ["npcs"] (string)[]|nil 

---@class Xiv_get_item_uses_result_tradeIns
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_uses_result_tradeIns_results_item)[]|nil 

---@class Xiv_get_item_uses_result_leves_results_item
---@field ["leveId"] integer 
---@field ["name"] string|nil 
---@field ["level"] integer 
---@field ["jobs"] string|nil 
---@field ["count"] integer 
---@field ["repeats"] integer 

---@class Xiv_get_item_uses_result_leves
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_item_uses_result_leves_results_item)[]|nil 

---@class Xiv_get_item_uses_result_gcSupply_item
---@field ["level"] integer 
---@field ["job"] string|nil 
---@field ["count"] integer 

---@class Xiv_get_item_uses_result
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["recipes"] Xiv_get_item_uses_result_recipes|nil 
---@field ["tradeIns"] Xiv_get_item_uses_result_tradeIns|nil 
---@field ["leves"] Xiv_get_item_uses_result_leves|nil 
---@field ["gcSupply"] (Xiv_get_item_uses_result_gcSupply_item)[]|nil 
---@field ["desynthesizable"] boolean 
---@field ["aetherialReducible"] boolean 
---@field ["isCollectable"] boolean 
---@field ["isCrystal"] boolean 
---@field ["isMarketable"] boolean 
---@field ["isUntradable"] boolean 
---@field ["vendorSellPrice"] integer 
---@field ["notCovered"] string|nil 

---@class Xiv_get_job_gauge_result_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_job_gauge_result
---@field ["job"] Xiv_get_job_gauge_result_job|nil 
---@field ["hasGauge"] boolean 
---@field ["gaugeType"] string|nil 
---@field ["values"] table<string, any>|nil 
---@field ["note"] string|nil 

---@class Xiv_get_job_levels_result_currentJob
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_job_levels_result_jobs_item
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 
---@field ["type"] string|nil 
---@field ["parentClass"] string|nil 
---@field ["level"] integer 
---@field ["experience"] integer 
---@field ["experienceToNext"] integer|nil 
---@field ["progressPercent"] number|nil 
---@field ["isMaxLevel"] boolean|nil 
---@field ["unlocked"] boolean 
---@field ["isCurrent"] boolean 

---@class Xiv_get_job_levels_result
---@field ["currentJob"] Xiv_get_job_levels_result_currentJob|nil 
---@field ["currentLevel"] integer 
---@field ["maxLevel"] integer 
---@field ["unlockedCount"] integer 
---@field ["jobs"] (Xiv_get_job_levels_result_jobs_item)[]|nil 

---@class Xiv_get_latest_screenshot_args
---@field ["maxDimension"] integer|nil Longer side of the returned image in pixels (64-4096).
---@field ["maxAgeSeconds"] integer|nil Only return a file modified within this many seconds (0 = any age).

---@class Xiv_get_location_result_territory
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["internalName"] string|nil 
---@field ["region"] string|nil 
---@field ["zone"] string|nil 
---@field ["intendedUseId"] integer 
---@field ["intendedUse"] string|nil 
---@field ["isPvp"] boolean 
---@field ["mountsAllowed"] boolean 

---@class Xiv_get_location_result_map
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_location_result_duty
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_location_result_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_location_result_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_location_result_weather
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_location_result_housing
---@field ["area"] string|nil 
---@field ["ward"] integer|nil 
---@field ["plot"] integer|nil 
---@field ["room"] integer|nil 
---@field ["division"] integer 
---@field ["inside"] boolean 
---@field ["inWorkshop"] boolean 
---@field ["rawWard"] integer 
---@field ["rawPlot"] integer 

---@class Xiv_get_location_result_nearestAetheryte_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_location_result_nearestAetheryte
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["isAethernetShard"] boolean 
---@field ["unlocked"] boolean 
---@field ["mapCoordinates"] Xiv_get_location_result_nearestAetheryte_mapCoordinates|nil 
---@field ["mapDistance"] number 

---@class Xiv_get_location_result_nearestAethernetShard_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_location_result_nearestAethernetShard
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["isAethernetShard"] boolean 
---@field ["unlocked"] boolean 
---@field ["mapCoordinates"] Xiv_get_location_result_nearestAethernetShard_mapCoordinates|nil 
---@field ["mapDistance"] number 

---@class Xiv_get_location_result
---@field ["territory"] Xiv_get_location_result_territory|nil 
---@field ["map"] Xiv_get_location_result_map|nil 
---@field ["area"] string|nil 
---@field ["subArea"] string|nil 
---@field ["instance"] integer 
---@field ["duty"] Xiv_get_location_result_duty|nil 
---@field ["position"] Xiv_get_location_result_position|nil 
---@field ["mapCoordinates"] Xiv_get_location_result_mapCoordinates|nil 
---@field ["weather"] Xiv_get_location_result_weather|nil 
---@field ["housing"] Xiv_get_location_result_housing|nil 
---@field ["inSanctuary"] boolean 
---@field ["canFly"] boolean 
---@field ["flyingUnlockedInZone"] boolean 
---@field ["nearestAetheryte"] Xiv_get_location_result_nearestAetheryte|nil 
---@field ["nearestAethernetShard"] Xiv_get_location_result_nearestAethernetShard|nil 

---@class Xiv_get_market_prices_args
---@field ["itemIds"] (integer)[] Item ids to price (1-20). Get them from search_items or get_item.
---@field ["scope"] string|nil World, data-centre or region name. Default: the character's current world.
---@field ["hq"] boolean|nil Only high-quality (true) or only normal-quality (false) listings. Omit for both.
---@field ["listings"] integer|nil Listings to return per item (1-50).
---@field ["recentSales"] integer|nil Recent sales to return per item (0-50).

---@class Xiv_get_market_prices_result_items_item_listings_item
---@field ["pricePerUnit"] integer 
---@field ["quantity"] integer 
---@field ["total"] integer 
---@field ["hq"] boolean 
---@field ["retainerName"] string|nil 
---@field ["world"] string|nil 
---@field ["materiaCount"] integer|nil 
---@field ["lastReviewUtc"] string|nil 

---@class Xiv_get_market_prices_result_items_item_recentSales_item
---@field ["pricePerUnit"] integer 
---@field ["quantity"] integer 
---@field ["total"] integer 
---@field ["hq"] boolean 
---@field ["world"] string|nil 
---@field ["timestampUtc"] string|nil 

---@class Xiv_get_market_prices_result_items_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["marketable"] boolean 
---@field ["scope"] string|nil 
---@field ["minPrice"] integer|nil 
---@field ["minPriceNq"] integer|nil 
---@field ["minPriceHq"] integer|nil 
---@field ["averagePrice"] number|nil 
---@field ["averagePriceNq"] number|nil 
---@field ["averagePriceHq"] number|nil 
---@field ["nqSaleVelocityPerDay"] number|nil 
---@field ["hqSaleVelocityPerDay"] number|nil 
---@field ["unitsForSale"] integer|nil 
---@field ["unitsSold"] integer|nil 
---@field ["lastUploadUtc"] string|nil 
---@field ["listingCount"] integer 
---@field ["listings"] (Xiv_get_market_prices_result_items_item_listings_item)[]|nil 
---@field ["recentSales"] (Xiv_get_market_prices_result_items_item_recentSales_item)[]|nil 

---@class Xiv_get_market_prices_result
---@field ["scope"] string|nil 
---@field ["scopeKind"] string|nil 
---@field ["source"] string|nil 
---@field ["sourceUrl"] string|nil 
---@field ["fetchedAtUtc"] string 
---@field ["fromCache"] boolean 
---@field ["dataNote"] string|nil 
---@field ["items"] (Xiv_get_market_prices_result_items_item)[]|nil 
---@field ["unresolvedItemIds"] (integer)[]|nil 

---@class Xiv_get_party_result_composition
---@field ["tanks"] integer 
---@field ["healers"] integer 
---@field ["melee"] integer 
---@field ["physicalRanged"] integer 
---@field ["magicalRanged"] integer 
---@field ["other"] integer 

---@class Xiv_get_party_result_members_item_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_party_result_members_item_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_party_result_members_item_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_party_result_members_item_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_party_result_members_item_territory
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_party_result_members_item_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_party_result_members_item_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_party_result_members_item
---@field ["index"] integer 
---@field ["name"] string|nil 
---@field ["contentId"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["homeWorld"] Xiv_get_party_result_members_item_homeWorld|nil 
---@field ["job"] Xiv_get_party_result_members_item_job|nil 
---@field ["level"] integer 
---@field ["hp"] Xiv_get_party_result_members_item_hp|nil 
---@field ["mp"] Xiv_get_party_result_members_item_mp|nil 
---@field ["territory"] Xiv_get_party_result_members_item_territory|nil 
---@field ["inSameTerritory"] boolean 
---@field ["objectLoaded"] boolean 
---@field ["position"] Xiv_get_party_result_members_item_position|nil 
---@field ["mapCoordinates"] Xiv_get_party_result_members_item_mapCoordinates|nil 
---@field ["distance"] number|nil 
---@field ["isLeader"] boolean 
---@field ["isSelf"] boolean 
---@field ["allianceGroup"] integer|nil 

---@class Xiv_get_party_result_allianceMembers_item_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_party_result_allianceMembers_item_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_party_result_allianceMembers_item_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_party_result_allianceMembers_item_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_party_result_allianceMembers_item_territory
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_party_result_allianceMembers_item_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_party_result_allianceMembers_item_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_party_result_allianceMembers_item
---@field ["index"] integer 
---@field ["name"] string|nil 
---@field ["contentId"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["homeWorld"] Xiv_get_party_result_allianceMembers_item_homeWorld|nil 
---@field ["job"] Xiv_get_party_result_allianceMembers_item_job|nil 
---@field ["level"] integer 
---@field ["hp"] Xiv_get_party_result_allianceMembers_item_hp|nil 
---@field ["mp"] Xiv_get_party_result_allianceMembers_item_mp|nil 
---@field ["territory"] Xiv_get_party_result_allianceMembers_item_territory|nil 
---@field ["inSameTerritory"] boolean 
---@field ["objectLoaded"] boolean 
---@field ["position"] Xiv_get_party_result_allianceMembers_item_position|nil 
---@field ["mapCoordinates"] Xiv_get_party_result_allianceMembers_item_mapCoordinates|nil 
---@field ["distance"] number|nil 
---@field ["isLeader"] boolean 
---@field ["isSelf"] boolean 
---@field ["allianceGroup"] integer|nil 

---@class Xiv_get_party_result_crossRealmMembers_item_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_party_result_crossRealmMembers_item_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_party_result_crossRealmMembers_item_currentWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_party_result_crossRealmMembers_item
---@field ["groupIndex"] integer 
---@field ["memberIndex"] integer 
---@field ["name"] string|nil 
---@field ["contentId"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["level"] integer 
---@field ["job"] Xiv_get_party_result_crossRealmMembers_item_job|nil 
---@field ["homeWorld"] Xiv_get_party_result_crossRealmMembers_item_homeWorld|nil 
---@field ["currentWorld"] Xiv_get_party_result_crossRealmMembers_item_currentWorld|nil 
---@field ["isLeader"] boolean 
---@field ["isSelf"] boolean 

---@class Xiv_get_party_result_buddies_item_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_party_result_buddies_item
---@field ["kind"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["name"] string|nil 
---@field ["hp"] Xiv_get_party_result_buddies_item_hp|nil 
---@field ["distance"] number|nil 

---@class Xiv_get_party_result
---@field ["mode"] string|nil 
---@field ["size"] integer 
---@field ["isAlliance"] boolean 
---@field ["isCrossRealm"] boolean 
---@field ["leaderName"] string|nil 
---@field ["composition"] Xiv_get_party_result_composition|nil 
---@field ["members"] (Xiv_get_party_result_members_item)[]|nil 
---@field ["allianceMembers"] (Xiv_get_party_result_allianceMembers_item)[]|nil 
---@field ["crossRealmMembers"] (Xiv_get_party_result_crossRealmMembers_item)[]|nil 
---@field ["buddies"] (Xiv_get_party_result_buddies_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_player_result_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_player_result_currentWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_player_result_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_player_result_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_player_result_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_player_result_cp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_player_result_gp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_player_result_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_player_result_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_player_result_rotation
---@field ["radians"] number 
---@field ["headingDegrees"] number 
---@field ["compass"] string|nil 

---@class Xiv_get_player_result_territory
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_player_result_map
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_player_result_onlineStatus
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_player_result_grandCompany
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["rank"] integer 
---@field ["rankName"] string|nil 

---@class Xiv_get_player_result_title
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["isPrefix"] boolean 

---@class Xiv_get_player_result_mount
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_player_result_minion
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_player_result_cast
---@field ["actionId"] integer 
---@field ["actionType"] string|nil 
---@field ["actionName"] string|nil 
---@field ["elapsedSeconds"] number 
---@field ["totalSeconds"] number 
---@field ["remainingSeconds"] number 
---@field ["interruptible"] boolean 
---@field ["targetGameObjectId"] string|nil 

---@class Xiv_get_player_result_statuses_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["param"] integer 
---@field ["stacks"] integer|nil 
---@field ["remainingSeconds"] number|nil 
---@field ["isPermanent"] boolean 
---@field ["sourceEntityId"] integer|nil 
---@field ["sourceName"] string|nil 

---@class Xiv_get_player_result
---@field ["name"] string|nil 
---@field ["entityId"] integer 
---@field ["contentId"] string|nil 
---@field ["homeWorld"] Xiv_get_player_result_homeWorld|nil 
---@field ["currentWorld"] Xiv_get_player_result_currentWorld|nil 
---@field ["isWorldVisiting"] boolean 
---@field ["job"] Xiv_get_player_result_job|nil 
---@field ["level"] integer 
---@field ["syncedLevel"] integer|nil 
---@field ["isLevelSynced"] boolean 
---@field ["hp"] Xiv_get_player_result_hp|nil 
---@field ["mp"] Xiv_get_player_result_mp|nil 
---@field ["cp"] Xiv_get_player_result_cp|nil 
---@field ["gp"] Xiv_get_player_result_gp|nil 
---@field ["shieldPercent"] integer 
---@field ["position"] Xiv_get_player_result_position|nil 
---@field ["mapCoordinates"] Xiv_get_player_result_mapCoordinates|nil 
---@field ["rotation"] Xiv_get_player_result_rotation|nil 
---@field ["territory"] Xiv_get_player_result_territory|nil 
---@field ["map"] Xiv_get_player_result_map|nil 
---@field ["onlineStatus"] Xiv_get_player_result_onlineStatus|nil 
---@field ["grandCompany"] Xiv_get_player_result_grandCompany|nil 
---@field ["freeCompanyTag"] string|nil 
---@field ["title"] Xiv_get_player_result_title|nil 
---@field ["mount"] Xiv_get_player_result_mount|nil 
---@field ["minion"] Xiv_get_player_result_minion|nil 
---@field ["isCasting"] boolean 
---@field ["cast"] Xiv_get_player_result_cast|nil 
---@field ["inCombat"] boolean 
---@field ["isDead"] boolean 
---@field ["weaponDrawn"] boolean 
---@field ["statusCount"] integer 
---@field ["statuses"] (Xiv_get_player_result_statuses_item)[]|nil 

---@class Xiv_get_plugin_setup_plan_args
---@field ["plugins"] (string)[] Exact plugin internal names, 1-12 unique entries.
---@field ["repositoryUrl"] string|nil HTTPS pluginmaster URL. New plugins in this repository need no new MCP code.
---@field ["channel"] "stable"|"testing"|nil Explicit release channel.

---@class Xiv_get_plugin_setup_plan_result_plugins_item_package
---@field ["internalName"] string|nil 
---@field ["version"] string|nil 
---@field ["apiLevel"] integer 
---@field ["downloadUrl"] string|nil 
---@field ["useTesting"] boolean 
---@field ["dependencies"] (string)[]|nil 

---@class Xiv_get_plugin_setup_plan_result_plugins_item
---@field ["package"] Xiv_get_plugin_setup_plan_result_plugins_item_package|nil 
---@field ["action"] string|nil 
---@field ["installedVersion"] string|nil 

---@class Xiv_get_plugin_setup_plan_result
---@field ["repositoryUrl"] string|nil 
---@field ["channel"] string|nil 
---@field ["plugins"] (Xiv_get_plugin_setup_plan_result_plugins_item)[]|nil 
---@field ["enableTesting"] boolean 
---@field ["note"] string|nil 

---@class Xiv_get_plugin_setup_status_args
---@field ["id"] string Operation id from setup_plugins.

---@class Xiv_get_plugin_setup_status_result_plan_plugins_item_package
---@field ["internalName"] string|nil 
---@field ["version"] string|nil 
---@field ["apiLevel"] integer 
---@field ["downloadUrl"] string|nil 
---@field ["useTesting"] boolean 
---@field ["dependencies"] (string)[]|nil 

---@class Xiv_get_plugin_setup_status_result_plan_plugins_item
---@field ["package"] Xiv_get_plugin_setup_status_result_plan_plugins_item_package|nil 
---@field ["action"] string|nil 
---@field ["installedVersion"] string|nil 

---@class Xiv_get_plugin_setup_status_result_plan
---@field ["repositoryUrl"] string|nil 
---@field ["channel"] string|nil 
---@field ["plugins"] (Xiv_get_plugin_setup_status_result_plan_plugins_item)[]|nil 
---@field ["enableTesting"] boolean 
---@field ["note"] string|nil 

---@class Xiv_get_plugin_setup_status_result_verified_item
---@field ["internalName"] string|nil 
---@field ["version"] string|nil 
---@field ["loaded"] boolean 
---@field ["state"] string|nil 
---@field ["enabled"] boolean 

---@class Xiv_get_plugin_setup_status_result
---@field ["id"] string|nil 
---@field ["state"] string|nil 
---@field ["phase"] string|nil 
---@field ["plan"] Xiv_get_plugin_setup_status_result_plan|nil 
---@field ["verified"] (Xiv_get_plugin_setup_status_result_verified_item)[]|nil 
---@field ["error"] string|nil 
---@field ["updatedAt"] string 

---@class Xiv_get_plugin_stats_args
---@field ["limit"] integer|nil Maximum rows per list (1-200).

---@class Xiv_get_plugin_stats_result_draw_item
---@field ["internalName"] string|nil 
---@field ["name"] string|nil 
---@field ["lastMs"] number 
---@field ["averageMs"] number 
---@field ["maxMs"] number 

---@class Xiv_get_plugin_stats_result_framework_item
---@field ["handler"] string|nil 
---@field ["lastMs"] number 
---@field ["averageMs"] number 
---@field ["maxMs"] number 
---@field ["samples"] integer 

---@class Xiv_get_plugin_stats_result
---@field ["drawAvailable"] boolean 
---@field ["drawTrackingEnabled"] boolean|nil 
---@field ["draw"] (Xiv_get_plugin_stats_result_draw_item)[]|nil 
---@field ["frameworkAvailable"] boolean 
---@field ["frameworkTrackingEnabled"] boolean|nil 
---@field ["framework"] (Xiv_get_plugin_stats_result_framework_item)[]|nil 
---@field ["truncated"] boolean 

---@class Xiv_get_quest_args
---@field ["questId"] integer Quest id (Quest sheet row id, e.g. 65575; the short form 39 is also accepted).

---@class Xiv_get_quest_result_issuerLocation
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["mapId"] integer 
---@field ["x"] number|nil 
---@field ["y"] number|nil 
---@field ["region"] string|nil 

---@class Xiv_get_quest_result_previousQuests_item
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_quest_result_lockedBy_item
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_quest_result_rewards_currency
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 
---@field ["hq"] boolean|nil 

---@class Xiv_get_quest_result_rewards_items_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 
---@field ["hq"] boolean|nil 

---@class Xiv_get_quest_result_rewards_optionalItems_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 
---@field ["hq"] boolean|nil 

---@class Xiv_get_quest_result_rewards
---@field ["gil"] integer 
---@field ["currency"] Xiv_get_quest_result_rewards_currency|nil 
---@field ["items"] (Xiv_get_quest_result_rewards_items_item)[]|nil 
---@field ["optionalItems"] (Xiv_get_quest_result_rewards_optionalItems_item)[]|nil 
---@field ["emote"] string|nil 
---@field ["action"] string|nil 
---@field ["generalActions"] (string)[]|nil 
---@field ["instanceContentUnlock"] string|nil 
---@field ["other"] string|nil 

---@class Xiv_get_quest_result
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["internalId"] string|nil 
---@field ["level"] integer 
---@field ["classJobs"] string|nil 
---@field ["expansion"] string|nil 
---@field ["genre"] string|nil 
---@field ["category"] string|nil 
---@field ["section"] string|nil 
---@field ["placeName"] string|nil 
---@field ["issuerNpcId"] integer|nil 
---@field ["issuer"] string|nil 
---@field ["issuerLocation"] Xiv_get_quest_result_issuerLocation|nil 
---@field ["previousQuests"] (Xiv_get_quest_result_previousQuests_item)[]|nil 
---@field ["previousQuestsJoin"] string|nil 
---@field ["lockedBy"] (Xiv_get_quest_result_lockedBy_item)[]|nil 
---@field ["classJobUnlock"] string|nil 
---@field ["grandCompany"] string|nil 
---@field ["beastTribe"] string|nil 
---@field ["isRepeatable"] boolean 
---@field ["rewards"] Xiv_get_quest_result_rewards|nil 

---@class Xiv_get_quest_journal_args
---@field ["trackedOnly"] boolean|nil Only quests tracked on screen (the duty list).
---@field ["includeHidden"] boolean|nil Include quests the player has hidden in the journal.
---@field ["nameContains"] string|nil Case-insensitive quest name substring filter.
---@field ["limit"] integer|nil Maximum quests (1-500).
---@field ["offset"] integer|nil Quests to skip for paging.

---@class Xiv_get_quest_journal_result_allowances
---@field ["acceptedQuests"] integer 
---@field ["acceptedQuestLimit"] integer 
---@field ["acceptedDailyQuests"] integer 
---@field ["beastTribeAllowancesRemaining"] integer 
---@field ["beastTribeAllowancesPerDay"] integer 
---@field ["acceptedLeves"] integer 
---@field ["leveAllowances"] integer 
---@field ["nextLeveAllowancesUtc"] string|nil 

---@class Xiv_get_quest_journal_result_quests_item
---@field ["questId"] integer 
---@field ["name"] string|nil 
---@field ["sequence"] integer 
---@field ["readyToComplete"] boolean 
---@field ["objectives"] (string)[]|nil 
---@field ["objectiveResolved"] boolean 
---@field ["level"] integer|nil 
---@field ["genre"] string|nil 
---@field ["category"] string|nil 
---@field ["priority"] boolean 
---@field ["tracked"] boolean 
---@field ["hidden"] boolean|nil 
---@field ["daily"] boolean|nil 
---@field ["dailyCompleted"] boolean|nil 
---@field ["repeatable"] boolean|nil 
---@field ["acceptedAs"] string|nil 

---@class Xiv_get_quest_journal_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["allowances"] Xiv_get_quest_journal_result_allowances|nil 
---@field ["quests"] (Xiv_get_quest_journal_result_quests_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_quest_status_args
---@field ["questIds"] (integer)[] Quest ids, e.g. [70000, 69999].

---@class Xiv_get_quest_status_result_quests_item
---@field ["questId"] integer 
---@field ["name"] string|nil 
---@field ["exists"] boolean 
---@field ["completed"] boolean 
---@field ["accepted"] boolean 
---@field ["sequence"] integer|nil 
---@field ["repeatable"] boolean 

---@class Xiv_get_quest_status_result
---@field ["completed"] integer 
---@field ["accepted"] integer 
---@field ["quests"] (Xiv_get_quest_status_result_quests_item)[]|nil 

---@class Xiv_get_recipe_args
---@field ["itemId"] integer|nil Item id of the crafted result. Provide this or recipeId.
---@field ["recipeId"] integer|nil Recipe row id. Takes precedence over itemId.
---@field ["depth"] integer|nil How many levels of intermediate crafts to expand: 0 = direct ingredients only, up to 5.
---@field ["quantity"] integer|nil Number of finished items wanted; scales the shopping list.

---@class Xiv_get_recipe_result_ingredients_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["quantity"] integer 
---@field ["isCrystal"] boolean 
---@field ["recipeId"] integer|nil 
---@field ["craftType"] string|nil 
---@field ["crafts"] integer|nil 
---@field ["yield"] integer|nil 
---@field ["ingredients"] (any)[]|nil 

---@class Xiv_get_recipe_result_rawMaterials_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["quantity"] integer 
---@field ["isCrystal"] boolean 

---@class Xiv_get_recipe_result_intermediateCrafts_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["recipeId"] integer 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["crafts"] integer 
---@field ["quantity"] integer 

---@class Xiv_get_recipe_result_alternativeRecipes_item
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer 
---@field ["yield"] integer 
---@field ["isExpert"] boolean 
---@field ["requiresSpecialist"] boolean 
---@field ["masterBook"] string|nil 

---@class Xiv_get_recipe_result
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["yield"] integer 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["recipeLevel"] integer 
---@field ["stars"] integer 
---@field ["durability"] integer 
---@field ["difficulty"] integer 
---@field ["quality"] integer 
---@field ["requiredCraftsmanship"] integer 
---@field ["requiredControl"] integer 
---@field ["suggestedCraftsmanship"] integer 
---@field ["canHq"] boolean 
---@field ["canQuickSynth"] boolean 
---@field ["isExpert"] boolean 
---@field ["requiresSpecialist"] boolean 
---@field ["masterBook"] string|nil 
---@field ["masterBookItemId"] integer|nil 
---@field ["requiredItem"] string|nil 
---@field ["requiredStatus"] string|nil 
---@field ["depth"] integer 
---@field ["ingredients"] (Xiv_get_recipe_result_ingredients_item)[]|nil 
---@field ["rawMaterials"] (Xiv_get_recipe_result_rawMaterials_item)[]|nil 
---@field ["intermediateCrafts"] (Xiv_get_recipe_result_intermediateCrafts_item)[]|nil 
---@field ["alternativeRecipes"] (Xiv_get_recipe_result_alternativeRecipes_item)[]|nil 

---@class Xiv_get_recipe_tree_args
---@field ["itemId"] integer|nil Item id of the crafted result. Provide this or recipeId.
---@field ["recipeId"] integer|nil Recipe row id. Takes precedence over itemId; use it to pick a specific crafter when an item has several recipes.
---@field ["quantity"] integer|nil Number of finished items wanted.
---@field ["maxDepth"] integer|nil How many levels of sub-recipes to expand (1-10). The default expands everything in practice.
---@field ["includeTree"] boolean|nil false = omit the nested tree and return only the pooled lists (much smaller).

---@class Xiv_get_recipe_tree_result_tree_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["quantity"] integer 
---@field ["isCrystal"] boolean 
---@field ["recipeId"] integer|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer|nil 
---@field ["stars"] integer|nil 
---@field ["crafts"] integer|nil 
---@field ["yield"] integer|nil 
---@field ["notExpanded"] string|nil 
---@field ["ingredients"] (any)[]|nil 

---@class Xiv_get_recipe_tree_result_craftOrder_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["recipeId"] integer 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 
---@field ["crafts"] integer 
---@field ["needed"] integer 
---@field ["surplus"] integer 

---@class Xiv_get_recipe_tree_result_crafterRequirements_item
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 

---@class Xiv_get_recipe_tree_result_rawMaterials_item_vendor_location
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["mapId"] integer 
---@field ["x"] number|nil 
---@field ["y"] number|nil 
---@field ["region"] string|nil 

---@class Xiv_get_recipe_tree_result_rawMaterials_item_vendor
---@field ["npc"] string|nil 
---@field ["npcId"] integer 
---@field ["shop"] string|nil 
---@field ["shopId"] integer 
---@field ["priceGil"] integer 
---@field ["location"] Xiv_get_recipe_tree_result_rawMaterials_item_vendor_location|nil 

---@class Xiv_get_recipe_tree_result_rawMaterials_item_gathering
---@field ["type"] string|nil 
---@field ["level"] integer 
---@field ["zone"] string|nil 
---@field ["place"] string|nil 
---@field ["timed"] string|nil 
---@field ["totalPoints"] integer 

---@class Xiv_get_recipe_tree_result_rawMaterials_item_exchange_costs_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["count"] integer 

---@class Xiv_get_recipe_tree_result_rawMaterials_item_exchange
---@field ["shop"] string|nil 
---@field ["shopId"] integer 
---@field ["receiveCount"] integer 
---@field ["costs"] (Xiv_get_recipe_tree_result_rawMaterials_item_exchange_costs_item)[]|nil 
---@field ["npcs"] (string)[]|nil 

---@class Xiv_get_recipe_tree_result_rawMaterials_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["quantity"] integer 
---@field ["sources"] (string)[]|nil 
---@field ["gilPriceEach"] integer|nil 
---@field ["gilTotal"] integer|nil 
---@field ["vendor"] Xiv_get_recipe_tree_result_rawMaterials_item_vendor|nil 
---@field ["gathering"] Xiv_get_recipe_tree_result_rawMaterials_item_gathering|nil 
---@field ["exchange"] Xiv_get_recipe_tree_result_rawMaterials_item_exchange|nil 
---@field ["gcSealsEach"] integer|nil 
---@field ["craftableRecipeId"] integer|nil 

---@class Xiv_get_recipe_tree_result_crystals_item
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["quantity"] integer 
---@field ["isCrystal"] boolean 

---@class Xiv_get_recipe_tree_result_alternativeRecipes_item
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 
---@field ["quantity"] integer|nil 
---@field ["yield"] integer|nil 

---@class Xiv_get_recipe_tree_result
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer|nil 
---@field ["yield"] integer 
---@field ["quantity"] integer 
---@field ["crafts"] integer 
---@field ["surplus"] integer 
---@field ["maxDepth"] integer 
---@field ["nodeCount"] integer 
---@field ["depthLimited"] boolean 
---@field ["nodeCapHit"] boolean 
---@field ["hasCycle"] boolean 
---@field ["tree"] (Xiv_get_recipe_tree_result_tree_item)[]|nil 
---@field ["craftOrder"] (Xiv_get_recipe_tree_result_craftOrder_item)[]|nil 
---@field ["crafterRequirements"] (Xiv_get_recipe_tree_result_crafterRequirements_item)[]|nil 
---@field ["rawMaterials"] (Xiv_get_recipe_tree_result_rawMaterials_item)[]|nil 
---@field ["crystals"] (Xiv_get_recipe_tree_result_crystals_item)[]|nil 
---@field ["gilForVendorMaterials"] integer 
---@field ["alternativeRecipes"] (Xiv_get_recipe_tree_result_alternativeRecipes_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_retainers_result_retainers_item_venture
---@field ["ventureId"] integer 
---@field ["name"] string|nil 
---@field ["completesAt"] string|nil 
---@field ["complete"] boolean 
---@field ["minutesRemaining"] integer|nil 

---@class Xiv_get_retainers_result_retainers_item
---@field ["retainerId"] string|nil 
---@field ["name"] string|nil 
---@field ["available"] boolean 
---@field ["classJob"] string|nil 
---@field ["level"] integer 
---@field ["gil"] integer 
---@field ["itemCount"] integer 
---@field ["marketItemCount"] integer 
---@field ["marketExpiresAt"] string|nil 
---@field ["town"] string|nil 
---@field ["venture"] Xiv_get_retainers_result_retainers_item_venture|nil 

---@class Xiv_get_retainers_result
---@field ["loaded"] boolean 
---@field ["note"] string|nil 
---@field ["maxRetainers"] integer 
---@field ["activeRetainer"] string|nil 
---@field ["retainers"] (Xiv_get_retainers_result_retainers_item)[]|nil 

---@class Xiv_get_roulette_status_args
---@field ["unclaimedOnly"] boolean|nil Only roulettes still worth running today.
---@field ["includeHidden"] boolean|nil Include roulettes that are not offered in the Duty Finder list.

---@class Xiv_get_roulette_status_result_roulettes_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["requiredLevel"] integer 
---@field ["bonusClaimed"] boolean 
---@field ["inDutyFinder"] boolean 

---@class Xiv_get_roulette_status_result
---@field ["total"] integer 
---@field ["bonusClaimed"] integer 
---@field ["bonusAvailable"] integer 
---@field ["nextDailyResetUtc"] string 
---@field ["secondsUntilReset"] integer 
---@field ["roulettes"] (Xiv_get_roulette_status_result_roulettes_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_server_info_result_permissions
---@field ["read"] boolean 
---@field ["ui"] boolean 
---@field ["action"] boolean 
---@field ["chat"] boolean 
---@field ["confirmActions"] boolean 
---@field ["note"] string|nil 

---@class Xiv_get_server_info_result_categories_item
---@field ["name"] string|nil 
---@field ["enabled"] boolean 
---@field ["tools"] integer 
---@field ["failedProviders"] integer 

---@class Xiv_get_server_info_result_clientBudgets_item
---@field ["client"] string|nil 
---@field ["authenticated"] boolean 
---@field ["callsInWindow"] integer 
---@field ["limitPerMinute"] integer 
---@field ["burstUsed"] number 
---@field ["burstCapacity"] integer 
---@field ["windowSecondsRemaining"] number 

---@class Xiv_get_server_info_result
---@field ["name"] string|nil 
---@field ["version"] string|nil 
---@field ["endpoint"] string|nil 
---@field ["transport"] string|nil 
---@field ["running"] boolean 
---@field ["startedAt"] string|nil 
---@field ["activeSessions"] integer 
---@field ["connectedClients"] (string)[]|nil 
---@field ["yourClient"] string|nil 
---@field ["yourSessionId"] string|nil 
---@field ["permissions"] Xiv_get_server_info_result_permissions|nil 
---@field ["registeredTools"] integer 
---@field ["availableTools"] integer 
---@field ["categories"] (Xiv_get_server_info_result_categories_item)[]|nil 
---@field ["dalamudVersion"] string|nil 
---@field ["gameVersion"] string|nil 
---@field ["clientLanguage"] string|nil 
---@field ["loggedIn"] boolean 
---@field ["protocolVersion"] string|nil 
---@field ["host"] string|nil 
---@field ["gameRunning"] boolean 
---@field ["catalogueVersion"] integer 
---@field ["staticTools"] integer 
---@field ["rateLimitPerMinute"] integer 
---@field ["clientBudgets"] (Xiv_get_server_info_result_clientBudgets_item)[]|nil 

---@class Xiv_get_sheet_row_args
---@field ["sheet"] string Sheet name, case-insensitive (e.g. "Mount", "TerritoryType", "ClassJob"). See list_sheets.
---@field ["rowId"] integer Row id.
---@field ["subrowId"] integer|nil Subrow id for subrow sheets (default 0).
---@field ["columns"] (string)[]|nil Only include these column names (case-insensitive).
---@field ["includeUnknown"] boolean|nil Include columns named Unknown*.

---@class Xiv_get_sheet_row_result
---@field ["sheet"] string|nil 
---@field ["rowId"] integer 
---@field ["subrowId"] integer|nil 
---@field ["subrowCount"] integer|nil 
---@field ["row"] table<string, any>|nil 

---@class Xiv_get_target_args
---@field ["statusLimit"] integer|nil Maximum statuses listed per object (0-60).

---@class Xiv_get_target_result_target_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_target_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_target_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_target_result_target_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_target_currentWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_target_onlineStatus
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_target_result_target_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_target_result_target_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_target_result_target_rotation
---@field ["radians"] number 
---@field ["headingDegrees"] number 
---@field ["compass"] string|nil 

---@class Xiv_get_target_result_target_cast
---@field ["actionId"] integer 
---@field ["actionType"] string|nil 
---@field ["actionName"] string|nil 
---@field ["elapsedSeconds"] number 
---@field ["totalSeconds"] number 
---@field ["remainingSeconds"] number 
---@field ["interruptible"] boolean 
---@field ["targetGameObjectId"] string|nil 

---@class Xiv_get_target_result_target_statuses_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["param"] integer 
---@field ["stacks"] integer|nil 
---@field ["remainingSeconds"] number|nil 
---@field ["isPermanent"] boolean 
---@field ["sourceEntityId"] integer|nil 
---@field ["sourceName"] string|nil 

---@class Xiv_get_target_result_target
---@field ["kind"] string|nil 
---@field ["subKind"] string|nil 
---@field ["name"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["gameObjectId"] string|nil 
---@field ["baseId"] integer 
---@field ["nameId"] integer|nil 
---@field ["objectIndex"] integer 
---@field ["level"] integer|nil 
---@field ["hp"] Xiv_get_target_result_target_hp|nil 
---@field ["mp"] Xiv_get_target_result_target_mp|nil 
---@field ["shieldPercent"] integer|nil 
---@field ["job"] Xiv_get_target_result_target_job|nil 
---@field ["homeWorld"] Xiv_get_target_result_target_homeWorld|nil 
---@field ["currentWorld"] Xiv_get_target_result_target_currentWorld|nil 
---@field ["freeCompanyTag"] string|nil 
---@field ["onlineStatus"] Xiv_get_target_result_target_onlineStatus|nil 
---@field ["distance"] number 
---@field ["horizontalDistance"] number 
---@field ["edgeDistance"] number|nil 
---@field ["hitboxRadius"] number 
---@field ["position"] Xiv_get_target_result_target_position|nil 
---@field ["mapCoordinates"] Xiv_get_target_result_target_mapCoordinates|nil 
---@field ["rotation"] Xiv_get_target_result_target_rotation|nil 
---@field ["isTargetable"] boolean 
---@field ["isDead"] boolean|nil 
---@field ["isHostile"] boolean|nil 
---@field ["inCombat"] boolean|nil 
---@field ["isPartyMember"] boolean|nil 
---@field ["isAllianceMember"] boolean|nil 
---@field ["isFriend"] boolean|nil 
---@field ["ownerEntityId"] integer|nil 
---@field ["targetGameObjectId"] string|nil 
---@field ["targetName"] string|nil 
---@field ["cast"] Xiv_get_target_result_target_cast|nil 
---@field ["statusCount"] integer|nil 
---@field ["statuses"] (Xiv_get_target_result_target_statuses_item)[]|nil 
---@field ["statusesTruncated"] boolean|nil 

---@class Xiv_get_target_result_targetOfTarget_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_targetOfTarget_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_targetOfTarget_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_target_result_targetOfTarget_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_targetOfTarget_currentWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_targetOfTarget_onlineStatus
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_target_result_targetOfTarget_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_target_result_targetOfTarget_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_target_result_targetOfTarget_rotation
---@field ["radians"] number 
---@field ["headingDegrees"] number 
---@field ["compass"] string|nil 

---@class Xiv_get_target_result_targetOfTarget_cast
---@field ["actionId"] integer 
---@field ["actionType"] string|nil 
---@field ["actionName"] string|nil 
---@field ["elapsedSeconds"] number 
---@field ["totalSeconds"] number 
---@field ["remainingSeconds"] number 
---@field ["interruptible"] boolean 
---@field ["targetGameObjectId"] string|nil 

---@class Xiv_get_target_result_targetOfTarget_statuses_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["param"] integer 
---@field ["stacks"] integer|nil 
---@field ["remainingSeconds"] number|nil 
---@field ["isPermanent"] boolean 
---@field ["sourceEntityId"] integer|nil 
---@field ["sourceName"] string|nil 

---@class Xiv_get_target_result_targetOfTarget
---@field ["kind"] string|nil 
---@field ["subKind"] string|nil 
---@field ["name"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["gameObjectId"] string|nil 
---@field ["baseId"] integer 
---@field ["nameId"] integer|nil 
---@field ["objectIndex"] integer 
---@field ["level"] integer|nil 
---@field ["hp"] Xiv_get_target_result_targetOfTarget_hp|nil 
---@field ["mp"] Xiv_get_target_result_targetOfTarget_mp|nil 
---@field ["shieldPercent"] integer|nil 
---@field ["job"] Xiv_get_target_result_targetOfTarget_job|nil 
---@field ["homeWorld"] Xiv_get_target_result_targetOfTarget_homeWorld|nil 
---@field ["currentWorld"] Xiv_get_target_result_targetOfTarget_currentWorld|nil 
---@field ["freeCompanyTag"] string|nil 
---@field ["onlineStatus"] Xiv_get_target_result_targetOfTarget_onlineStatus|nil 
---@field ["distance"] number 
---@field ["horizontalDistance"] number 
---@field ["edgeDistance"] number|nil 
---@field ["hitboxRadius"] number 
---@field ["position"] Xiv_get_target_result_targetOfTarget_position|nil 
---@field ["mapCoordinates"] Xiv_get_target_result_targetOfTarget_mapCoordinates|nil 
---@field ["rotation"] Xiv_get_target_result_targetOfTarget_rotation|nil 
---@field ["isTargetable"] boolean 
---@field ["isDead"] boolean|nil 
---@field ["isHostile"] boolean|nil 
---@field ["inCombat"] boolean|nil 
---@field ["isPartyMember"] boolean|nil 
---@field ["isAllianceMember"] boolean|nil 
---@field ["isFriend"] boolean|nil 
---@field ["ownerEntityId"] integer|nil 
---@field ["targetGameObjectId"] string|nil 
---@field ["targetName"] string|nil 
---@field ["cast"] Xiv_get_target_result_targetOfTarget_cast|nil 
---@field ["statusCount"] integer|nil 
---@field ["statuses"] (Xiv_get_target_result_targetOfTarget_statuses_item)[]|nil 
---@field ["statusesTruncated"] boolean|nil 

---@class Xiv_get_target_result_softTarget_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_softTarget_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_softTarget_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_target_result_softTarget_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_softTarget_currentWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_softTarget_onlineStatus
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_target_result_softTarget_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_target_result_softTarget_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_target_result_softTarget_rotation
---@field ["radians"] number 
---@field ["headingDegrees"] number 
---@field ["compass"] string|nil 

---@class Xiv_get_target_result_softTarget_cast
---@field ["actionId"] integer 
---@field ["actionType"] string|nil 
---@field ["actionName"] string|nil 
---@field ["elapsedSeconds"] number 
---@field ["totalSeconds"] number 
---@field ["remainingSeconds"] number 
---@field ["interruptible"] boolean 
---@field ["targetGameObjectId"] string|nil 

---@class Xiv_get_target_result_softTarget_statuses_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["param"] integer 
---@field ["stacks"] integer|nil 
---@field ["remainingSeconds"] number|nil 
---@field ["isPermanent"] boolean 
---@field ["sourceEntityId"] integer|nil 
---@field ["sourceName"] string|nil 

---@class Xiv_get_target_result_softTarget
---@field ["kind"] string|nil 
---@field ["subKind"] string|nil 
---@field ["name"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["gameObjectId"] string|nil 
---@field ["baseId"] integer 
---@field ["nameId"] integer|nil 
---@field ["objectIndex"] integer 
---@field ["level"] integer|nil 
---@field ["hp"] Xiv_get_target_result_softTarget_hp|nil 
---@field ["mp"] Xiv_get_target_result_softTarget_mp|nil 
---@field ["shieldPercent"] integer|nil 
---@field ["job"] Xiv_get_target_result_softTarget_job|nil 
---@field ["homeWorld"] Xiv_get_target_result_softTarget_homeWorld|nil 
---@field ["currentWorld"] Xiv_get_target_result_softTarget_currentWorld|nil 
---@field ["freeCompanyTag"] string|nil 
---@field ["onlineStatus"] Xiv_get_target_result_softTarget_onlineStatus|nil 
---@field ["distance"] number 
---@field ["horizontalDistance"] number 
---@field ["edgeDistance"] number|nil 
---@field ["hitboxRadius"] number 
---@field ["position"] Xiv_get_target_result_softTarget_position|nil 
---@field ["mapCoordinates"] Xiv_get_target_result_softTarget_mapCoordinates|nil 
---@field ["rotation"] Xiv_get_target_result_softTarget_rotation|nil 
---@field ["isTargetable"] boolean 
---@field ["isDead"] boolean|nil 
---@field ["isHostile"] boolean|nil 
---@field ["inCombat"] boolean|nil 
---@field ["isPartyMember"] boolean|nil 
---@field ["isAllianceMember"] boolean|nil 
---@field ["isFriend"] boolean|nil 
---@field ["ownerEntityId"] integer|nil 
---@field ["targetGameObjectId"] string|nil 
---@field ["targetName"] string|nil 
---@field ["cast"] Xiv_get_target_result_softTarget_cast|nil 
---@field ["statusCount"] integer|nil 
---@field ["statuses"] (Xiv_get_target_result_softTarget_statuses_item)[]|nil 
---@field ["statusesTruncated"] boolean|nil 

---@class Xiv_get_target_result_focusTarget_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_focusTarget_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_focusTarget_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_target_result_focusTarget_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_focusTarget_currentWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_focusTarget_onlineStatus
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_target_result_focusTarget_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_target_result_focusTarget_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_target_result_focusTarget_rotation
---@field ["radians"] number 
---@field ["headingDegrees"] number 
---@field ["compass"] string|nil 

---@class Xiv_get_target_result_focusTarget_cast
---@field ["actionId"] integer 
---@field ["actionType"] string|nil 
---@field ["actionName"] string|nil 
---@field ["elapsedSeconds"] number 
---@field ["totalSeconds"] number 
---@field ["remainingSeconds"] number 
---@field ["interruptible"] boolean 
---@field ["targetGameObjectId"] string|nil 

---@class Xiv_get_target_result_focusTarget_statuses_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["param"] integer 
---@field ["stacks"] integer|nil 
---@field ["remainingSeconds"] number|nil 
---@field ["isPermanent"] boolean 
---@field ["sourceEntityId"] integer|nil 
---@field ["sourceName"] string|nil 

---@class Xiv_get_target_result_focusTarget
---@field ["kind"] string|nil 
---@field ["subKind"] string|nil 
---@field ["name"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["gameObjectId"] string|nil 
---@field ["baseId"] integer 
---@field ["nameId"] integer|nil 
---@field ["objectIndex"] integer 
---@field ["level"] integer|nil 
---@field ["hp"] Xiv_get_target_result_focusTarget_hp|nil 
---@field ["mp"] Xiv_get_target_result_focusTarget_mp|nil 
---@field ["shieldPercent"] integer|nil 
---@field ["job"] Xiv_get_target_result_focusTarget_job|nil 
---@field ["homeWorld"] Xiv_get_target_result_focusTarget_homeWorld|nil 
---@field ["currentWorld"] Xiv_get_target_result_focusTarget_currentWorld|nil 
---@field ["freeCompanyTag"] string|nil 
---@field ["onlineStatus"] Xiv_get_target_result_focusTarget_onlineStatus|nil 
---@field ["distance"] number 
---@field ["horizontalDistance"] number 
---@field ["edgeDistance"] number|nil 
---@field ["hitboxRadius"] number 
---@field ["position"] Xiv_get_target_result_focusTarget_position|nil 
---@field ["mapCoordinates"] Xiv_get_target_result_focusTarget_mapCoordinates|nil 
---@field ["rotation"] Xiv_get_target_result_focusTarget_rotation|nil 
---@field ["isTargetable"] boolean 
---@field ["isDead"] boolean|nil 
---@field ["isHostile"] boolean|nil 
---@field ["inCombat"] boolean|nil 
---@field ["isPartyMember"] boolean|nil 
---@field ["isAllianceMember"] boolean|nil 
---@field ["isFriend"] boolean|nil 
---@field ["ownerEntityId"] integer|nil 
---@field ["targetGameObjectId"] string|nil 
---@field ["targetName"] string|nil 
---@field ["cast"] Xiv_get_target_result_focusTarget_cast|nil 
---@field ["statusCount"] integer|nil 
---@field ["statuses"] (Xiv_get_target_result_focusTarget_statuses_item)[]|nil 
---@field ["statusesTruncated"] boolean|nil 

---@class Xiv_get_target_result_mouseOver_hp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_mouseOver_mp
---@field ["current"] integer 
---@field ["max"] integer 
---@field ["percent"] number 

---@class Xiv_get_target_result_mouseOver_job
---@field ["id"] integer 
---@field ["abbreviation"] string|nil 
---@field ["name"] string|nil 
---@field ["role"] string|nil 

---@class Xiv_get_target_result_mouseOver_homeWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_mouseOver_currentWorld
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 

---@class Xiv_get_target_result_mouseOver_onlineStatus
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_target_result_mouseOver_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_get_target_result_mouseOver_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_target_result_mouseOver_rotation
---@field ["radians"] number 
---@field ["headingDegrees"] number 
---@field ["compass"] string|nil 

---@class Xiv_get_target_result_mouseOver_cast
---@field ["actionId"] integer 
---@field ["actionType"] string|nil 
---@field ["actionName"] string|nil 
---@field ["elapsedSeconds"] number 
---@field ["totalSeconds"] number 
---@field ["remainingSeconds"] number 
---@field ["interruptible"] boolean 
---@field ["targetGameObjectId"] string|nil 

---@class Xiv_get_target_result_mouseOver_statuses_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["param"] integer 
---@field ["stacks"] integer|nil 
---@field ["remainingSeconds"] number|nil 
---@field ["isPermanent"] boolean 
---@field ["sourceEntityId"] integer|nil 
---@field ["sourceName"] string|nil 

---@class Xiv_get_target_result_mouseOver
---@field ["kind"] string|nil 
---@field ["subKind"] string|nil 
---@field ["name"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["gameObjectId"] string|nil 
---@field ["baseId"] integer 
---@field ["nameId"] integer|nil 
---@field ["objectIndex"] integer 
---@field ["level"] integer|nil 
---@field ["hp"] Xiv_get_target_result_mouseOver_hp|nil 
---@field ["mp"] Xiv_get_target_result_mouseOver_mp|nil 
---@field ["shieldPercent"] integer|nil 
---@field ["job"] Xiv_get_target_result_mouseOver_job|nil 
---@field ["homeWorld"] Xiv_get_target_result_mouseOver_homeWorld|nil 
---@field ["currentWorld"] Xiv_get_target_result_mouseOver_currentWorld|nil 
---@field ["freeCompanyTag"] string|nil 
---@field ["onlineStatus"] Xiv_get_target_result_mouseOver_onlineStatus|nil 
---@field ["distance"] number 
---@field ["horizontalDistance"] number 
---@field ["edgeDistance"] number|nil 
---@field ["hitboxRadius"] number 
---@field ["position"] Xiv_get_target_result_mouseOver_position|nil 
---@field ["mapCoordinates"] Xiv_get_target_result_mouseOver_mapCoordinates|nil 
---@field ["rotation"] Xiv_get_target_result_mouseOver_rotation|nil 
---@field ["isTargetable"] boolean 
---@field ["isDead"] boolean|nil 
---@field ["isHostile"] boolean|nil 
---@field ["inCombat"] boolean|nil 
---@field ["isPartyMember"] boolean|nil 
---@field ["isAllianceMember"] boolean|nil 
---@field ["isFriend"] boolean|nil 
---@field ["ownerEntityId"] integer|nil 
---@field ["targetGameObjectId"] string|nil 
---@field ["targetName"] string|nil 
---@field ["cast"] Xiv_get_target_result_mouseOver_cast|nil 
---@field ["statusCount"] integer|nil 
---@field ["statuses"] (Xiv_get_target_result_mouseOver_statuses_item)[]|nil 
---@field ["statusesTruncated"] boolean|nil 

---@class Xiv_get_target_result
---@field ["hasTarget"] boolean 
---@field ["target"] Xiv_get_target_result_target|nil 
---@field ["targetOfTarget"] Xiv_get_target_result_targetOfTarget|nil 
---@field ["softTarget"] Xiv_get_target_result_softTarget|nil 
---@field ["focusTarget"] Xiv_get_target_result_focusTarget|nil 
---@field ["mouseOver"] Xiv_get_target_result_mouseOver|nil 

---@class Xiv_get_terminal_capture_status_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_terminal_layout_result_panels_item
---@field ["id"] integer 
---@field ["kind"] string|nil 
---@field ["title"] string|nil 
---@field ["profile"] string|nil 
---@field ["app"] string|nil 
---@field ["view"] string|nil 
---@field ["order"] integer|nil 
---@field ["pin"] string|nil 
---@field ["reproducible"] boolean 
---@field ["how"] string|nil 

---@class Xiv_get_terminal_layout_result
---@field ["rev"] integer|nil 
---@field ["total"] integer 
---@field ["reproducible"] integer 
---@field ["truncated"] boolean 
---@field ["panels"] (Xiv_get_terminal_layout_result_panels_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_terminal_layouts_args
---@field ["name"] string|nil Only this layout. Omit for all.

---@class Xiv_get_terminal_layouts_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_terminal_leakwatch_report_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_terminal_request_args
---@field ["request"] string Request id as returned in a change tool's request field (digits).

---@class Xiv_get_terminal_request_result
---@field ["request"] string|nil 
---@field ["state"] string|nil 
---@field ["method"] string|nil 
---@field ["ok"] boolean|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_terminal_selftest_report_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_get_terminal_status_result
---@field ["status"] string|nil 
---@field ["agent"] any|nil Any JSON value.
---@field ["focus"] any|nil Any JSON value.
---@field ["api"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_get_ticket_args
---@field ["id"] string Ticket id from request_action, e.g. "t_0123abcd4567ef89".

---@class Xiv_get_ticket_result
---@field ["id"] string|nil 
---@field ["state"] string|nil 
---@field ["tool"] string|nil 
---@field ["tier"] string|nil 
---@field ["reason"] string|nil 
---@field ["resumeToken"] string|nil 
---@field ["client"] string|nil 
---@field ["createdAt"] string 
---@field ["expiresAt"] string|nil 
---@field ["decidedBy"] string|nil 
---@field ["decidedAt"] string|nil 
---@field ["completedAt"] string|nil 
---@field ["queuePosition"] integer|nil 
---@field ["arguments"] any|nil Any JSON value.
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["uri"] string|nil 

---@class Xiv_get_time_result_eorzea
---@field ["time"] string|nil 
---@field ["hour"] integer 
---@field ["minute"] integer 
---@field ["bell"] integer 
---@field ["isDaytime"] boolean 
---@field ["year"] integer 
---@field ["month"] integer 
---@field ["monthName"] string|nil 
---@field ["day"] integer 
---@field ["moonPhase"] string|nil 
---@field ["isOverridden"] boolean 
---@field ["secondsUntilNextBell"] number 
---@field ["secondsUntilNextWeatherChange"] number 

---@class Xiv_get_time_result_resets_item
---@field ["name"] string|nil 
---@field ["description"] string|nil 
---@field ["nextUtc"] string 
---@field ["secondsUntil"] integer 

---@class Xiv_get_time_result
---@field ["eorzea"] Xiv_get_time_result_eorzea|nil 
---@field ["serverTimeUtc"] string 
---@field ["serverTimeFromGame"] boolean 
---@field ["localTime"] string 
---@field ["localTimeZone"] string|nil 
---@field ["resets"] (Xiv_get_time_result_resets_item)[]|nil 

---@class Xiv_get_troubleshooting_summary_result_logErrorsLastHour_item
---@field ["plugin"] string|nil 
---@field ["errors"] integer 

---@class Xiv_get_troubleshooting_summary_result
---@field ["dalamudVersion"] string|nil 
---@field ["dalamudTrack"] string|nil 
---@field ["dalamudApiLevel"] integer|nil 
---@field ["gameVersion"] string|nil 
---@field ["clientLanguage"] string|nil 
---@field ["dalamudUiLanguage"] string|nil 
---@field ["hostPlatform"] string|nil 
---@field ["isWine"] boolean 
---@field ["pluginSafeMode"] boolean|nil 
---@field ["installedPlugins"] integer 
---@field ["loadedPlugins"] integer 
---@field ["thirdPartyPlugins"] integer 
---@field ["devPlugins"] integer 
---@field ["testingPlugins"] integer 
---@field ["notLoaded"] (string)[]|nil 
---@field ["failedToLoad"] (string)[]|nil 
---@field ["outdated"] (string)[]|nil 
---@field ["orphaned"] (string)[]|nil 
---@field ["banned"] (string)[]|nil 
---@field ["decommissioned"] (string)[]|nil 
---@field ["updateAvailable"] (string)[]|nil 
---@field ["logAvailable"] boolean 
---@field ["logErrorsLastHour"] (Xiv_get_troubleshooting_summary_result_logErrorsLastHour_item)[]|nil 
---@field ["customRepositoryCount"] integer|nil 
---@field ["enabledCustomRepositoryCount"] integer|nil 

---@class Xiv_get_ui_info_result
---@field ["globalScale"] number|nil 
---@field ["defaultFont"] string|nil 
---@field ["defaultFontSizePx"] number|nil 
---@field ["defaultFontSizePt"] number|nil 
---@field ["defaultFontLineHeightPx"] number|nil 
---@field ["usesGameFont"] boolean|nil 
---@field ["styleName"] string|nil 
---@field ["disableAutomaticUiHide"] boolean 
---@field ["disableUserUiHide"] boolean 
---@field ["disableCutsceneUiHide"] boolean 
---@field ["disableGposeUiHide"] boolean 

---@class Xiv_get_wayfinder_journey_result
---@field ["journey"] any Any JSON value.
---@field ["guidance"] any Any JSON value.

---@class Xiv_get_weather_forecast_args
---@field ["territoryId"] integer|nil TerritoryType row id. Omit for the player's current zone.
---@field ["count"] integer|nil Number of 8-bell weather windows to return, starting with the current one (1-24). Default 6.

---@class Xiv_get_weather_forecast_result_currentWeatherInGame
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_weather_forecast_result_possibleWeather_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["chancePercent"] integer 

---@class Xiv_get_weather_forecast_result_forecast_item
---@field ["weatherId"] integer 
---@field ["name"] string|nil 
---@field ["startUtc"] string 
---@field ["endUtc"] string 
---@field ["eorzeaStart"] string|nil 
---@field ["secondsUntilStart"] integer 
---@field ["isCurrent"] boolean 

---@class Xiv_get_weather_forecast_result
---@field ["territoryId"] integer 
---@field ["territoryName"] string|nil 
---@field ["weatherRateId"] integer 
---@field ["currentWeatherInGame"] Xiv_get_weather_forecast_result_currentWeatherInGame|nil 
---@field ["possibleWeather"] (Xiv_get_weather_forecast_result_possibleWeather_item)[]|nil 
---@field ["forecast"] (Xiv_get_weather_forecast_result_forecast_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_get_zone_info_args
---@field ["territoryId"] integer|nil TerritoryType row id. Provide this or zone.
---@field ["zone"] string|nil Zone name (any case); must identify one zone name. Ignored when territoryId is given.
---@field ["markerLimit"] integer|nil Maximum map markers to return (0-200).
---@field ["markerOffset"] integer|nil Map markers to skip for paging.

---@class Xiv_get_zone_info_result_duty
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_zone_info_result_maps_item
---@field ["mapId"] integer 
---@field ["path"] string|nil 
---@field ["name"] string|nil 
---@field ["subName"] string|nil 
---@field ["sizeFactor"] integer 
---@field ["offsetX"] integer 
---@field ["offsetY"] integer 
---@field ["isDefault"] boolean 

---@class Xiv_get_zone_info_result_aetherytes_item
---@field ["aetheryteId"] integer 
---@field ["name"] string|nil 
---@field ["isShard"] boolean 
---@field ["mapId"] integer|nil 
---@field ["x"] number|nil 
---@field ["y"] number|nil 
---@field ["aethernetGroup"] integer 

---@class Xiv_get_zone_info_result_weather_item
---@field ["weatherId"] integer 
---@field ["name"] string|nil 
---@field ["chancePercent"] integer 

---@class Xiv_get_zone_info_result_markers_results_item
---@field ["name"] string|nil 
---@field ["mapId"] integer 
---@field ["x"] number 
---@field ["y"] number 
---@field ["icon"] integer 
---@field ["dataType"] integer 

---@class Xiv_get_zone_info_result_markers
---@field ["total"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_get_zone_info_result_markers_results_item)[]|nil 

---@class Xiv_get_zone_info_result
---@field ["territoryId"] integer 
---@field ["name"] string|nil 
---@field ["region"] string|nil 
---@field ["zoneName"] string|nil 
---@field ["internalName"] string|nil 
---@field ["kind"] string|nil 
---@field ["intendedUse"] integer 
---@field ["expansion"] string|nil 
---@field ["duty"] Xiv_get_zone_info_result_duty|nil 
---@field ["isPvp"] boolean 
---@field ["mountsAllowed"] boolean 
---@field ["maps"] (Xiv_get_zone_info_result_maps_item)[]|nil 
---@field ["aetherytes"] (Xiv_get_zone_info_result_aetherytes_item)[]|nil 
---@field ["weatherRateId"] integer 
---@field ["weather"] (Xiv_get_zone_info_result_weather_item)[]|nil 
---@field ["markers"] Xiv_get_zone_info_result_markers|nil 

---@class Xiv_get_zone_live_args
---@field ["topFates"] integer|nil How many of the nearest active FATEs to include (0-25).

---@class Xiv_get_zone_live_result_map
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_zone_live_result_weather
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_zone_live_result_playerMapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_zone_live_result_duty
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_get_zone_live_result_housing
---@field ["area"] string|nil 
---@field ["ward"] integer|nil 
---@field ["plot"] integer|nil 
---@field ["room"] integer|nil 
---@field ["inside"] boolean 

---@class Xiv_get_zone_live_result_fates_nearest_item_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_get_zone_live_result_fates_nearest_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["level"] integer 
---@field ["state"] string|nil 
---@field ["progressPercent"] integer 
---@field ["timeRemainingSeconds"] integer|nil 
---@field ["hasBonus"] boolean|nil 
---@field ["mapCoordinates"] Xiv_get_zone_live_result_fates_nearest_item_mapCoordinates|nil 
---@field ["distance"] number 
---@field ["playerIsIn"] boolean|nil 

---@class Xiv_get_zone_live_result_fates
---@field ["active"] integer 
---@field ["currentFateId"] integer|nil 
---@field ["nearest"] (Xiv_get_zone_live_result_fates_nearest_item)[]|nil 

---@class Xiv_get_zone_live_result_aetherytes_item
---@field ["aetheryteId"] integer 
---@field ["name"] string|nil 
---@field ["gilCost"] integer 
---@field ["isHomePoint"] boolean|nil 
---@field ["isFavourite"] boolean|nil 

---@class Xiv_get_zone_live_result
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["region"] string|nil 
---@field ["intendedUse"] string|nil 
---@field ["map"] Xiv_get_zone_live_result_map|nil 
---@field ["area"] string|nil 
---@field ["subArea"] string|nil 
---@field ["instance"] integer|nil 
---@field ["isInstancedZone"] boolean 
---@field ["weather"] Xiv_get_zone_live_result_weather|nil 
---@field ["playerMapCoordinates"] Xiv_get_zone_live_result_playerMapCoordinates|nil 
---@field ["inSanctuary"] boolean 
---@field ["inDuty"] boolean 
---@field ["duty"] Xiv_get_zone_live_result_duty|nil 
---@field ["inHousingDistrict"] boolean 
---@field ["housing"] Xiv_get_zone_live_result_housing|nil 
---@field ["isPvp"] boolean 
---@field ["canFly"] boolean 
---@field ["fates"] Xiv_get_zone_live_result_fates|nil 
---@field ["attunedAetherytesHere"] integer 
---@field ["aetherytes"] (Xiv_get_zone_live_result_aetherytes_item)[]|nil 
---@field ["nearestAetheryte"] string|nil 
---@field ["unavailable"] (string)[]|nil 

---@class Xiv_ghostty_command_args
---@field ["method"] "window.open"|"window.close"|"window.focus"|"window.hide"|"window.toggle_pet"|"window.place"|"terminal.new"|"focus.cycle"|"agent.windows.refresh" Command verb.
---@field ["parameters"] string|nil Parameters as a JSON object, e.g. {"id": 3} or {"run": "btop", "pin": "orbit 3"}. Omit when the verb takes none.

---@class Xiv_ghostty_command_result
---@field ["bridge"] string|nil 
---@field ["method"] string|nil 
---@field ["ok"] boolean 
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["raw"] string|nil 

---@class Xiv_ghostty_query_args
---@field ["method"] "window.list"|"agent.status"|"agent.windows"|"agent.apps"|"focus.get"|"status"|nil Read verb.

---@class Xiv_ghostty_query_result
---@field ["bridge"] string|nil 
---@field ["method"] string|nil 
---@field ["ok"] boolean 
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["raw"] string|nil 

---@class Xiv_launch_desktop_app_args
---@field ["app"] string Desktop-file id (preferred) or search text; shown verbatim to the player.

---@class Xiv_launch_desktop_app_result_launch
---@field ["gate"] string|nil 
---@field ["ok"] boolean 
---@field ["message"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_launch_desktop_app_result
---@field ["launch"] Xiv_launch_desktop_app_result_launch|nil 
---@field ["observed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["note"] string|nil 

---@class Xiv_laya_query_args
---@field ["state"] string State/context Laya should reason over.
---@field ["questions"] string JSON object of JEV/Laya questions, e.g. {"safe":{"type":"noul","instructions":"Is this safe?"}}.
---@field ["endpoint"] string|nil Optional Laya /v1/systemone endpoint. Loopback is the default.

---@class Xiv_laya_query_result
---@field ["result"] any Any JSON value.

---@class Xiv_list_addons_args
---@field ["visibleOnly"] boolean|nil Only addons currently shown on screen.
---@field ["nameContains"] string|nil Case-insensitive substring filter on the addon name.
---@field ["limit"] integer|nil Maximum entries to return.
---@field ["offset"] integer|nil Entries to skip (for paging).

---@class Xiv_list_addons_result_addons_item
---@field ["name"] string|nil 
---@field ["id"] integer 
---@field ["visible"] boolean 
---@field ["ready"] boolean 
---@field ["focused"] boolean|nil 
---@field ["x"] integer 
---@field ["y"] integer 
---@field ["width"] integer 
---@field ["height"] integer 
---@field ["scale"] number 
---@field ["depthLayer"] integer 
---@field ["parentId"] integer|nil 

---@class Xiv_list_addons_result
---@field ["addons"] (Xiv_list_addons_result_addons_item)[]|nil 
---@field ["total"] integer 
---@field ["truncated"] boolean 

---@class Xiv_list_aetherytes_args
---@field ["nameContains"] string|nil Case-insensitive substring matched against the aetheryte, zone or region name.
---@field ["limit"] integer|nil Maximum entries to return (1-500). Default 50.
---@field ["offset"] integer|nil Entries to skip, for paging (>= 0).

---@class Xiv_list_aetherytes_result_aetherytes_item
---@field ["aetheryteId"] integer 
---@field ["subIndex"] integer 
---@field ["name"] string|nil 
---@field ["territoryId"] integer 
---@field ["zone"] string|nil 
---@field ["region"] string|nil 
---@field ["gilCost"] integer 
---@field ["isFavourite"] boolean 
---@field ["isFreeDestination"] boolean 
---@field ["isHomePoint"] boolean 
---@field ["isInCurrentZone"] boolean 
---@field ["isHousing"] boolean 
---@field ["isSharedHouse"] boolean 
---@field ["isApartment"] boolean 
---@field ["ward"] integer|nil 
---@field ["plot"] integer|nil 
---@field ["unlocked"] boolean 

---@class Xiv_list_aetherytes_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["aetherytes"] (Xiv_list_aetherytes_result_aetherytes_item)[]|nil 

---@class Xiv_list_almanac_benchmarks_args
---@field ["limit"] integer|nil Maximum runs (1-50).

---@class Xiv_list_almanac_benchmarks_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_list_almanac_threads_args
---@field ["limit"] integer|nil Maximum threads (1-100).
---@field ["offset"] integer|nil Threads to skip.

---@class Xiv_list_almanac_threads_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_list_bridges_result_bridges_item
---@field ["key"] string|nil 
---@field ["name"] string|nil 
---@field ["purpose"] string|nil 
---@field ["installed"] boolean 
---@field ["loaded"] boolean 
---@field ["version"] string|nil 
---@field ["ipcAvailable"] boolean 
---@field ["apiVersion"] string|nil 
---@field ["unavailable"] string|nil 
---@field ["verified"] boolean 

---@class Xiv_list_bridges_result
---@field ["total"] integer 
---@field ["available"] integer 
---@field ["bridges"] (Xiv_list_bridges_result_bridges_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_desktop_apps_args
---@field ["query"] string|nil Text to match. Omit for everything.
---@field ["favouritesOnly"] boolean|nil Only the player's favourites.
---@field ["limit"] integer|nil Maximum apps returned (1-500).
---@field ["offset"] integer|nil Apps to skip.

---@class Xiv_list_desktop_apps_result_apps_item
---@field ["id"] string|nil 
---@field ["name"] string|nil 
---@field ["generic"] string|nil 
---@field ["categories"] (string)[]|nil 
---@field ["favourite"] boolean 
---@field ["terminal"] boolean 
---@field ["launchable"] boolean 
---@field ["recent"] integer|nil 

---@class Xiv_list_desktop_apps_result
---@field ["total"] integer 
---@field ["matched"] integer 
---@field ["offset"] integer 
---@field ["truncated"] boolean 
---@field ["apps"] (Xiv_list_desktop_apps_result_apps_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_desktop_windows_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_list_event_kinds_result_kinds_item
---@field ["kind"] string|nil 
---@field ["buffered"] integer 
---@field ["description"] string|nil 

---@class Xiv_list_event_kinds_result
---@field ["cursor"] integer 
---@field ["buffered"] integer 
---@field ["capacity"] integer 
---@field ["kinds"] (Xiv_list_event_kinds_result_kinds_item)[]|nil 

---@class Xiv_list_fates_args
---@field ["limit"] integer|nil Maximum FATEs to return (1-100). Default 25.

---@class Xiv_list_fates_result_fates_item_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_list_fates_result_fates_item_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_list_fates_result_fates_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["objective"] string|nil 
---@field ["level"] integer 
---@field ["maxLevel"] integer 
---@field ["state"] string|nil 
---@field ["progressPercent"] integer 
---@field ["timeRemainingSeconds"] integer|nil 
---@field ["durationSeconds"] integer 
---@field ["startTimeUtc"] string|nil 
---@field ["hasBonus"] boolean 
---@field ["handInCount"] integer 
---@field ["position"] Xiv_list_fates_result_fates_item_position|nil 
---@field ["mapCoordinates"] Xiv_list_fates_result_fates_item_mapCoordinates|nil 
---@field ["distance"] number 
---@field ["radius"] number 
---@field ["playerInsideRadius"] boolean 
---@field ["isOccupiedByPlayer"] boolean 
---@field ["isLevelSyncedByPlayer"] boolean 

---@class Xiv_list_fates_result
---@field ["total"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["currentFateId"] integer|nil 
---@field ["fates"] (Xiv_list_fates_result_fates_item)[]|nil 

---@class Xiv_list_gearsets_result_gearsets_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["classJobId"] integer 
---@field ["classJob"] string|nil 
---@field ["classJobName"] string|nil 
---@field ["itemLevel"] integer 
---@field ["glamourPlate"] integer|nil 
---@field ["mainHandMissing"] boolean|nil 
---@field ["isCurrent"] boolean 

---@class Xiv_list_gearsets_result
---@field ["gearsets"] (Xiv_list_gearsets_result_gearsets_item)[]|nil 
---@field ["currentId"] integer|nil 

---@class Xiv_list_hotbars_args
---@field ["bars"] "standard"|"cross"|"pet"|"petCross"|"all"|nil Which bars to list.
---@field ["number"] integer|nil One bar number: 1-10 for standard, 1-8 for cross. Omit for every bar of that kind.
---@field ["includeEmpty"] boolean|nil Include empty slots.

---@class Xiv_list_hotbars_result_hotbars_item_slots_item
---@field ["slot"] integer 
---@field ["kind"] string|nil 
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["keybind"] string|nil 
---@field ["iconId"] integer|nil 
---@field ["shownAsKind"] string|nil 
---@field ["shownAsId"] integer|nil 
---@field ["shownAsName"] string|nil 
---@field ["macroSet"] string|nil 
---@field ["macroIndex"] integer|nil 

---@class Xiv_list_hotbars_result_hotbars_item
---@field ["kind"] string|nil 
---@field ["number"] integer 
---@field ["sharedAcrossJobs"] boolean|nil 
---@field ["slotCount"] integer 
---@field ["used"] integer 
---@field ["slots"] (Xiv_list_hotbars_result_hotbars_item_slots_item)[]|nil 

---@class Xiv_list_hotbars_result
---@field ["job"] string|nil 
---@field ["pvpHotbarsActive"] boolean 
---@field ["bars"] integer 
---@field ["hotbars"] (Xiv_list_hotbars_result_hotbars_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_macros_args
---@field ["set"] "individual"|"shared"|nil Which macro page to read.
---@field ["nonEmptyOnly"] boolean|nil Skip slots with no name and no lines.

---@class Xiv_list_macros_result_macros_item
---@field ["index"] integer 
---@field ["name"] string|nil 
---@field ["iconId"] integer 
---@field ["lineCount"] integer 
---@field ["lines"] (string)[]|nil 

---@class Xiv_list_macros_result
---@field ["set"] string|nil 
---@field ["macros"] (Xiv_list_macros_result_macros_item)[]|nil 
---@field ["count"] integer 

---@class Xiv_list_nearby_objects_args
---@field ["kind"] "all"|"player"|"battleNpc"|"enemy"|"eventNpc"|"treasure"|"aetheryte"|"gatheringPoint"|"eventObj"|"mount"|"companion"|"retainer"|"areaObject"|"housing"|"cutscene"|"reactionEventObj"|"ornament"|"cardStand"|"followMount"|nil Object kind filter.
---@field ["radius"] number|nil Maximum 3D distance in yalms from the player (1-1000). Default 50.
---@field ["nameContains"] string|nil Case-insensitive substring the object's name must contain.
---@field ["limit"] integer|nil Maximum rows to return (1-500). Default 25.
---@field ["offset"] integer|nil Rows to skip, for paging (>= 0).
---@field ["targetableOnly"] boolean|nil Only include objects that can currently be targeted.

---@class Xiv_list_nearby_objects_result_origin
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_list_nearby_objects_result_objects_item_position
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number 

---@class Xiv_list_nearby_objects_result_objects_item_mapCoordinates
---@field ["x"] number 
---@field ["y"] number 
---@field ["z"] number|nil 

---@class Xiv_list_nearby_objects_result_objects_item
---@field ["kind"] string|nil 
---@field ["subKind"] string|nil 
---@field ["name"] string|nil 
---@field ["entityId"] integer|nil 
---@field ["gameObjectId"] string|nil 
---@field ["baseId"] integer 
---@field ["objectIndex"] integer 
---@field ["distance"] number 
---@field ["horizontalDistance"] number 
---@field ["position"] Xiv_list_nearby_objects_result_objects_item_position|nil 
---@field ["mapCoordinates"] Xiv_list_nearby_objects_result_objects_item_mapCoordinates|nil 
---@field ["isTargetable"] boolean 
---@field ["isDead"] boolean|nil 
---@field ["level"] integer|nil 
---@field ["hpPercent"] number|nil 
---@field ["job"] string|nil 
---@field ["world"] string|nil 
---@field ["isHostile"] boolean|nil 
---@field ["inCombat"] boolean|nil 
---@field ["isCasting"] boolean|nil 
---@field ["ownerEntityId"] integer|nil 

---@class Xiv_list_nearby_objects_result
---@field ["kind"] string|nil 
---@field ["radius"] number|nil 
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["origin"] Xiv_list_nearby_objects_result_origin|nil 
---@field ["objects"] (Xiv_list_nearby_objects_result_objects_item)[]|nil 

---@class Xiv_list_objectives_args
---@field ["includeCompleted"] boolean|nil Include completed objectives.

---@class Xiv_list_objectives_result_objectives_item_steps_item
---@field ["index"] integer 
---@field ["text"] string|nil 
---@field ["done"] boolean 

---@class Xiv_list_objectives_result_objectives_item_status
---@field ["ready"] boolean 
---@field ["summary"] string|nil 
---@field ["windowOpen"] boolean 
---@field ["inZone"] boolean|nil 
---@field ["nearSpot"] boolean|nil 
---@field ["distanceYalms"] number|nil 
---@field ["timeOk"] boolean|nil 
---@field ["weatherOk"] boolean|nil 
---@field ["currentWeather"] string|nil 
---@field ["nextWindowStartUtc"] string|nil 
---@field ["nextWindowEndUtc"] string|nil 
---@field ["minutesUntilNextWindow"] number|nil 
---@field ["problem"] string|nil 

---@class Xiv_list_objectives_result_objectives_item
---@field ["id"] string|nil 
---@field ["title"] string|nil 
---@field ["completed"] boolean 
---@field ["currentStep"] integer 
---@field ["currentStepText"] string|nil 
---@field ["stepsDone"] integer 
---@field ["steps"] (Xiv_list_objectives_result_objectives_item_steps_item)[]|nil 
---@field ["zone"] string|nil 
---@field ["territoryId"] integer|nil 
---@field ["mapX"] number|nil 
---@field ["mapY"] number|nil 
---@field ["spot"] string|nil 
---@field ["description"] string|nil 
---@field ["note"] string|nil 
---@field ["eorzeaTime"] string|nil 
---@field ["weather"] (string)[]|nil 
---@field ["radius"] number 
---@field ["source"] string|nil 
---@field ["createdAt"] string 
---@field ["updatedAt"] string 
---@field ["completedAt"] string|nil 
---@field ["status"] Xiv_list_objectives_result_objectives_item_status|nil 

---@class Xiv_list_objectives_result
---@field ["count"] integer 
---@field ["active"] integer 
---@field ["ready"] integer 
---@field ["objectives"] (Xiv_list_objectives_result_objectives_item)[]|nil 

---@class Xiv_list_plugin_repositories_args
---@field ["limit"] integer|nil Maximum entries to return (1-500).
---@field ["offset"] integer|nil Entries to skip.

---@class Xiv_list_plugin_repositories_result_repositories_item
---@field ["url"] string|nil 
---@field ["enabled"] boolean 

---@class Xiv_list_plugin_repositories_result
---@field ["repositories"] (Xiv_list_plugin_repositories_result_repositories_item)[]|nil 
---@field ["total"] integer 
---@field ["enabledTotal"] integer 
---@field ["truncated"] boolean 

---@class Xiv_list_plugins_args
---@field ["nameContains"] string|nil Case-insensitive substring filter on name or internal name.
---@field ["loadedOnly"] boolean|nil Only plugins that are currently loaded.
---@field ["limit"] integer|nil Maximum entries to return.

---@class Xiv_list_plugins_result_plugins_item
---@field ["internalName"] string|nil 
---@field ["name"] string|nil 
---@field ["version"] string|nil 
---@field ["author"] string|nil 
---@field ["loaded"] boolean 
---@field ["isDev"] boolean 
---@field ["isThirdParty"] boolean 
---@field ["isTesting"] boolean 
---@field ["isOutdated"] boolean 
---@field ["isBanned"] boolean|nil 
---@field ["isOrphaned"] boolean|nil 
---@field ["isDecommissioned"] boolean|nil 
---@field ["hasMainUi"] boolean 
---@field ["hasConfigUi"] boolean 
---@field ["apiLevel"] integer|nil 
---@field ["installedFromUrl"] string|nil 
---@field ["projectUrl"] string|nil 
---@field ["state"] string|nil 
---@field ["updateAvailable"] boolean|nil 

---@class Xiv_list_plugins_result
---@field ["plugins"] (Xiv_list_plugins_result_plugins_item)[]|nil 
---@field ["total"] integer 
---@field ["truncated"] boolean 

---@class Xiv_list_roulettes_args
---@field ["inDutyFinderOnly"] boolean|nil true = only roulettes shown in the Duty Finder.
---@field ["limit"] integer|nil Maximum results (1-100).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_list_roulettes_result_results_item_roleBonus
---@field ["itemId"] integer 
---@field ["name"] string|nil 
---@field ["amount"] integer 

---@class Xiv_list_roulettes_result_results_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["category"] string|nil 
---@field ["dutyType"] string|nil 
---@field ["description"] string|nil 
---@field ["requiredLevel"] integer 
---@field ["itemLevelRequired"] integer 
---@field ["itemLevelSync"] integer 
---@field ["partySize"] integer 
---@field ["rewardTomeA"] integer 
---@field ["rewardTomeB"] integer 
---@field ["rewardTomeC"] integer 
---@field ["roleBonus"] Xiv_list_roulettes_result_results_item_roleBonus|nil 
---@field ["inDutyFinder"] boolean 
---@field ["pvp"] boolean 
---@field ["dutyCount"] integer|nil 

---@class Xiv_list_roulettes_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_list_roulettes_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_sheets_args
---@field ["nameContains"] string|nil Case-insensitive substring of the sheet name, e.g. "Item", "Mount", "Fish".
---@field ["includeColumns"] boolean|nil Include column names and types for each returned sheet.
---@field ["includeUntyped"] boolean|nil Also list sheets without typed definitions (quest dialogue, custom sheets, ...).
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_list_sheets_result_results_item
---@field ["name"] string|nil 
---@field ["rowCount"] integer|nil 
---@field ["subrows"] boolean|nil 
---@field ["columns"] (string)[]|nil 
---@field ["typed"] boolean 

---@class Xiv_list_sheets_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_list_sheets_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_social_groups_result_freeCompany
---@field ["loaded"] boolean 
---@field ["member"] boolean 
---@field ["name"] string|nil 
---@field ["tag"] string|nil 
---@field ["rank"] integer|nil 
---@field ["grandCompany"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_list_social_groups_result_linkshells_groups_item
---@field ["slot"] integer 
---@field ["name"] string|nil 

---@class Xiv_list_social_groups_result_linkshells
---@field ["loaded"] boolean 
---@field ["count"] integer 
---@field ["groups"] (Xiv_list_social_groups_result_linkshells_groups_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_social_groups_result_crossWorldLinkshells_groups_item
---@field ["slot"] integer 
---@field ["name"] string|nil 

---@class Xiv_list_social_groups_result_crossWorldLinkshells
---@field ["loaded"] boolean 
---@field ["count"] integer 
---@field ["groups"] (Xiv_list_social_groups_result_crossWorldLinkshells_groups_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_social_groups_result
---@field ["freeCompany"] Xiv_list_social_groups_result_freeCompany|nil 
---@field ["linkshells"] Xiv_list_social_groups_result_linkshells|nil 
---@field ["crossWorldLinkshells"] Xiv_list_social_groups_result_crossWorldLinkshells|nil 
---@field ["notExposed"] (string)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_status_result_agents_item
---@field ["agent"] string|nil 
---@field ["status"] string|nil 
---@field ["state"] string|nil 
---@field ["progress"] number|nil 
---@field ["detail"] string|nil 
---@field ["clientName"] string|nil 
---@field ["updatedAt"] string 
---@field ["createdAt"] string 
---@field ["ageSeconds"] integer 

---@class Xiv_list_status_result
---@field ["count"] integer 
---@field ["agents"] (Xiv_list_status_result_agents_item)[]|nil 

---@class Xiv_list_terminal_panels_args
---@field ["limit"] integer|nil Maximum panels returned (1-500).
---@field ["offset"] integer|nil Panels to skip.

---@class Xiv_list_terminal_panels_result_panels_item
---@field ["id"] integer 
---@field ["kind"] string|nil 
---@field ["title"] string|nil 
---@field ["app"] string|nil 
---@field ["profile"] string|nil 
---@field ["running"] boolean|nil 
---@field ["view"] string|nil 
---@field ["anchor"] string|nil 
---@field ["state"] string|nil 
---@field ["width"] integer|nil 
---@field ["height"] integer|nil 
---@field ["focused"] boolean 
---@field ["hidden"] boolean 
---@field ["order"] integer|nil 

---@class Xiv_list_terminal_panels_result
---@field ["rev"] integer|nil 
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["truncated"] boolean 
---@field ["panels"] (Xiv_list_terminal_panels_result_panels_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_list_terminal_themes_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_list_tickets_args
---@field ["state"] "open"|"pending"|"final"|"all"|nil Which tickets to return.
---@field ["resumeToken"] string|nil Only tickets filed with this resume token.

---@class Xiv_list_tickets_result_tickets_item
---@field ["id"] string|nil 
---@field ["state"] string|nil 
---@field ["tool"] string|nil 
---@field ["tier"] string|nil 
---@field ["reason"] string|nil 
---@field ["resumeToken"] string|nil 
---@field ["client"] string|nil 
---@field ["createdAt"] string 
---@field ["expiresAt"] string|nil 
---@field ["decidedBy"] string|nil 
---@field ["decidedAt"] string|nil 
---@field ["completedAt"] string|nil 
---@field ["queuePosition"] integer|nil 
---@field ["arguments"] any|nil Any JSON value.
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["uri"] string|nil 

---@class Xiv_list_tickets_result
---@field ["count"] integer 
---@field ["pending"] integer 
---@field ["sessionActiveUntil"] string|nil 
---@field ["tickets"] (Xiv_list_tickets_result_tickets_item)[]|nil 

---@class Xiv_list_worlds_args
---@field ["nameContains"] string|nil Case-insensitive substring matched against world, data-centre or region name.
---@field ["limit"] integer|nil Maximum entries (1-500). Default 100.
---@field ["offset"] integer|nil Entries to skip for paging.

---@class Xiv_list_worlds_result_worlds_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["dataCenter"] string|nil 
---@field ["region"] string|nil 
---@field ["isCurrent"] boolean 
---@field ["isHome"] boolean 

---@class Xiv_list_worlds_result
---@field ["currentWorld"] string|nil 
---@field ["homeWorld"] string|nil 
---@field ["currentDataCenter"] string|nil 
---@field ["total"] integer 
---@field ["worlds"] (Xiv_list_worlds_result_worlds_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_load_objective_pack_args
---@field ["json"] string|nil Pack JSON text.
---@field ["path"] string|nil Path to a .json pack file on the player's machine.

---@class Xiv_load_objective_pack_result
---@field ["title"] string|nil 
---@field ["loaded"] integer 
---@field ["ids"] (string)[]|nil 
---@field ["errors"] (string)[]|nil 
---@field ["total"] integer 

---@class Xiv_open_dalamud_window_args
---@field ["window"] "installer"|"settings" Which Dalamud window.
---@field ["tab"] string|nil Tab to show; default is the window's first tab (allPlugins / general). Installer: allPlugins, installedPlugins, updateablePlugins, changelogs, dalamudChangelogs. Settings: general, lookAndFeel, autoUpdates, serverInfoBar, badge, experimental, about.
---@field ["searchText"] string|nil Text for the window's search box (single line, up to 100 characters).

---@class Xiv_open_dalamud_window_result
---@field ["opened"] boolean 
---@field ["window"] string|nil 
---@field ["tab"] string|nil 
---@field ["searchText"] string|nil 

---@class Xiv_open_game_window_args
---@field ["kind"] "map"|"journal"|"recipe"|"recipeSearch"|"gatheringLog"|"teleport"|"character"|"armoury"|"inventory"|"dutyFinder"|"achievements"|"currency"|"gearsets"|"macros" Which window to open.
---@field ["id"] integer|nil Optional row id whose meaning depends on kind (see the description).
---@field ["territoryId"] integer|nil Only for kind=map: TerritoryType row id whose main map to open.

---@class Xiv_open_game_window_result
---@field ["kind"] string|nil 
---@field ["id"] integer|nil 
---@field ["api"] string|nil 
---@field ["alreadyOpen"] boolean|nil 

---@class Xiv_open_plugin_ui_args
---@field ["plugin"] string Plugin internal name (see list_plugins), or its display name.
---@field ["which"] "main"|"config"|nil Which window to open.

---@class Xiv_open_plugin_ui_result
---@field ["internalName"] string|nil 
---@field ["name"] string|nil 
---@field ["which"] string|nil 

---@class Xiv_open_terminal_args
---@field ["run"] string|nil Command the desktop agent starts, shown verbatim to the player. Omit for a plain terminal.
---@field ["profile"] string|nil Terminal profile name or place from 1. Not with run.
---@field ["pin"] string|nil Placement as /term pin takes it, e.g. "pet", "here", "orbit 3.5", "hud 0.85 0.2". Default: a pet.

---@class Xiv_open_terminal_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_order_terminal_panel_args
---@field ["id"] integer Panel id from list_terminal_panels.
---@field ["to"] string left, right, first, last or a place from 1.

---@class Xiv_order_terminal_panel_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_place_terminal_panel_args
---@field ["id"] integer Panel id from list_terminal_panels.
---@field ["pin"] string Placement, e.g. "pet", "here", "orbit 3.5", "hud 0.85 0.2".

---@class Xiv_place_terminal_panel_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_post_objective_args
---@field ["id"] string Stable id, e.g. "hero-costa-night" (lowercased; letters, digits, '-', '_', '.'). Max 64 chars.
---@field ["title"] string Quest title shown in game. Max 120 chars.
---@field ["steps"] (string)[]|nil Ordered steps; the first not-done one is shown as the current step. Max 30, 300 chars each.
---@field ["territoryId"] integer|nil TerritoryType row id of the zone (see get_location / search_sheet TerritoryType).
---@field ["x"] number|nil Map X coordinate as shown in game. Needs y and territoryId.
---@field ["y"] number|nil Map Y coordinate as shown in game. Needs x and territoryId.
---@field ["zone"] string|nil Zone name for display, e.g. "Eastern La Noscea".
---@field ["spot"] string|nil Short description of the spot, e.g. "the beach below the villa".
---@field ["description"] string|nil Longer description shown in the tooltip. Max 2000 chars.
---@field ["eorzeaTime"] string|nil Daily Eorzea time window "HH:MM-HH:MM" (wraps past midnight) or "any".
---@field ["weather"] (string)[]|nil Acceptable weather names in the game's wording, e.g. ["Clear Skies", "Fair Skies"]; omit or ["any"] for any.
---@field ["radius"] number|nil Distance from the spot (yalms, ground plane) that counts as there. Default 30.

---@class Xiv_post_objective_result_steps_item
---@field ["index"] integer 
---@field ["text"] string|nil 
---@field ["done"] boolean 

---@class Xiv_post_objective_result_status
---@field ["ready"] boolean 
---@field ["summary"] string|nil 
---@field ["windowOpen"] boolean 
---@field ["inZone"] boolean|nil 
---@field ["nearSpot"] boolean|nil 
---@field ["distanceYalms"] number|nil 
---@field ["timeOk"] boolean|nil 
---@field ["weatherOk"] boolean|nil 
---@field ["currentWeather"] string|nil 
---@field ["nextWindowStartUtc"] string|nil 
---@field ["nextWindowEndUtc"] string|nil 
---@field ["minutesUntilNextWindow"] number|nil 
---@field ["problem"] string|nil 

---@class Xiv_post_objective_result
---@field ["id"] string|nil 
---@field ["title"] string|nil 
---@field ["completed"] boolean 
---@field ["currentStep"] integer 
---@field ["currentStepText"] string|nil 
---@field ["stepsDone"] integer 
---@field ["steps"] (Xiv_post_objective_result_steps_item)[]|nil 
---@field ["zone"] string|nil 
---@field ["territoryId"] integer|nil 
---@field ["mapX"] number|nil 
---@field ["mapY"] number|nil 
---@field ["spot"] string|nil 
---@field ["description"] string|nil 
---@field ["note"] string|nil 
---@field ["eorzeaTime"] string|nil 
---@field ["weather"] (string)[]|nil 
---@field ["radius"] number 
---@field ["source"] string|nil 
---@field ["createdAt"] string 
---@field ["updatedAt"] string 
---@field ["completedAt"] string|nil 
---@field ["status"] Xiv_post_objective_result_status|nil 

---@class Xiv_post_status_args
---@field ["agent"] string Short stable name identifying you, e.g. "claude-code" or "gear-audit". Max 64 chars.
---@field ["status"] string One-line status shown on the board, e.g. "Checking retainer inventories". Max 200 chars.
---@field ["state"] "running"|"done"|"failed"|"info"|nil Lifecycle state.
---@field ["progress"] number|nil Completion fraction from 0 to 1; omit when unknown.
---@field ["detail"] string|nil Optional longer detail shown on hover/expand. Max 2000 chars.

---@class Xiv_post_status_result
---@field ["agent"] string|nil 
---@field ["status"] string|nil 
---@field ["state"] string|nil 
---@field ["progress"] number|nil 
---@field ["detail"] string|nil 
---@field ["clientName"] string|nil 
---@field ["updatedAt"] string 
---@field ["createdAt"] string 
---@field ["ageSeconds"] integer 

---@class Xiv_print_echo_args
---@field ["message"] string Text to print.

---@class Xiv_print_echo_result
---@field ["printed"] string|nil 
---@field ["truncated"] boolean|nil 

---@class Xiv_read_chat_args
---@field ["limit"] integer|nil Maximum entries to return.
---@field ["afterSequence"] integer|nil Return only entries with a sequence greater than this (from a previous nextAfterSequence). Omit to get the newest entries.
---@field ["channels"] (string)[]|nil Chat types or groups to include, e.g. ["party", "FreeCompany", "Say"]. Omit for all captured types.
---@field ["contains"] string|nil Only messages whose text contains this (case-insensitive).
---@field ["senderContains"] string|nil Only messages whose sender name contains this (case-insensitive).
---@field ["includeTells"] boolean|nil Include private tells. Default false; tells are also included when channels names a tell type.

---@class Xiv_read_chat_result_entries_item
---@field ["sequence"] integer 
---@field ["timestamp"] string 
---@field ["chatType"] string|nil 
---@field ["chatTypeId"] integer 
---@field ["sender"] string|nil 
---@field ["message"] string|nil 
---@field ["isHandled"] boolean 

---@class Xiv_read_chat_result
---@field ["entries"] (Xiv_read_chat_result_entries_item)[]|nil 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["nextAfterSequence"] integer 
---@field ["latestSequence"] integer 
---@field ["oldestBufferedSequence"] integer 
---@field ["buffered"] integer 
---@field ["capacity"] integer 
---@field ["gap"] boolean|nil 
---@field ["hiddenTells"] integer|nil 

---@class Xiv_read_plugin_log_args
---@field ["plugin"] string|nil Only lines tagged [plugin]: a plugin's internal or display name (see list_plugins), or a Dalamud module tag. Case-insensitive, exact.
---@field ["level"] "verbose"|"debug"|"information"|"warning"|"error"|"fatal"|nil Minimum level.
---@field ["contains"] string|nil Only entries whose message or details contain this text (case-insensitive).
---@field ["sinceMinutes"] integer|nil Only entries from the last N minutes (1-10080).
---@field ["limit"] integer|nil Maximum entries to return (1-500).
---@field ["tailMiB"] integer|nil How much of the end of the file to scan, in MiB (1-4).

---@class Xiv_read_plugin_log_result_entries_item
---@field ["time"] string|nil 
---@field ["level"] string|nil 
---@field ["plugin"] string|nil 
---@field ["message"] string|nil 
---@field ["details"] string|nil 

---@class Xiv_read_plugin_log_result
---@field ["entries"] (Xiv_read_plugin_log_result_entries_item)[]|nil 
---@field ["returned"] integer 
---@field ["matched"] integer 
---@field ["truncated"] boolean 
---@field ["fileBytes"] integer 
---@field ["scannedBytes"] integer 
---@field ["windowStartsMidFile"] boolean 

---@class Xiv_reload_plugin_args
---@field ["plugin"] string Plugin internal name (see list_plugins), or its display name.

---@class Xiv_reload_plugin_result
---@field ["internalName"] string|nil 
---@field ["name"] string|nil 
---@field ["enabled"] boolean 
---@field ["changed"] boolean 
---@field ["state"] string|nil 
---@field ["loaded"] boolean 

---@class Xiv_request_action_args
---@field ["tool"] string Name of the Action/Chat tool to run, e.g. "teleport".
---@field ["reason"] string One line shown to the player: why you want to do this. Max 300 chars.
---@field ["arguments"] table<string, any>|nil Arguments object for that tool, exactly as for tools/call.
---@field ["resumeToken"] string|nil Opaque string returned on the ticket so you can match it to the step of your plan that waits on it. Max 512 chars.
---@field ["expiresInSeconds"] integer|nil Optional: expire the ticket if the player has not decided within this many seconds (30 to 604800). Omit to wait indefinitely.

---@class Xiv_request_action_result
---@field ["id"] string|nil 
---@field ["state"] string|nil 
---@field ["tool"] string|nil 
---@field ["tier"] string|nil 
---@field ["reason"] string|nil 
---@field ["resumeToken"] string|nil 
---@field ["client"] string|nil 
---@field ["createdAt"] string 
---@field ["expiresAt"] string|nil 
---@field ["decidedBy"] string|nil 
---@field ["decidedAt"] string|nil 
---@field ["completedAt"] string|nil 
---@field ["queuePosition"] integer|nil 
---@field ["arguments"] any|nil Any JSON value.
---@field ["result"] any|nil Any JSON value.
---@field ["error"] string|nil 
---@field ["uri"] string|nil 

---@class Xiv_rescan_desktop_apps_result
---@field ["gate"] string|nil 
---@field ["ok"] boolean 
---@field ["message"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_run_almanac_benchmark_args
---@field ["mode"] "mock"|"live"|nil mock or live.
---@field ["model"] string|nil Model name. Omit for the configured model.
---@field ["tasks"] string|nil Task ids separated by spaces or commas. Omit for all.

---@class Xiv_run_almanac_benchmark_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_run_terminal_selftest_args
---@field ["suites"] string|nil "all", "list" or suite names separated by spaces.

---@class Xiv_run_terminal_selftest_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_search_actions_args
---@field ["query"] string|nil Action name text (any case). Optional when classJob is given.
---@field ["classJob"] string|nil Class/job abbreviation or name, e.g. "NIN", "Red Mage".
---@field ["includePvp"] boolean|nil Include PvP-only actions.
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_search_actions_result_results_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["classJob"] string|nil 
---@field ["level"] integer 
---@field ["category"] string|nil 
---@field ["isRoleAction"] boolean 
---@field ["isPvp"] boolean 

---@class Xiv_search_actions_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_search_actions_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_search_desktop_palette_args
---@field ["query"] string What the player would type into the palette.
---@field ["limit"] integer|nil Maximum results (1-50; XivDesktop itself returns at most 10).

---@class Xiv_search_desktop_palette_result
---@field ["bridge"] string|nil 
---@field ["capability"] string|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["truncated"] boolean 
---@field ["rawPrefix"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_search_duties_args
---@field ["query"] string|nil Duty name text (any case).
---@field ["contentType"] string|nil Content type name (partial ok, e.g. "Dungeon", "Trial", "Raid") or ContentType id.
---@field ["minLevel"] integer|nil Minimum required class/job level.
---@field ["maxLevel"] integer|nil Maximum required class/job level.
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_search_duties_result_results_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["type"] string|nil 
---@field ["level"] integer 
---@field ["itemLevelRequired"] integer 
---@field ["levelSync"] integer 
---@field ["itemLevelSync"] integer 
---@field ["partySize"] integer 
---@field ["highEnd"] boolean 
---@field ["pvp"] boolean 

---@class Xiv_search_duties_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_search_duties_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_search_items_args
---@field ["query"] string|nil Name text to search for (any case). Optional when at least one filter is set.
---@field ["itemUiCategory"] string|nil ItemUICategory name (exact or partial, e.g. "Ring", "Seafood") or numeric id.
---@field ["equipSlot"] string|nil Equipment slot: mainHand, offHand, head, body, hands, waist, legs, feet, ears, neck, wrists, ring, soulCrystal.
---@field ["classJob"] string|nil Class/job abbreviation (e.g. PLD, WHM, ALC, MIN) or name; keeps only items that class/job can equip.
---@field ["minItemLevel"] integer|nil Minimum item level (inclusive).
---@field ["maxItemLevel"] integer|nil Maximum item level (inclusive).
---@field ["isMarketable"] boolean|nil true = only items sellable on the market board; false = only non-marketable.
---@field ["isCraftable"] boolean|nil true = only items some recipe produces.
---@field ["isGatherable"] boolean|nil true = only items obtainable from mining/logging/harvesting/quarrying nodes.
---@field ["isUntradable"] boolean|nil true = only untradable items; false = only tradable.
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_search_items_result_results_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["category"] string|nil 
---@field ["itemLevel"] integer 
---@field ["equipLevel"] integer 
---@field ["equipSlot"] string|nil 
---@field ["jobs"] string|nil 
---@field ["rarity"] integer 
---@field ["isMarketable"] boolean 
---@field ["isCraftable"] boolean 
---@field ["isGatherable"] boolean 
---@field ["isUntradable"] boolean 
---@field ["icon"] integer 

---@class Xiv_search_items_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_search_items_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_search_quests_args
---@field ["query"] string Quest name text (any case).
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_search_quests_result_results_item
---@field ["id"] integer 
---@field ["name"] string|nil 
---@field ["level"] integer 
---@field ["genre"] string|nil 
---@field ["expansion"] string|nil 

---@class Xiv_search_quests_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_search_quests_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_search_recipes_args
---@field ["query"] string|nil Crafted item name text (any case).
---@field ["craftType"] string|nil Crafter: craft type name (Smithing), class name (Blacksmith), abbreviation (BSM) or craft type id.
---@field ["minLevel"] integer|nil Minimum recipe (class/job) level.
---@field ["maxLevel"] integer|nil Maximum recipe (class/job) level.
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_search_recipes_result_results_item
---@field ["recipeId"] integer 
---@field ["itemId"] integer 
---@field ["itemName"] string|nil 
---@field ["craftType"] string|nil 
---@field ["level"] integer 
---@field ["stars"] integer 
---@field ["yield"] integer 
---@field ["isExpert"] boolean 
---@field ["requiresSpecialist"] boolean 
---@field ["masterBook"] string|nil 

---@class Xiv_search_recipes_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_search_recipes_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_search_sheet_args
---@field ["sheet"] string Sheet name, case-insensitive.
---@field ["column"] string Column (property) name, case-insensitive, e.g. "Name", "ClassJobLevel", "TerritoryType".
---@field ["query"] string Text to find, a number, true/false, or a numeric range like "50..60".
---@field ["match"] "contains"|"exact"|nil "contains" (default, text only) or "exact".
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_search_sheet_result_results_item
---@field ["rowId"] integer 
---@field ["subrowId"] integer|nil 
---@field ["label"] string|nil 
---@field ["value"] any|nil Any JSON value.

---@class Xiv_search_sheet_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_search_sheet_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_search_zones_args
---@field ["query"] string|nil Zone name text (any case) or a territory id.
---@field ["kind"] "city"|"field"|"inn"|"housing"|"duty"|"pvp"|"other"|nil Zone kind.
---@field ["region"] string|nil Region name text, e.g. "La Noscea", "Thanalan", "Norvrandt" (partial ok).
---@field ["limit"] integer|nil Maximum results (1-500).
---@field ["offset"] integer|nil Results to skip for paging.

---@class Xiv_search_zones_result_results_item_duty
---@field ["id"] integer 
---@field ["name"] string|nil 

---@class Xiv_search_zones_result_results_item
---@field ["territoryId"] integer 
---@field ["name"] string|nil 
---@field ["region"] string|nil 
---@field ["kind"] string|nil 
---@field ["intendedUse"] integer 
---@field ["expansion"] string|nil 
---@field ["duty"] Xiv_search_zones_result_results_item_duty|nil 
---@field ["hasWeather"] boolean 

---@class Xiv_search_zones_result
---@field ["total"] integer 
---@field ["offset"] integer 
---@field ["returned"] integer 
---@field ["truncated"] boolean 
---@field ["results"] (Xiv_search_zones_result_results_item)[]|nil 
---@field ["note"] string|nil 

---@class Xiv_select_hud_quest_args
---@field ["questId"] integer Accepted Quest sheet row ID.

---@class Xiv_select_hud_quest_result
---@field ["result"] any Any JSON value.

---@class Xiv_send_chat_args
---@field ["channel"] "say"|"party"|"alliance"|"freeCompany"|"linkshell1"|"linkshell2"|"linkshell3"|"linkshell4"|"linkshell5"|"linkshell6"|"linkshell7"|"linkshell8"|"crossLinkshell1"|"crossLinkshell2"|"crossLinkshell3"|"crossLinkshell4"|"crossLinkshell5"|"crossLinkshell6"|"crossLinkshell7"|"crossLinkshell8"|"yell"|"shout"|"novice"|"pvpTeam"|"tell" Channel to post on.
---@field ["message"] string The message text (single line, no leading '/').
---@field ["tellTarget"] string|nil Only for channel=tell: recipient as "Firstname Lastname@World" (or "Firstname Lastname" for the same world).

---@class Xiv_send_chat_result
---@field ["channel"] string|nil 
---@field ["sentText"] string|nil 
---@field ["bytes"] integer 

---@class Xiv_set_focus_target_args
---@field ["entityId"] integer|nil EntityId of the object.
---@field ["gameObjectId"] string|nil GameObjectId of the object as a string (decimal or 0x-hex).
---@field ["name"] string|nil Name to search for among nearby targetable objects.
---@field ["clear"] boolean|nil Clear the focus target instead of setting it.

---@class Xiv_set_focus_target_result_focus
---@field ["entityId"] integer 
---@field ["gameObjectId"] string|nil 
---@field ["name"] string|nil 
---@field ["objectKind"] string|nil 
---@field ["distance"] number|nil 
---@field ["matchedBy"] string|nil 
---@field ["candidates"] integer|nil 

---@class Xiv_set_focus_target_result
---@field ["cleared"] boolean|nil 
---@field ["hadFocusTarget"] boolean|nil 
---@field ["focus"] Xiv_set_focus_target_result_focus|nil 

---@class Xiv_set_hud_character_page_args
---@field ["page"] "Equipment"|"Attributes"|"ClassesAndJobs"|"GearSets" Character record page.

---@class Xiv_set_hud_character_page_result
---@field ["result"] any Any JSON value.

---@class Xiv_set_hud_enabled_args
---@field ["enabled"] boolean True hides native HUD categories; false restores them.

---@class Xiv_set_hud_enabled_result
---@field ["result"] any Any JSON value.

---@class Xiv_set_map_flag_args
---@field ["x"] number|nil Map X coordinate as shown in game (roughly 1-42). Use with y.
---@field ["y"] number|nil Map Y coordinate as shown in game (roughly 1-42). Use with x.
---@field ["worldX"] number|nil World X position. Use with worldZ instead of x/y.
---@field ["worldZ"] number|nil World Z position (the horizontal axis that maps to map Y). Use with worldX.
---@field ["territoryId"] integer|nil TerritoryType row id; default is the current zone.
---@field ["mapId"] integer|nil Map row id; default is the current map of that territory.
---@field ["openMap"] boolean|nil Open the map window centred on the flag.
---@field ["title"] string|nil Optional map window title.

---@class Xiv_set_map_flag_result
---@field ["territoryId"] integer 
---@field ["mapId"] integer 
---@field ["placeName"] string|nil 
---@field ["placeNameSub"] string|nil 
---@field ["mapX"] number 
---@field ["mapY"] number 
---@field ["worldX"] number 
---@field ["worldZ"] number 
---@field ["mapOpened"] boolean 

---@class Xiv_set_plugin_enabled_args
---@field ["plugin"] string Plugin internal name (see list_plugins), or its display name.
---@field ["enabled"] boolean true loads the plugin and keeps it enabled; false unloads it and keeps it disabled.

---@class Xiv_set_plugin_enabled_result
---@field ["internalName"] string|nil 
---@field ["name"] string|nil 
---@field ["enabled"] boolean 
---@field ["changed"] boolean 
---@field ["state"] string|nil 
---@field ["loaded"] boolean 

---@class Xiv_set_target_args
---@field ["entityId"] integer|nil EntityId of the object.
---@field ["gameObjectId"] string|nil GameObjectId of the object as a string (decimal or 0x-hex).
---@field ["name"] string|nil Name to search for among nearby targetable objects.

---@class Xiv_set_target_result
---@field ["entityId"] integer 
---@field ["gameObjectId"] string|nil 
---@field ["name"] string|nil 
---@field ["objectKind"] string|nil 
---@field ["distance"] number|nil 
---@field ["matchedBy"] string|nil 
---@field ["candidates"] integer|nil 

---@class Xiv_set_terminal_panel_hidden_args
---@field ["id"] integer Panel id from list_terminal_panels.
---@field ["hidden"] boolean true hides, false shows.

---@class Xiv_set_terminal_panel_hidden_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_set_terminal_theme_args
---@field ["name"] string Theme name as GhosttyDalamud's settings list it.

---@class Xiv_set_terminal_theme_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_setup_plugins_args
---@field ["plugins"] (string)[] Exact plugin internal names, 1-12 unique entries.
---@field ["repositoryUrl"] string|nil Explicit HTTPS pluginmaster repository URL.
---@field ["channel"] "stable"|"testing"|nil Explicit release channel.

---@class Xiv_setup_plugins_result_plan_plugins_item_package
---@field ["internalName"] string|nil 
---@field ["version"] string|nil 
---@field ["apiLevel"] integer 
---@field ["downloadUrl"] string|nil 
---@field ["useTesting"] boolean 
---@field ["dependencies"] (string)[]|nil 

---@class Xiv_setup_plugins_result_plan_plugins_item
---@field ["package"] Xiv_setup_plugins_result_plan_plugins_item_package|nil 
---@field ["action"] string|nil 
---@field ["installedVersion"] string|nil 

---@class Xiv_setup_plugins_result_plan
---@field ["repositoryUrl"] string|nil 
---@field ["channel"] string|nil 
---@field ["plugins"] (Xiv_setup_plugins_result_plan_plugins_item)[]|nil 
---@field ["enableTesting"] boolean 
---@field ["note"] string|nil 

---@class Xiv_setup_plugins_result_verified_item
---@field ["internalName"] string|nil 
---@field ["version"] string|nil 
---@field ["loaded"] boolean 
---@field ["state"] string|nil 
---@field ["enabled"] boolean 

---@class Xiv_setup_plugins_result
---@field ["id"] string|nil 
---@field ["state"] string|nil 
---@field ["phase"] string|nil 
---@field ["plan"] Xiv_setup_plugins_result_plan|nil 
---@field ["verified"] (Xiv_setup_plugins_result_verified_item)[]|nil 
---@field ["error"] string|nil 
---@field ["updatedAt"] string 

---@class Xiv_share_terminal_capture_args
---@field ["path"] string|nil Capture file path, or "last" for the most recent capture.

---@class Xiv_share_terminal_capture_result
---@field ["method"] string|nil 
---@field ["via"] string|nil 
---@field ["request"] string|nil 
---@field ["completed"] boolean 
---@field ["panelId"] integer|nil 
---@field ["result"] any|nil Any JSON value.
---@field ["note"] string|nil 

---@class Xiv_show_hud_quest_on_map_args
---@field ["questId"] integer Accepted Quest sheet row ID.

---@class Xiv_show_hud_quest_on_map_result
---@field ["result"] any Any JSON value.

---@class Xiv_show_notification_args
---@field ["content"] string Body text.
---@field ["title"] string|nil Title line; defaults to "xiv-mcp".
---@field ["type"] "info"|"success"|"warning"|"error"|nil Notification type (icon and colour).
---@field ["durationSeconds"] number|nil How long it stays visible, in seconds.

---@class Xiv_show_notification_result
---@field ["title"] string|nil 
---@field ["content"] string|nil 
---@field ["type"] string|nil 
---@field ["durationSeconds"] number 
---@field ["truncated"] boolean|nil 

---@class Xiv_show_toast_args
---@field ["message"] string Text to show (single line).
---@field ["kind"] "normal"|"quest"|"error"|nil Toast style.

---@class Xiv_show_toast_result
---@field ["shown"] string|nil 
---@field ["kind"] string|nil 
---@field ["truncated"] boolean|nil 

---@class Xiv_switch_desktop_workspace_args
---@field ["workspace"] integer Workspace number (1-9).

---@class Xiv_switch_desktop_workspace_result
---@field ["gate"] string|nil 
---@field ["ok"] boolean 
---@field ["message"] string|nil 
---@field ["note"] string|nil 

---@class Xiv_take_screenshot_args
---@field ["maxDimension"] integer|nil Longer side of the returned image in pixels (64-4096). The capture is never scaled up.
---@field ["hideUi"] boolean|nil Hide the game's HUD for the capture and restore it afterwards.
---@field ["includeOverlays"] boolean|nil Include Dalamud and plugin windows (ImGui overlays). False captures the game frame only.
---@field ["addon"] string|nil Capture only this addon's rectangle (internal name from list_addons). Omit for the whole screen.
---@field ["addonPadding"] integer|nil Extra pixels around the addon rectangle (0-200).

---@class Xiv_target_party_member_args
---@field ["name"] string|nil Party member name, optionally with @World.
---@field ["slot"] integer|nil Row in the party list, 1-8 from the top.

---@class Xiv_target_party_member_result_party_item
---@field ["slot"] integer 
---@field ["name"] string|nil 
---@field ["world"] string|nil 

---@class Xiv_target_party_member_result
---@field ["slot"] integer 
---@field ["name"] string|nil 
---@field ["world"] string|nil 
---@field ["entityId"] integer 
---@field ["gameObjectId"] string|nil 
---@field ["distance"] number|nil 
---@field ["party"] (Xiv_target_party_member_result_party_item)[]|nil 

---@class Xiv_teleport_args
---@field ["aetheryteId"] integer|nil Aetheryte row id.
---@field ["name"] string|nil Aetheryte or zone name.

---@class Xiv_teleport_result
---@field ["aetheryteId"] integer 
---@field ["destination"] string|nil 
---@field ["territoryId"] integer 
---@field ["territoryName"] string|nil 
---@field ["gilCost"] integer 
---@field ["favourite"] boolean|nil 
---@field ["started"] boolean 

---@class Xiv_update_objective_args
---@field ["id"] string Objective id.
---@field ["advance"] boolean|nil Mark the current step done.
---@field ["step"] integer|nil Make this 0-based step current (steps before it done). Equal to the step count means all done.
---@field ["complete"] boolean|nil true completes the objective, false reopens it.
---@field ["note"] string|nil Short note shown under the current step; empty string clears it. Max 300 chars.

---@class Xiv_update_objective_result_steps_item
---@field ["index"] integer 
---@field ["text"] string|nil 
---@field ["done"] boolean 

---@class Xiv_update_objective_result_status
---@field ["ready"] boolean 
---@field ["summary"] string|nil 
---@field ["windowOpen"] boolean 
---@field ["inZone"] boolean|nil 
---@field ["nearSpot"] boolean|nil 
---@field ["distanceYalms"] number|nil 
---@field ["timeOk"] boolean|nil 
---@field ["weatherOk"] boolean|nil 
---@field ["currentWeather"] string|nil 
---@field ["nextWindowStartUtc"] string|nil 
---@field ["nextWindowEndUtc"] string|nil 
---@field ["minutesUntilNextWindow"] number|nil 
---@field ["problem"] string|nil 

---@class Xiv_update_objective_result
---@field ["id"] string|nil 
---@field ["title"] string|nil 
---@field ["completed"] boolean 
---@field ["currentStep"] integer 
---@field ["currentStepText"] string|nil 
---@field ["stepsDone"] integer 
---@field ["steps"] (Xiv_update_objective_result_steps_item)[]|nil 
---@field ["zone"] string|nil 
---@field ["territoryId"] integer|nil 
---@field ["mapX"] number|nil 
---@field ["mapY"] number|nil 
---@field ["spot"] string|nil 
---@field ["description"] string|nil 
---@field ["note"] string|nil 
---@field ["eorzeaTime"] string|nil 
---@field ["weather"] (string)[]|nil 
---@field ["radius"] number 
---@field ["source"] string|nil 
---@field ["createdAt"] string 
---@field ["updatedAt"] string 
---@field ["completedAt"] string|nil 
---@field ["status"] Xiv_update_objective_result_status|nil 

---@class Xiv_write_macro_args
---@field ["set"] "individual"|"shared" Which macro page to write: individual or shared.
---@field ["index"] integer Slot number 0-99 as shown in list_macros.
---@field ["title"] string Macro name, at most 20 characters.
---@field ["lines"] (string)[] Macro text, 1-15 lines, each a single line of at most 180 UTF-8 bytes.
---@field ["iconId"] integer|nil Icon id from the macro icon picker (MacroIcon sheet). Omit to keep the slot's icon.

---@class Xiv_write_macro_result_written
---@field ["title"] string|nil 
---@field ["iconId"] integer 
---@field ["lines"] (string)[]|nil 

---@class Xiv_write_macro_result_previous
---@field ["title"] string|nil 
---@field ["iconId"] integer 
---@field ["lines"] (string)[]|nil 
---@field ["restorable"] boolean 

---@class Xiv_write_macro_result
---@field ["set"] string|nil 
---@field ["index"] integer 
---@field ["written"] Xiv_write_macro_result_written|nil 
---@field ["previous"] Xiv_write_macro_result_previous|nil 

---@class XivApi
local M = {}

---Register and enable an explicit HTTPS custom plugin repository, save through Dalamud's configuration queue and refresh its native repository catalogue. No settings window, clipboard or manual paste/save steps. This adds a source of code that may run inside the game; it does not install any plugin. Existing repositories are preserved. Returns added/alreadyConfigured, enabled state and a note; use setup_plugins to install and enable exact plugins with dependencies in one operation. Requires the reviewed Dalamud bindings and a usable default collection. The legacy settingsOpened/copiedToClipboard fields remain false.
---@param args Xiv_add_plugin_repository_args
---@param callback? fun(result: Xiv_add_plugin_repository_result|nil, error: string|nil)
function M.add_plugin_repository(args, callback) end

---Appends a batch of world-coordinate destinations to the player's existing Wayfinder itinerary. Does not replace stops, start guidance, move, or teleport. Supply JSON {version:1,stops:[{territoryId,x,z,y?,label?}]}; territoryId must be explicit/nonzero, coordinates within ±5000, optional y is world height. Maximum 64 total stops, 32768 JSON characters. All stops are validated before any are appended. Use get_wayfinder_journey first to avoid duplicates; this operation is not idempotent.
---@param args Xiv_append_wayfinder_stops_args
---@param callback? fun(result: Xiv_append_wayfinder_stops_result|nil, error: string|nil)
function M.append_wayfinder_stops(args, callback) end

---Applies a saved layout by name: existing panels move to their saved places and missing ones are opened (which may start the programs the layout names); nothing is closed. NEEDS A NEWER GhosttyDalamud: written against the proposed layout.set verb, it fails with unavailable, naming the verb, until that ships. Read the layout first with get_terminal_layouts. GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_apply_terminal_layout_args
---@param callback? fun(result: Xiv_apply_terminal_layout_result|nil, error: string|nil)
function M.apply_terminal_layout(args, callback) end

---Hands a question to Almanac: its chat window opens on the player's screen and its configured model (possibly a remote service) starts answering. Returns accepted (false when Almanac is busy or not set up), NOT the answer: with today's Almanac (via=ask) the answer only appears in its window. With an Almanac that offers the JSON gate (via=call) threadId and turn come back and get_almanac_turn reads the answer. newThread=true starts a fresh conversation first and needs that newer Almanac.
---@param args Xiv_ask_almanac_args
---@param callback? fun(result: Xiv_ask_almanac_result|nil, error: string|nil)
function M.ask_almanac(args, callback) end

---What follows XivDesktop's /ask: a question (summons the speaker if needed and asks it), "" (only summon), "bye" (dismiss), or "as <preset|npc:ID|minion:ID|mount:ID|pet:ID|self> [question]" to switch speaker first. The answer streams into the in-game dialogue window for the PLAYER; it is NOT returned here (the gate answers only ok or error). The text goes to whichever model the player configured, which may be a remote service. Only the player sees the speaker; nothing is sent to game chat.
---@param args Xiv_ask_npc_assistant_args
---@param callback? fun(result: Xiv_ask_npc_assistant_result|nil, error: string|nil)
function M.ask_npc_assistant(args, callback) end

---Set or remove a local XivHud Journal bookmark for an accepted quest. Does not modify native quest tracking. Returns a requestId for get_hud_request.
---@param args Xiv_bookmark_hud_quest_args
---@param callback? fun(result: Xiv_bookmark_hud_quest_result|nil, error: string|nil)
function M.bookmark_hud_quest(args, callback) end

---Withdraws one of your pending tickets so the player is no longer asked about it. Approved or finished tickets cannot be cancelled.
---@param args Xiv_cancel_ticket_args
---@param callback? fun(result: Xiv_cancel_ticket_result|nil, error: string|nil)
function M.cancel_ticket(args, callback) end

---Asks GhosttyDalamud to record a short clip (1-30 seconds, gif or mp4) of the game frame, or of the focused panel only, optionally with the game's own UI hidden. Writes a file on the player's computer. Posted today as "/term clip …" with no result (via=post): completion cannot be confirmed until GhosttyDalamud adds capture.clip; once it does, get_terminal_capture_status shows the finished file.
---@param args Xiv_capture_terminal_clip_args
---@param callback? fun(result: Xiv_capture_terminal_clip_result|nil, error: string|nil)
function M.capture_terminal_clip(args, callback) end

---Asks GhosttyDalamud for a PNG of the frame the game just drew, including its world panels: target full (the whole frame) or panel (just the focused terminal's window); clean=true hides the game's own UI for that frame. It writes a file on the player's computer, hence Action tier. Today this is posted as the chat command "/term shot …", which returns nothing: the result says via=post and completion CANNOT be confirmed until GhosttyDalamud adds a capture.shot IPC verb (then via=call with path, width, height). To look at the screen yourself use take_screenshot and get_latest_screenshot, which return the image.
---@param args Xiv_capture_terminal_screenshot_args
---@param callback? fun(result: Xiv_capture_terminal_screenshot_result|nil, error: string|nil)
function M.capture_terminal_screenshot(args, callback) end

---Empties one User Macros slot (set individual or shared, index 0-99): title, icon and lines are removed, as with Delete in the User Macros window. Returns previous (title, iconId, lines, restorable) so the content can be written back with write_macro; wasEmpty is true when there was nothing to clear. Hotbar slots that pointed at the macro are refreshed.
---@param args Xiv_clear_macro_args
---@param callback? fun(result: Xiv_clear_macro_result|nil, error: string|nil)
function M.clear_macro(args, callback) end

---Removes one objective (id), every completed one (completedOnly=true) or all of them (no arguments). Prefer update_objective complete=true so the player sees the completion; clear afterwards. Returns removed and remaining counts.
---@param args Xiv_clear_objectives_args
---@param callback? fun(result: Xiv_clear_objectives_result|nil, error: string|nil)
function M.clear_objectives(args, callback) end

---Removes your entry (pass agent) or every entry (omit agent) from the in-game agent board. Prefer posting state done/failed over clearing so the player sees the outcome; clear only stale entries. Returns how many entries were removed and how many remain.
---@param args Xiv_clear_status_args
---@param callback? fun(result: Xiv_clear_status_result|nil, error: string|nil)
function M.clear_status(args, callback) end

---Clears the user's current target (like pressing Escape on a target). Returns whether there was a target and its name.
---@param args table<string, any>
---@param callback? fun(result: Xiv_clear_target_result|nil, error: string|nil)
function M.clear_target(args, callback) end

---Closes a panel as its close button does (panel.close): a terminal's shell and every program in it END, a remote window's stream stops, an adopted plugin window goes back to its plugin and the chat back to the game. Not undoable for terminals. To get a panel out of the way without losing it use set_terminal_panel_hidden. GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_close_terminal_panel_args
---@param callback? fun(result: Xiv_close_terminal_panel_result|nil, error: string|nil)
function M.close_terminal_panel(args, callback) end

---Compares 2-6 pieces of equipment from game data side by side: per item the itemLevel, equipLevel, category, jobs, materiaSlots, canBeHq, weapon damage / defence and every substat (critical hit, determination, direct hit rate, skill and spell speed, tenacity, piety, craftsmanship, control, CP, gathering, perception, GP), then differences — each stat where the items disagree, with every item's value, the spread and which item wins — and sameStats. hq=true uses the high-quality values where an item has them. slotWarning says so when the items do not all go in the same slot, which usually means the comparison is not meaningful. This is game data only: it does not know the character's melds or what is equipped — pair it with get_equipment and get_attributes for that.
---@param args Xiv_compare_items_args
---@param callback? fun(result: Xiv_compare_items_result|nil, error: string|nil)
function M.compare_items(args, callback) end

---Configure the existing Journal's compact screen HUD: explicit enabled/locked states, tracked quests or local bookmarks, and one to five entries. Locked panels pass clicks through; unlocked title drags and quest rows open the book. Does not modify native quest tracking or native HUD visibility. Requires Journal's journal.tracker capability; older versions return an explicit unsupported-method error. Poll get_hud_request, then inspect tracker state and visibleQuestIds. Applied preferences do not prove a rendered frame.
---@param args Xiv_configure_hud_tracker_args
---@param callback? fun(result: Xiv_configure_hud_tracker_result|nil, error: string|nil)
function M.configure_hud_tracker(args, callback) end

---Explicit HUD UI operation: open, close, settings, original, or mode. hud supports settings/close only; Journal/Character support every operation; Vitals supports open/close/settings only and does not change native HUD visibility. mode selects screen, native_frame (KamiToolKit), or world (optional Ghostty) and opens the module. World placement is Hud, Companion, World or Ground. Screen recovers the ordinary UI when an optional host fails. original opens the game's own window and closes the replacement. No synthetic key or controller input, no automatic gear changes. Poll get_hud_request, then read actual hosting state.
---@param args Xiv_control_hud_window_args
---@param callback? fun(result: Xiv_control_hud_window_result|nil, error: string|nil)
function M.control_hud_window(args, callback) end

---Pause/resume guidance, explicitly advance to the next stop, or return to the previous stop. Never walks the character. If the player enabled Wayfinder automatic teleporting, changing or resuming guidance can start Teleport and spend gil under that policy; inspect get_wayfinder_journey first. Only use next after the player confirms completion or asks to skip; arriving near a marker is not proof of task completion. Previous restores a stop without resuming paused guidance. Current guide state refreshes on the next game update.
---@param args Xiv_control_wayfinder_journey_args
---@param callback? fun(result: Xiv_control_wayfinder_journey_result|nil, error: string|nil)
function M.control_wayfinder_journey(args, callback) end

---Converts between the map coordinates the game displays (the x/y in quest guides, hunt trains and <flag> links, roughly 1-42) and the world position other tools report (worldX / worldZ). Give either x and y, or worldX and worldZ, plus the zone: territoryId or mapId (default: the player's current zone). Returns both coordinate pairs, the map's sizeFactor and flagText, a ready-to-read "Zone ( x , y )" string. Use it to turn a position from get_player, list_nearby_objects or list_fates into the numbers a human reads, or to feed set_map_flag from map coordinates you were told. No game memory is read for another zone.
---@param args Xiv_convert_coordinates_args
---@param callback? fun(result: Xiv_convert_coordinates_result|nil, error: string|nil)
function M.convert_coordinates(args, callback) end

---Acts on the host desktop through XivDesktop. method launch starts an application (argument: the app id or a search text); method window sends a window action (argument: JSON such as {"action":"focus","id":12} — actions are focus, close, pet, pin, toggle, place, move); method workspace switches to workspace N (argument: "1"-"9", "0" only reports). The bridge answers "ok: ..." or "error: ...". This starts programs on the player's computer, so it always goes through the in-game approval path.
---@param args Xiv_desktop_command_args
---@param callback? fun(result: Xiv_desktop_command_result|nil, error: string|nil)
function M.desktop_command(args, callback) end

---Reads XivDesktop's view of the host desktop. method is status (bridge health), windows (open windows with id, title, app, workspace, focused), apps (launchable applications) or palette (ranked command-palette entries for query). Read-only; nothing is launched or focused. Fails when XivDesktop is not loaded — check list_bridges. Use desktop_command to act on a window or launch an application.
---@param args Xiv_desktop_query_args
---@param callback? fun(result: Xiv_desktop_query_result|nil, error: string|nil)
function M.desktop_query(args, callback) end

---One action on a desktop window panel: focus, close (closes the window's stream and panel), pet (make it a pet), pin (pin it where the character stands), toggle (pet ↔ pin in place), place (needs pin, as /term pin takes it: "orbit 3.5", "hud 0.85 0.2" …) or move (needs workspace 1-9). id is from list_desktop_windows; 0 means the focused, else last focused, window. pin and workspace are refused with other actions.
---@param args Xiv_desktop_window_action_args
---@param callback? fun(result: Xiv_desktop_window_action_result|nil, error: string|nil)
function M.desktop_window_action(args, callback) end

---Equips one of the character's saved gear sets (which also changes class/job when the set belongs to another job), exactly like /gearset change. Select with id (the number from list_gearsets, 1-100) or name (case-insensitive; exact match preferred, otherwise a unique substring). Refused while in combat, casting, crafting, gathering, in a cutscene/event, changing zones, or when switching to a different job inside a duty. The swap is applied by the game over the next moments; call list_gearsets to confirm isCurrent. Returns the chosen set and the game's result code.
---@param args Xiv_equip_gearset_args
---@param callback? fun(result: Xiv_equip_gearset_result|nil, error: string|nil)
function M.equip_gearset(args, callback) end

---Runs one slash command as if the user typed it into the chat box, e.g. "/gearset change 3", "/hudlayout 2", "/xlplugins" or another installed plugin's command. Registered Dalamud plugin commands are dispatched through Dalamud (handledBy="plugin"); everything else goes to the game's command parser (handledBy="game"). The game does not return a result: unknown commands or failures show up as error lines in chat, so follow up with read_chat channels ["system"] when it matters. Commands that post text others can see (/say /s /party /p /alliance /fc /linkshell1-8 /l1-8 /cwlinkshell1-8 /cwl1-8 /yell /shout /tell /reply /emote /em /beginner /pvpteam /random /dice) additionally require the Chat permission tier and share send_chat's rate limit — prefer send_chat for messages. Detection ignores case, full-width characters and invisible characters and knows the localized spellings of those commands; commands registered by other plugins are not classified. Blocked outright: /logout /shutdown /quit /exit, Dalamud kill/restart/branch/language commands, xiv-mcp's own commands, and action/movement commands (/ac /action /blueaction /pvpaction /generalaction /petaction /automove /follow /lockon /facetarget) — combat and movement automation is out of scope. Must be a single line starting with '/', at most 500 UTF-8 bytes.
---@param args Xiv_execute_command_args
---@param callback? fun(result: Xiv_execute_command_result|nil, error: string|nil)
function M.execute_command(args, callback) end

---Aetherytes in a zone, nearest first, to a point given as map coordinates (x/y) or world coordinates (worldX/worldZ); with no point and a logged-in character it uses the player's position. Each entry: aetheryteId, name, territoryId, zone, map coordinates, distanceOnMap (in map units, not yalms) and isAethernetShard (city aethernet shards cannot be teleported to from outside). This is game data: it lists every aetheryte in the zone whether or not the character has attuned to it. Use list_aetherytes for what the player can actually teleport to and what it costs, then teleport.
---@param args Xiv_find_nearest_aetheryte_args
---@param callback? fun(result: Xiv_find_nearest_aetheryte_result|nil, error: string|nil)
function M.find_nearest_aetheryte(args, callback) end

---Searches every loaded container (bags, equipped, armory, crystals, currency, key items, saddlebags if opened this session, and the currently/last opened retainer's inventory, equipment and market listings) for items by name (case-insensitive substring; exact and prefix matches rank first) and/or exact itemIds, and aggregates counts per item: total quantity, HQ quantity, and a location breakdown (group, container, quantity, slots). notSearched lists container groups that are not in memory, so absence there is unknown rather than zero. Other retainers' inventories are never visible without opening them.
---@param args Xiv_find_owned_items_args
---@param callback? fun(result: Xiv_find_owned_items_result|nil, error: string|nil)
function M.find_owned_items(args, callback) end

---When a wanted weather next occurs in a zone, in real time. Weather is deterministic: it changes every 8 Eorzea hours (23m20s real time, at ET 00:00, 08:00 and 16:00) and this uses the same algorithm as get_weather_forecast, but searches ahead (up to horizonDays, default 14, max 60) instead of listing the next few windows. zone is a territory id or a zone name; weather is a name in the client language ("Rain", "Fog") or a Weather id. Optional: previousWeather (the weather of the 8-bell window before must be this, as some fish, FATE and hunt spawns require) and an Eorzea hour range eorzeaHourStart/eorzeaHourEnd (end exclusive, may wrap past midnight, e.g. 22 and 4), which trims each window to the hours that count. Returns the zone, the resolved wanted weather ids, chancePercent per window from the zone's table, possibleWeather, and windows: startUtc, endUtc, eorzeaStart/eorzeaEnd (HH:00), durationSeconds, secondsUntilStart (0 when activeNow), weather, previousWeather and windows = how many consecutive 8-bell windows were merged. Fewer than count windows means nothing more was found within the horizon. Fails with not_found when the zone has no weather table (duties, interiors) or the weather never occurs there; the message then lists what does. Times come from the host clock.
---@param args Xiv_find_weather_windows_args
---@param callback? fun(result: Xiv_find_weather_windows_result|nil, error: string|nil)
function M.find_weather_windows(args, callback) end

---Gives a panel the keyboard and brings it forward (panel.focus): a hidden panel is shown, a dropdown tab opens the dropdown, a minimized terminal is restored. Always sent with fly=false, so the character is NOT walked up to the panel and the camera is not turned (XivMcp does not move the character). The game stops receiving keys until the player presses Esc twice or clicks the world. GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_focus_terminal_panel_args
---@param callback? fun(result: Xiv_focus_terminal_panel_result|nil, error: string|nil)
function M.focus_terminal_panel(args, callback) end

---The character's achievement progress: totalInGame, completed, pointsEarned and pointsAvailable, then a filtered, paged list of {id, name, description, category, points, completed}. Filter with completed=all|completed|missing, nameContains (matches name or description) and category (case-insensitive substring of the achievement category, e.g. "Battle", "Crafting", "Quests"). The client only knows which achievements are complete after the Achievements window has been opened once this session: until then loaded=false and everything reads as missing, which the note says. Achievements hidden until unlocked are included because they are in game data.
---@param args Xiv_get_achievements_args
---@param callback? fun(result: Xiv_get_achievements_result|nil, error: string|nil)
function M.get_achievements(args, callback) end

---Details for one action id: name, tooltip description (plain text; dynamic values such as potency may appear as placeholders), icon, class/job and which classes/jobs can use it, level acquired, category (Spell, Weaponskill, Ability...), cast and recast time in seconds, range and effect radius in yalms, cast type, primary cost type/value (raw sheet values), cooldown group ids (actions sharing a group share a recast timer; group 58 is the global cooldown), max charges, role/PvP/player flags, the combo action it follows, and targeting flags.
---@param args Xiv_get_action_args
---@param callback? fun(result: Xiv_get_action_result|nil, error: string|nil)
function M.get_action(args, callback) end

---Reads every text string shown in one game UI window (addon), including text inside nested components such as lists, buttons and tabs, in reading order (top-to-bottom, left-to-right by screen position). Use it to read any open window: quest details, item tooltips (ItemDetail), retainer lists, duty finder, shop windows, etc. Get the addon name from list_addons (exact internal name; case-insensitive fallback). Each entry: nodeId, path (component node ids joined with '/', ending in the text node id), text (plain, icons/macros flattened), visible, x/y (screen position). Hidden nodes (e.g. collapsed sections, unused list rows) are skipped unless includeHidden=true. Read-only: this never clicks or changes anything.
---@param args Xiv_get_addon_text_args
---@param callback? fun(result: Xiv_get_addon_text_result|nil, error: string|nil)
function M.get_addon_text(args, callback) end

---For a runId from run_almanac_benchmark: its progress (state, done, total, currentTask) while it runs, or once done the results summary (score, successRate, toolCallValidity, tokensPerSecond, ttftMs and per-task rows). runId "last" (default) returns the most recent finished run. NEEDS A NEWER Almanac: written against the proposed Almanac.v1.Call gate; fails with unavailable, naming the missing verb, until Almanac ships it.
---@param args Xiv_get_almanac_benchmark_args
---@param callback? fun(result: Xiv_get_almanac_benchmark_result|nil, error: string|nil)
function M.get_almanac_benchmark(args, callback) end

---Which model answers in Almanac: setupComplete, model, source, baseUrlHost (host and port only, never a key), toolMode, xivMcpLinked (whether it uses this XivMcp server for tools), busy; plus backends (each model server's reachability from Almanac's last check). NEEDS A NEWER Almanac: written against the proposed Almanac.v1.Call gate; fails with unavailable, naming the missing verb, until Almanac ships it.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_almanac_model_status_result|nil, error: string|nil)
function M.get_almanac_model_status(args, callback) end

---Whether Almanac (the in-game assistant plugin) is installed, loaded and answering IPC, its ApiVersion, whether ask_almanac can work (askGate) and whether it offers the JSON call gate the thread, turn, benchmark and model tools need (callGate, with its verb list in api). Never fails for an absent plugin: bridge.unavailable says why.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_almanac_status_result|nil, error: string|nil)
function M.get_almanac_status(args, callback) end

---The turns of one Almanac conversation (role, text capped at 8000 characters, state, tools called, time), newest last. NEEDS A NEWER Almanac: written against the proposed Almanac.v1.Call gate; fails with unavailable, naming the missing verb, until Almanac ships it.
---@param args Xiv_get_almanac_thread_args
---@param callback? fun(result: Xiv_get_almanac_thread_result|nil, error: string|nil)
function M.get_almanac_thread(args, callback) end

---The state of one Almanac turn (queued|running|done|failed) and its answer text so far, by the threadId and turn ask_almanac returned. Poll it every second or two until done. NEEDS A NEWER Almanac: written against the proposed Almanac.v1.Call gate; fails with unavailable, naming the missing verb, until Almanac ships it.
---@param args Xiv_get_almanac_turn_args
---@param callback? fun(result: Xiv_get_almanac_turn_result|nil, error: string|nil)
function M.get_almanac_turn(args, callback) end

---Every attribute the client tracks for the logged-in character, as {baseParamId, name, value} — including the crafter and gatherer stats an agent needs before planning a craft: craftsmanship, control, CP, gathering, perception and GP, which are also summarised under crafting. Combat stats (strength, dexterity, vitality, intelligence, mind, piety, tenacity, direct hit rate, critical hit, determination, skill/spell speed) come back in the same list. Values already include gear, food and any active bonuses, exactly as the Character window shows them, and change when the player swaps gearset or class. Zero-valued attributes are omitted unless includeZero=true. Use with get_recipe to check whether a recipe is craftable, and with get_gathering_info for perception requirements.
---@param args Xiv_get_attributes_args
---@param callback? fun(result: Xiv_get_attributes_result|nil, error: string|nil)
function M.get_attributes(args, callback) end

---Reads one bridge's read-only IPC gates and returns each as {field, description, value, error}: for Penumbra the enabled state, mod list and collections; for Glamourer the saved design list; for Lifestream/AutoRetainer/Artisan/Deliveroo a busy or running flag; for ghostty and xivdesktop their status JSON. A gate that does not answer sets error on that field instead of failing the call. Fails only when the bridge itself is unavailable — check list_bridges first. Lists (mods, designs) can be long; use limit to cap them.
---@param args Xiv_get_bridge_state_args
---@param callback? fun(result: Xiv_get_bridge_state_result|nil, error: string|nil)
function M.get_bridge_state(args, callback) end

---One condensed snapshot for 'summarise my character': identity (name, home world and data center, title, grand company and rank, free company tag), job (abbreviation, name, role, level, synced level, max HP/MP), attributes (non-zero stats relevant to the current job as {name, value}), gear (averageItemLevel computed with the character window's rule, lowest item level slot, lowest condition %, melded materia count, and each piece with slot, itemId, name, itemLevel, hq, condition % and materia names with their stat bonus), currencies (gil, grand company seals, and the first topCurrencies non-zero balances with caps and weekly tomestone progress) and retainers (count, total gil, completed ventures; loaded=false until a summoning bell has been used this session). A section that cannot be read is omitted and explained under unavailable instead of failing the call. For full detail use get_player, get_attributes, get_equipment, get_currencies, get_retainers, get_job_levels.
---@param args Xiv_get_character_sheet_args
---@param callback? fun(result: Xiv_get_character_sheet_result|nil, error: string|nil)
function M.get_character_sheet(args, callback) end

---Unlock progress for one collection kind: mounts, minions, orchestrion (orchestrion rolls), emotes, fashionAccessories (also accepted as ornaments), triadCards (Triple Triad cards), bardings (chocobo barding), glasses (facewear styles). Returns totalInGame, owned and missing counts for the whole collection, then a filtered, paged list of {id, name, owned}: owned=all|owned|missing and nameContains (case-insensitive). The game-data list includes a few entries that cannot currently be obtained, so totals can exceed the in-game collection log counts slightly. Emotes available by default count as owned.
---@param args Xiv_get_collection_progress_args
---@param callback? fun(result: Xiv_get_collection_progress_result|nil, error: string|nil)
function M.get_collection_progress(args, callback) end

---The game's condition flags (what state the client is in). Returns active: the names of every currently set ConditionFlag (e.g. InCombat, Mounted, BoundByDuty, OccupiedInQuestEvent, WatchingCutscene, Crafting, InDutyQueue), plus convenience booleans that fold related flags together: inCombat, boundByDuty, mounted, inFlight, swimming, casting, crafting, gathering, fishing, betweenAreas (loading), inCutscene, watchingCutscene, occupiedInQuestEvent, occupied (any talk/menu/event lock), performing, dead, inDutyQueue, and isClientIdle with idleBlockedBy (the flag that blocks it). Check this before suggesting actions that need the character to be free (teleport, gearset change, crafting).
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_conditions_result|nil, error: string|nil)
function M.get_conditions(args, callback) end

---The character's currency balances: gil; Grand Company seals for the current company with its cap; and a list of currencies with category (common: ventures, MGP; tomestone: every current tomestone with weeklyAcquired/weeklyLimit on the weekly-capped one; scrip: orange/purple crafters' and gatherers' scrips, Skybuilders'; pvp: wolf marks, trophy crystals; hunt: allied/centurio seals, sacks of nuts; fate: bicolor gemstones; field: Bozjan clusters; other: cowries, faux leaves, cosmocredits, lunar credits, achievement certificates; plus any other currency the client tracks), count and cap (max) where the game defines one. Zero balances are included for listed currencies.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_currencies_result|nil, error: string|nil)
function M.get_currencies(args, callback) end

---Returns environment facts about this game client: dalamudVersion, dalamudApiLevel, dalamudScmVersion/gitHash/betaTrack when known, dalamudTrack (the beta track name, or "release" when Dalamud reports none), clientStructsGitHash, pluginSafeMode (plugins were not loaded this session; read from Dalamud's plugin manager, which is not public API, so it is omitted when unreachable), gameVersion (ffxiv) and expansionVersions, clientLanguage (game data language), dalamudUiLanguage, loggedIn, isPvP, inGpose, inCutscene, gameUiHidden, globalUiScale (the game's UI scale factor), colorTheme (System Configuration theme: dark, light, classicFF, clearBlue) and hasModifiedGameDataFiles, plus plugin counts. Use for troubleshooting or to adapt behaviour to the client's language and state.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_dalamud_info_result|nil, error: string|nil)
function M.get_dalamud_info(args, callback) end

---What the player currently sees in XivDesktop: the launcher (open, search text, view, category, page, selected and visible app ids), favourites in order, whether the palette is open and the assistant's state (summoned, speaker, busy). NEEDS A NEWER XivDesktop: written against the proposed XivDesktop.v1.Panels gate; fails with unavailable, naming it, until it ships.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_desktop_panels_result|nil, error: string|nil)
function M.get_desktop_panels(args, callback) end

---XivDesktop's health: ghostty (launching is possible), ghosttyStatus, apps (catalogue size), scanning, scannedAt, lastLaunch, lastError, summary, plus apiVersion (null until XivDesktop offers an ApiVersion gate). Check ghostty=true before launch_desktop_app.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_desktop_status_result|nil, error: string|nil)
function M.get_desktop_status(args, callback) end

---Returns whatever conversation or prompt windows are currently visible, read-only: talk (NPC speaker + dialogue text of the current Talk box), subtitle (cutscene subtitle), selectString / selectIconString (the option list of an NPC menu, plus other visible text such as the question), cutSceneSelectString (cutscene choice), selectYesno (confirmation prompt text and its button labels, Yes first), selectOk (notice text and its OK label), journalAccept (quest offer: title and visible text), journalResult (quest completion window), request (item hand-in window) and contextMenu (right-click menu entries). Fields are omitted when that window is not open; anyOpen=false means nothing is showing. It never answers, clicks or advances dialogue.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_dialogue_result|nil, error: string|nil)
function M.get_dialogue(args, callback) end

---Details for one duty (ContentFinderCondition id): name, description, content type, required level and item level, level/item-level sync, party size and role composition (tanks/healers/dps per party, number of parties), high-end/PvP flags, undersized and explorer-mode availability, whether it is in the Duty Finder, required expansion, allowed jobs, territory and zone, the quest that unlocks it (when resolvable from game data), and the Duty Roulettes it belongs to.
---@param args Xiv_get_duty_args
---@param callback? fun(result: Xiv_get_duty_result|nil, error: string|nil)
function M.get_duty(args, callback) end

---Instanced-content status. Returns inDuty (bound by duty), isDutyStarted (the duty's barrier dropped/commenced), isCompleted, isPvp, territory, territoryIntendedUse, content {id, name, contentType, levelRequired, levelSync, itemLevelRequired, itemLevelSync, partySize, isAllianceContent, highEndDuty, isPvp, dutyRecorderAllowed} from the ContentFinderCondition, tracking {lastEvent (started|wiped|recommenced|completed), enteredAtUtc, startedAtUtc, completedAtUtc, lastWipeAtUtc, recommencedAtUtc, wipes, elapsedSinceStartSeconds, observedSinceEntry (false if the plugin loaded mid-duty, so counts may be incomplete)}, director {title, objective, timeRemainingSeconds (duty timer; for some content a pre-start countdown), contentKind} and a party role summary. Use for 'how long is left', 'how many wipes', 'what duty am I in'.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_duty_state_result|nil, error: string|nil)
function M.get_duty_state(args, callback) end

---How to unlock one duty (ContentFinderCondition id from search_duties): required level and item level, level and item-level sync, expansion, and unlockQuests: each quest the game data ties to the duty (its unlock criteria, or the quest whose reward opens the instance) with quest level, journal genre, issuer NPC, issuer zone and map X/Y, and its prerequisite quests one level deep (previousQuestsJoin says whether all or any are needed). Also roulettes: the Duty Roulettes that include the duty, with the ContentRoulette id when it can be matched (see list_roulettes). unlockQuests is empty when the sheets do not name a quest: many duties unlock through a quest script instead, so empty does not mean unlocked by default. Use get_duty for party composition and description, get_quest for a quest's full details and rewards, and get_quest_status to check whether the player has completed the quests.
---@param args Xiv_get_duty_unlock_args
---@param callback? fun(result: Xiv_get_duty_unlock_result|nil, error: string|nil)
function M.get_duty_unlock(args, callback) end

---Which Duty Finder duties this character has unlocked and cleared, as far as the client knows. Each duty: dutyId (ContentFinderCondition row id, the id search_duties and get_duty use), name, contentType (Dungeons, Trials, Raids, ...), level (required level), itemLevel (required average item level), unlocked, completed (cleared at least once), contentKind (instanceContent|publicContent|other) and contentId. unlocked/completed are omitted for content kinds the client keeps no flag for. Filters: contentType (name substring or ContentType id), minLevel/maxLevel, nameContains, onlyLocked (still locked), onlyIncomplete (unlocked but never cleared). Also returns unlocked/completed counts per content type for the filtered scope. Sorted by level; paged with limit/offset. Use for 'what have I not unlocked/cleared'; use get_duty for how a duty is unlocked, and get_roulette_status for today's roulette bonuses.
---@param args Xiv_get_duty_unlocks_args
---@param callback? fun(result: Xiv_get_duty_unlocks_result|nil, error: string|nil)
function M.get_duty_unlocks(args, callback) end

---The HUD's enmity information, as a one-off snapshot. enemies: the on-screen enemy list in display order {position, name, entityId, enmityPercent (the player's own enmity on that enemy; 100 = it is attacking the player), isCurrentTarget}. targetEnmity: for the current target, who is on its enmity table {rank, name, entityId, enmity, percentOfTop, isPlayer} highest first, which is what the party list enmity bars show. Both are empty out of combat. Use for 'who has aggro' or 'what is attacking me'; use get_target for the target's HP, cast bar and statuses, and get_party for party members.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_enmity_list_result|nil, error: string|nil)
function M.get_enmity_list(args, callback) end

---The character's currently equipped gear: for each occupied slot (MainHand, OffHand, Head, Body, Hands, Legs, Feet, Ears, Neck, Wrists, RingRight, RingLeft, SoulCrystal) the item id, name, item level, equip level, HQ, condition %, spiritbond %, melded materia with stat bonus, glamour item and dyes; empty slots are listed separately. averageItemLevel is computed like the character screen: the 12 gear slots (soul crystal excluded) summed with the main hand counted again when it is two-handed and the off hand is empty, divided by 12 and floored. Also returns the current class/job and soul crystal name.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_equipment_result|nil, error: string|nil)
function M.get_equipment(args, callback) end

---Polls the plugin's bounded stream of game events and returns them oldest first. Pass afterSeq with the cursor from the previous call to get only what is new (0 or omitted returns everything still buffered). Kinds: zone (territory change), duty (started/completed/wiped/recommenced), combat (entering and leaving combat), condition (cutscene, crafting, gathering, mounted, ...), party (size changed), inventory (items added/removed/moved), level (level up), job (class/job change), session (login/logout). Each event has seq, at, kind, summary and sometimes data. The result carries cursor (pass it back), remaining (matches not returned yet), missedEvents=true when the buffer had already discarded events past your cursor, and buffered/capacity/droppedTotal. Subscribe to the ffxiv://events resource to be told when something new arrives instead of polling tightly.
---@param args Xiv_get_events_args
---@param callback? fun(result: Xiv_get_events_result|nil, error: string|nil)
function M.get_events(args, callback) end

---Where a gatherable item is found and, for timed nodes, when. Returns sources (one per GatheringItem row) with gatheringItemLevel, stars, hidden, perceptionRequired, isTimed and points: territoryId, zone, place, mapId, map coordinates (the x/y the game shows, ready for set_map_flag), radiusYalms, node level, gatheringType (Mining/Quarrying/Logging/Harvesting) and, when the node is timed, window {start, end (Eorzea HH:MM), openNow, nextStartUtc, nextEndUtc, secondsUntilStart, secondsUntilEnd} plus windowKind (unspoiled = rare pop table, ephemeral = node only exists during those bells). Times are computed from the host clock with the game's own Eorzea-time maths (1 bell = 175 real seconds), like get_weather_forecast. Items that are not gathered return gatherable=false with no sources; use get_item to see how they are obtained instead.
---@param args Xiv_get_gathering_info_args
---@param callback? fun(result: Xiv_get_gathering_info_result|nil, error: string|nil)
function M.get_gathering_info(args, callback) end

---The character's glamour plates (the Glamour Dresser plate slots) with, per plate, plateNumber, empty, filledSlots and the occupied slots as {slot, itemId, name, hq, dye1, dye2}. Slots are MainHand, OffHand, Head, Body, Hands, Legs, Feet, Ears, Neck, Wrists, RingRight, RingLeft; empty slots are left out. The client only holds plate data after the Glamour Plate window has been opened once this session: until then loaded=false and the list is empty, which the note explains. Read-only — this never applies a plate. Pass plateNumber to return one plate, or includeEmpty=true to see unused plates too.
---@param args Xiv_get_glamour_plates_args
---@param callback? fun(result: Xiv_get_glamour_plates_result|nil, error: string|nil)
function M.get_glamour_plates(args, callback) end

---Where the player is in the housing system: inHousingArea, territoryId/zone, ward (1-based), plot (1-based, null in an apartment or subdivision entrance), division (1 = main area, 2 = subdivision), room (apartment/FC room number), houseId (64-bit, as a string), inside/outside/inWorkshop, hasPermissions (the character may place or move furnishings here) and the player's freeCompanyTag. Everything is null or false when the character is not in a housing district or estate. Use list_aetherytes for the housing destinations the character can teleport to, and get_location for the general position.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_housing_info_result|nil, error: string|nil)
function M.get_housing_info(args, callback) end

---Read all XivHud modules independently: installed/loaded versions, versioned IPC capabilities, native HUD requested/applied visibility, Journal selection/search/bookmarks and compact tracker preferences/visible quest IDs, Character page, passive Vitals preview/lock/panel diagnostics, data readiness, requested versus actual screen/native-frame/world hosting, focus and controller status. Missing or old modules return their own errors without hiding healthy modules. Windowing is a bundled shared library, not a separately installed plugin. Character and quest facts remain available through get_character_sheet/get_quest_journal. Reads neither open windows nor capture controller input; snapshots include observedAt.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_hud_family_status_result|nil, error: string|nil)
function M.get_hud_family_status(args, callback) end

---Read one XivHud module's capabilities and immutable state snapshot, including window hosting, UI selection, controller focus and data errors. Returns an error field for an absent, unloaded or incompatible module. Does not open its UI.
---@param args Xiv_get_hud_module_status_args
---@param callback? fun(result: Xiv_get_hud_module_status_result|nil, error: string|nil)
function M.get_hud_module_status(args, callback) end

---Poll a HUD module request by requestId. States: queued, applied, refused (with error). Keeps the latest 64 completed results until plugin reload; not found does not prove an operation failed. Check the module snapshot before retrying. Applied confirms module processing; actual host presentation is reported separately.
---@param args Xiv_get_hud_request_args
---@param callback? fun(result: Xiv_get_hud_request_result|nil, error: string|nil)
function M.get_hud_request(args, callback) end

---Lists items in the character's containers, slot by slot. containers selects groups: bags (4 main inventory pages), equipped, armory (armoury chest), crystals, currency, keyItems, saddlebag, premiumSaddlebag, retainer (pages + crystals of the retainer currently/last opened), retainerEquipped, retainerMarket (with listing prices), or all (default: bags). Each entry has container, group, slot, itemId, name, quantity, and when applicable hq, collectable + collectability, item level, condition % and spiritbond % (gear), materia with stat bonus, glamour item, dyes. Containers that are not in client memory are listed under unavailable with the reason (saddlebags need to have been opened this session; retainer containers need a retainer opened at a summoning bell). Output is paged (limit/offset) with per-container size/used counts. To locate specific items across all containers prefer find_owned_items.
---@param args Xiv_get_inventory_args
---@param callback? fun(result: Xiv_get_inventory_result|nil, error: string|nil)
function M.get_inventory(args, callback) end

---Full game-data record for one item id: name, description, icon, UI and market categories, item level, equip level and jobs, equip slots, rarity, stack size, flags (unique, untradable, marketable, HQ-able, collectable, glamour, dyeable, materia slots), vendor buy price (only when a gil shop sells it) and sell price, desynthesis/aetherial reduction flags, weapon/armor base stats and bonus stats (with HQ values), gil vendors (NPC, shop, zone and map X/Y; first 10), currency exchanges (shop, costs such as tomestones or scrips; first 10), recipes that craft it, recipes that use it (first 25 with total), and gathering sources (level, stars, zones). Use search_items to find the id; get_recipe for full crafting trees. Vendor locations use the NPC's first placement and may be missing for event NPCs.
---@param args Xiv_get_item_args
---@param callback? fun(result: Xiv_get_item_result|nil, error: string|nil)
function M.get_item(args, callback) end

---Where an item comes from, as far as the game data says. Returns kinds (the source types found, in the order a player would try them: gilVendor, gathering, crafting, specialShop, gcSeals, retainerVenture, quest, achievement; [other] when the sheets know none), gilPrice (vendor price each, when sold for gil), recipes that make it (recipeId, craftType, level, stars, yield), gathering (per GatheringItem: level, stars, hidden, perception and node points with zone, place, node level, type Mining/Quarrying/Logging/Harvesting and timed = unspoiled|ephemeral), vendors (NPC name and id, shop, price in gil, location with zone and map X/Y when the NPC has a placement), exchanges (special shops: shop name, receiveCount, costs as currency or item ids with amounts, NPCs), gcSeals (Grand Company seal price and required rank id), ventures (targeted retainer ventures: retainer level, jobs, venture cost, duration, quantities), quests that reward it (count, optional = one of several choices) and achievements. The long lists (vendors, exchanges, ventures, quests, achievements) each come as {total, truncated, results} and share limit/offset. NOT covered, because the sheets do not hold it: monster drops, treasure, duty loot, random retainer ventures, fishing, desynthesis, FC credit shops, events. Use get_item for the item's stats, get_gathering_info for node coordinates and time windows, get_recipe_tree for what a craft needs, and get_market_prices for the market board.
---@param args Xiv_get_item_sources_args
---@param callback? fun(result: Xiv_get_item_sources_result|nil, error: string|nil)
function M.get_item_sources(args, callback) end

---What an item is good for, so the player can decide whether to keep, sell or turn it in. Returns recipes that consume it (recipeId, the crafted item, craftType, level, quantity = amount one synth uses), tradeIns (special shops that take it as payment: amount, what they give, other costs, NPCs), leves (tradecraft levequests asking for it: leve name, level, jobs, count per turn-in, repeats), gcSupply (Grand Company supply and provisioning missions that can ask for it: class level, crafter or gatherer, count) and the flags desynthesizable, aetherialReducible, isCollectable, isCrystal, isMarketable, isUntradable, plus vendorSellPrice in gil. recipes, tradeIns and leves each come as {total, truncated, results} and share limit/offset. NOT covered: quest hand-ins, custom deliveries, expert delivery, housing and glamour uses. Use get_item_sources for the opposite question and get_item for stats.
---@param args Xiv_get_item_uses_args
---@param callback? fun(result: Xiv_get_item_uses_result|nil, error: string|nil)
function M.get_item_uses(args, callback) end

---The current job's gauge (the job-specific resource UI: e.g. PLD oath, WAR beast gauge, BLM astral fire/umbral ice and polyglot, SAM sen/kenki, VPR rattling coils/serpent offerings, PCT palette/canvas/motifs). Returns job, gaugeType (e.g. "BLMGauge") and values: every public property of Dalamud's typed gauge by name, with enums as strings and timers in the raw units the game stores (usually milliseconds). Base classes (GLA, THM, ...) report their job's gauge. hasGauge=false for crafters, gatherers and Blue Mage. Read-only; no rotation advice or automation.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_job_gauge_result|nil, error: string|nil)
function M.get_job_gauge(args, callback) end

---Every combat class/job, crafter and gatherer with the logged-in character's level and experience. Each entry: id, abbreviation, name, role (tank|healer|melee|physicalRanged|magicalRanged|crafter|gatherer), type (class|job|limitedJob), parentClass (e.g. GLA for PLD — a job shares level/exp with its base class), level (0 = never leveled), experience, experienceToNext, progressPercent, isMaxLevel (null for limited jobs such as Blue Mage, whose cap differs), unlocked (jobs with a base class require their unlock quest) and isCurrent. Also returns currentJob, currentLevel, the account's maxLevel and unlockedCount. Use for 'what level is my X', 'which jobs can I play', or picking a job for content with a level requirement.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_job_levels_result|nil, error: string|nil)
function M.get_job_levels(args, callback) end

---Returns the newest screenshot the player has already saved (the files the game writes when they press the screenshot key), as a PNG/JPEG image plus fileName, directory, modifiedUtc and fileBytes. It only reads files — it never takes a new picture; use take_screenshot for that. The folder is the game's ScreenShot Dir setting, or <game user folder>/screenshots. maxDimension downscales the longer side (64-4096, default 1024). maxAgeSeconds rejects anything older, so an agent can ask 'the shot the player just took' without picking up last week's. Fails when the folder does not exist or holds no image.
---@param args Xiv_get_latest_screenshot_args
---@param callback? fun(result: any|nil, error: string|nil)
function M.get_latest_screenshot(args, callback) end

---Where the player is. Returns territory {id, name, internalName, region, zone, intendedUseId, intendedUse (e.g. Town, Overworld, Dungeon, Raid1, HousingOutdoor, Eureka...), isPvp, mountsAllowed}, map {id, name}, area and subArea place names (the text under the minimap), instance (shard number, 0 when the zone is not instanced), duty (content finder condition when inside instanced content), position {x,y,z}, mapCoordinates as shown on the in-game map, current weather {id, name}, housing {area, ward, plot, room, division, inside, inWorkshop} when in a housing district (ward/plot are 1-based as shown in game), inSanctuary (resting/logout area), canFly (flying unlocked in this zone and not currently disabled), and the nearest aetheryte and aethernet shard on this map by map distance, with unlocked flags. Use for 'where am I' and before teleport/route advice.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_location_result|nil, error: string|nil)
function M.get_location(args, callback) end

---Current market-board listings and recent sales for up to 20 items, from the public Universalis crowd-sourced database (universalis.app) over the host's internet connection — NOT from the player's own market board window, so the data is only as fresh as the last time some player uploaded it (lastUploadUtc tells you when). scope is a world ("Gilgamesh"), a data centre ("Aether") or a region ("North-America"); omit it to use the character's current world. Per item you get minPrice/minPriceNq/minPriceHq, averagePrice*, nq/hqSaleVelocityPerDay (units sold per day), unitsForSale, unitsSold, then listings (cheapest first: pricePerUnit, quantity, total, hq, retainerName, world, materiaCount) and recentSales (newest first). Untradable items come back with marketable=false and no prices. Results are cached for about three minutes to stay polite to a community service. Use search_items or get_item to turn a name into an item id first.
---@param args Xiv_get_market_prices_args
---@param callback? fun(result: Xiv_get_market_prices_result|nil, error: string|nil)
function M.get_market_prices(args, callback) end

---The player's party. mode is solo | party | crossRealmParty | alliance. members (the 8-slot party list; empty when solo) each have index, name, contentId (string), entityId, homeWorld, job {abbreviation, name, role}, level, hp/mp {current, max, percent}, territory and inSameTerritory, objectLoaded (in object range), position, mapCoordinates and distance when in the same zone, isLeader, isSelf. allianceMembers lists the other alliance parties' members with allianceGroup (0-based) inside alliance raids. crossRealmMembers comes from the cross-world party list (name, worlds, job, level, leader) and is the only source outside instances when a cross-world Party Finder group is not in the same zone. buddies lists your chocobo companion (kind chocobo), pet and battle buddies such as trust/squadron NPCs (kind battleBuddy). composition counts tanks/healers/melee/physicalRanged/magicalRanged. size and leaderName summarize. Use for 'who is in my party', party roles, and checking members' HP or distance.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_party_result|nil, error: string|nil)
function M.get_party(args, callback) end

---Snapshot of the logged-in player character. Returns name, entityId, contentId (string), home/current world with data center (isWorldVisiting when they differ), job {id, abbreviation, name, role}, level plus syncedLevel when level-synced, hp/mp (and cp/gp on crafters/gatherers) as {current, max, percent}, shieldPercent, world position {x,y,z}, mapCoordinates {x,y,z} as displayed on the in-game map, rotation {radians, headingDegrees (0=N, 90=E), compass}, territory and map {id, name}, online status, grand company with rank name, free company tag, title, current mount/minion, isCasting with cast details, inCombat, isDead, weaponDrawn and every active status {id, name, param, stacks, remainingSeconds, isPermanent, source}. Use this first to answer anything about 'me'/'my character'; use get_location for zone details and get_job_levels for all jobs.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_player_result|nil, error: string|nil)
function M.get_player(args, callback) end

---Read a repository catalogue and installed state to plan installation, updates and enabling of exact plugin internal names, including same-repository XivMcpDependencies. No repository, testing setting, profile, plugin or window is changed. Defaults to our published FFXIV repository. channel testing uses a published testing package when present, otherwise stable; stable refuses testing-exclusive plugins. Development builds need an explicitly published development repository URL. Bundled DLL dependencies are supplied by packages. Refuses duplicate/dev installations, source replacement, collection conflicts, incompatible API versions and replacing the running MCP server. Use setup_plugins to apply and get_plugin_setup_status to poll.
---@param args Xiv_get_plugin_setup_plan_args
---@param callback? fun(result: Xiv_get_plugin_setup_plan_result|nil, error: string|nil)
function M.get_plugin_setup_plan(args, callback) end

---Read one automatic plugin setup operation by id. Includes queued/running/complete/failed/cancelled, current phase, planned packages, individually observed loaded versions, enabled state and partial failure details. Complete means every planned plugin was verified loaded at least at its planned version. A queued/running request is not success; a failed operation may already have registered a repository or installed earlier packages. Status history retains at most 32 operations until MCP reload. This read never starts or retries setup.
---@param args Xiv_get_plugin_setup_status_args
---@param callback? fun(result: Xiv_get_plugin_setup_status_result|nil, error: string|nil)
function M.get_plugin_setup_status(args, callback) end

---Best-effort copy of Dalamud's Plugin Statistics window (/xlstats). draw: per loaded plugin the UI draw time in milliseconds (lastMs, averageMs over Dalamud's rolling window, maxMs), sorted by averageMs descending. framework: per Framework.Update handler the run time in milliseconds (lastMs, averageMs, maxMs, samples; up to 1000 samples each), keyed handler = "Type::Method" as Dalamud records it, sorted by averageMs descending. Dalamud only measures while the player has switched on draw-time tracking and framework-update tracking in that window: drawTrackingEnabled / frameworkTrackingEnabled say so, and with tracking off the numbers are stale or empty (this tool never switches tracking on). All of this is Dalamud-internal, not public API: a part that cannot be reached on this build is omitted with drawAvailable/frameworkAvailable=false, and when neither can be reached the tool fails with unavailable. Hook statistics are not included.
---@param args Xiv_get_plugin_stats_args
---@param callback? fun(result: Xiv_get_plugin_stats_result|nil, error: string|nil)
function M.get_plugin_stats(args, callback) end

---Static details for one quest id: name, level, allowed classes/jobs, expansion, journal genre/category/section, place name, issuer NPC with zone and map X/Y coordinates (when the issuer has a placement in game data), prerequisite quests (previousQuestsJoin tells whether all or any are required), quests that lock it out, class/job unlocked, grand company or beast tribe requirements, repeatability, and rewards (gil, currency, guaranteed and optional items with counts, emote, action, general actions, unlocked instance content). Experience rewards are not computed. Accepts ids with or without the 65536 base.
---@param args Xiv_get_quest_args
---@param callback? fun(result: Xiv_get_quest_result|nil, error: string|nil)
function M.get_quest(args, callback) end

---The quests the character has accepted, as the Journal lists them: questId (Quest sheet row id), name, sequence (the client's step counter; 255 = all steps done, readyToComplete=true), objectives (the journal to-do text for the current step, looked up in game data; objectiveResolved=false when it could not be matched, then rely on sequence), level, genre and category (journal headings), priority (marked as priority in the journal), tracked (shown in the duty list on screen), daily/dailyCompleted for tribal dailies, repeatable and acceptedAs (the job it was accepted on). Priority and tracked quests sort first. allowances has accepted quest count out of 30, tribal (beast tribe) daily allowances remaining out of 12, accepted levequests and leve allowances with the next allowance time. Paged with limit/offset. Use this for 'what am I in the middle of'; use get_quest_status to test specific quest ids (including completed ones) and get_quest for static quest data such as rewards and prerequisites.
---@param args Xiv_get_quest_journal_args
---@param callback? fun(result: Xiv_get_quest_journal_result|nil, error: string|nil)
function M.get_quest_journal(args, callback) end

---For each quest id (Quest sheet row id; short ids below 65536 are accepted): whether the character has completed it, whether it is currently accepted (in the journal) and its current sequence step, plus name and whether it is repeatable. Unknown ids return exists=false. Use search_quests to find quest ids by name. Up to 200 ids per call.
---@param args Xiv_get_quest_status_args
---@param callback? fun(result: Xiv_get_quest_status_result|nil, error: string|nil)
function M.get_quest_status(args, callback) end

---Crafting recipe for an item (itemId) or a specific recipe (recipeId): craft type (Carpentry, Smithing, ... Cooking), recipe level and stars, durability, difficulty (progress), max quality, required craftsmanship/control, HQ/quick-synth flags, expert and specialist requirements, the master recipe book needed (if any), and the ingredient tree expanded `depth` levels (intermediate ingredients that are themselves craftable get their own sub-ingredients). Also returns an aggregated shopping list: rawMaterials (everything to buy/gather, crystals flagged) and intermediateCrafts (sub-recipes with number of synths), computed for `quantity` finished items and respecting recipe yields. Tree quantities are per branch; the shopping list pools shared intermediates. When an item has several recipes (different crafters) the first is used and the others are listed in alternativeRecipes. Does not consider what the player already owns.
---@param args Xiv_get_recipe_args
---@param callback? fun(result: Xiv_get_recipe_result|nil, error: string|nil)
function M.get_recipe(args, callback) end

---Everything needed to craft `quantity` of an item (itemId) or of one recipe (recipeId), expanded all the way down: every craftable ingredient is expanded into its own sub-recipe until only raw materials remain (maxDepth levels at most, a cycle guard, and a cap of 400 tree nodes; depthLimited/nodeCapHit/hasCycle tell when a cap cut the tree). Returns the root recipe (craftType, level, stars, yield, crafts = synths needed, surplus = extra items the last synth makes), tree (per node: itemId, name, quantity for that branch, and for crafted nodes recipeId, craftType, level, stars, crafts, yield; notExpanded = depth|cycle|nodeCap when a craftable node was left as a leaf), craftOrder (every sub-craft pooled across branches, deepest first, with crafts/needed/surplus), crafterRequirements (highest recipe level per crafter class, root included), rawMaterials and crystals. Each raw material carries its total quantity and sources in preference order (gilVendor, gathering, crafting, specialShop, gcSeals, retainerVenture, quest, achievement, or other when the game data knows no source: monster drops, treasure, duty chests), plus gilPriceEach/gilTotal and one vendor with zone and map coordinates when a gil shop sells it, a gathering hint (type, level, zone, timed), the first special-shop exchange with its currency cost, and gcSealsEach. gilForVendorMaterials sums the vendor-buyable lines. Quantities respect recipe yields. Use get_recipe instead for the craft stats of a single recipe (durability, difficulty, quality), get_item_sources for every source of one material, and find_owned_items to subtract what the player already has (this tool never reads the inventory).
---@param args Xiv_get_recipe_tree_args
---@param callback? fun(result: Xiv_get_recipe_tree_result|nil, error: string|nil)
function M.get_recipe_tree(args, callback) end

---The character's retainers in display order: id, name, whether the slot is available (subscription), class/job and level, gil held, number of items in its inventory and on the market board, market listing expiry, market town, and the current venture (id, name, completion time, whether complete, minutes remaining). Data comes from the client's retainer list, which is only populated after a summoning bell has been used this session; loaded=false with a note means that has not happened yet. Also names the retainer whose inventory is currently in memory (activeRetainer), which get_inventory/find_owned_items can read.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_retainers_result|nil, error: string|nil)
function M.get_retainers(args, callback) end

---Which Duty Finder roulettes have already given their daily completion bonus this reset. Returns each roulette as {id, name, requiredLevel, bonusClaimed, inDutyFinder}, plus counts and nextDailyResetUtc / secondsUntilReset (15:00 UTC). bonusClaimed=false means the adventurer-in-need and daily bonus rewards are still outstanding for that roulette — it does not check whether the character actually meets the level or unlock requirements. Use get_duty_state for what the player is currently inside, and search_duties for the duties a roulette can pick.
---@param args Xiv_get_roulette_status_args
---@param callback? fun(result: Xiv_get_roulette_status_result|nil, error: string|nil)
function M.get_roulette_status(args, callback) end

---Describes this XivMcp server: plugin version, endpoint, running state, connected clients, which permission tiers are currently allowed (read, ui, action, chat — and whether state-changing calls need in-game approval: permissions.confirmActions is the player's single approval switch), host ("plugin" inside the running game, "standalone" before the game starts: there only availability=static tools work and the rest answer game_not_running), each tool category with its enabled flag and tool count, Dalamud and game versions, client language, whether a character is logged in and the MCP protocolVersion negotiated for this call. Call this first to learn what you can do before planning; a tier or category that is off means its tools are unavailable until the player enables them in /xivmcp settings.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_server_info_result|nil, error: string|nil)
function M.get_server_info(args, callback) end

---Reads one row of any game Excel sheet by sheet name and row id and returns it as JSON: numbers/bools as values, text as plain strings, RowRef links as {rowId, sheet, name} (name is the linked row's Name/Singular when it has one; links are not followed further), arrays as JSON arrays and nested structs as objects. Subrow sheets take subrowId (default 0) and report subrowCount. Sheets without typed definitions return columns as col0, col1, .... Use columns to return only some fields and includeUnknown=false to drop Unknown* columns. Prefer dedicated tools (get_item, get_action, get_quest, get_duty, get_recipe) when they exist.
---@param args Xiv_get_sheet_row_args
---@param callback? fun(result: Xiv_get_sheet_row_result|nil, error: string|nil)
function M.get_sheet_row(args, callback) end

---What the player is targeting. Returns target (hard target), targetOfTarget (whoever the target is targeting), softTarget, focusTarget and mouseOver (object under the cursor or its nameplate); each is omitted when empty. Every entry has kind (player|battleNpc|eventNpc|eventObj|treasure|aetheryte|gatheringPoint|companion|...), subKind, name, entityId, gameObjectId (string), baseId (BNpcBase/ENpc/EObj row id), nameId (BNpcName row id for NPCs), level, hp/mp {current,max,percent}, job, home/current world and FC tag for players, distance (3D), horizontalDistance, edgeDistance (horizontal minus both hitbox radii, roughly what action range checks use), position {x,y,z}, mapCoordinates, rotation, isTargetable, isDead, isHostile, inCombat, party/alliance/friend flags, whom it is targeting, cast {actionId, actionName, elapsed/total/remaining seconds, interruptible} and up to statusLimit statuses. Use for 'what is this', 'how far is my target', 'what is it casting'.
---@param args Xiv_get_target_args
---@param callback? fun(result: Xiv_get_target_result|nil, error: string|nil)
function M.get_target(args, callback) end

---Whether GhosttyDalamud is recording, and its last screenshot or clip (kind, path, size, time, error). This is how a capture_terminal_* call is confirmed. NEEDS A NEWER GhosttyDalamud: fails with unavailable, naming the proposed capture.status verb, until it ships.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_terminal_capture_status_result|nil, error: string|nil)
function M.get_terminal_capture_status(args, callback) end

---The current arrangement of GhosttyDalamud panels as a layout description: per panel its view, pet order and, where the snapshot allows, the pin argument that would put a panel there again (pin, for place_terminal_panel/open_terminal), with reproducible and a how sentence. This is RECONSTRUCTED: GhosttyDalamud has no layout.get, and its snapshot omits the numbers behind a place (a pin's world position, an orbit's distance, a HUD dock's X/Y), so only pets are exact. For saved, named layouts use get_terminal_layouts (needs a newer GhosttyDalamud).
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_terminal_layout_result|nil, error: string|nil)
function M.get_terminal_layout(args, callback) end

---GhosttyDalamud's saved, named layouts (panels with kind, profile or run/match, view, exact pin arguments, order, size) and which is current; name narrows to one. NEEDS A NEWER GhosttyDalamud: it reads the proposed layout.get verb and fails with unavailable, naming that verb, until GhosttyDalamud ships it. Until then get_terminal_layout reconstructs the current arrangement approximately.
---@param args Xiv_get_terminal_layouts_args
---@param callback? fun(result: Xiv_get_terminal_layouts_result|nil, error: string|nil)
function M.get_terminal_layouts(args, callback) end

---GhosttyDalamud's leak watch: memory samples per core load and the growth per load. NEEDS A NEWER GhosttyDalamud: today this goes to the plugin log only; fails with unavailable, naming the proposed leakwatch.report verb, until it ships.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_terminal_leakwatch_report_result|nil, error: string|nil)
function M.get_terminal_leakwatch_report(args, callback) end

---The outcome of a queued GhosttyDalamud change, by the request id a terminal tool returned: state done (with result, e.g. {id: panel}), failed (with GhosttyDalamud's error text) or unknown (not run yet, or no longer among the last 16 outcomes it keeps). Only needed when a change tool came back with completed=false.
---@param args Xiv_get_terminal_request_args
---@param callback? fun(result: Xiv_get_terminal_request_result|nil, error: string|nil)
function M.get_terminal_request(args, callback) end

---GhosttyDalamud's last self-test report (build stamp, per-suite pass/fail/skip counts, failed cases) and whether a run is in progress. NEEDS A NEWER GhosttyDalamud: the report is a file on the player's disk today; this fails with unavailable, naming the proposed selftest.report verb, until it ships.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_terminal_selftest_report_result|nil, error: string|nil)
function M.get_terminal_selftest_report(args, callback) end

---GhosttyDalamud's health in one call: status (its one-line text, e.g. "ghostty 3"), agent (the desktop agent that streams windows: connected, version, windows_ok, agent address, window_lists), focus (the world panel with the keyboard, {id: 0} when none) and api (its verb list; null until GhosttyDalamud offers api.version). Check agent.windows_ok before open_terminal with run. Fails with unavailable when it is not loaded.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_terminal_status_result|nil, error: string|nil)
function M.get_terminal_status(args, callback) end

---Returns one of your approval tickets: state (pending, approved, executed, failed, denied, cancelled, expired), who decided, your resumeToken, and once it ran the tool result (result, same shape as a tools/call result) or error. Final states are executed, failed, denied, cancelled and expired. Finished tickets are kept for 7 days.
---@param args Xiv_get_ticket_args
---@param callback? fun(result: Xiv_get_ticket_result|nil, error: string|nil)
function M.get_ticket(args, callback) end

---Current Eorzea time and the real-world reset schedule. Returns eorzea {time "HH:MM", hour, minute, bell, isDaytime (06:00-18:00), year, month, monthName (e.g. "3rd Astral Moon"), day (sun 1-32), moonPhase, isOverridden (the client clock is frozen/overridden, e.g. in some cutscenes), secondsUntilNextBell, secondsUntilNextWeatherChange}, serverTimeUtc (from the game server clock when available), localTime with timezone, and resets: dailyReset (15:00 UTC: roulettes, tribal quests), weeklyReset (Tuesday 08:00 UTC: raids lockouts, Wondrous Tails, custom deliveries), grandCompanyReset (20:00 UTC: GC supply/provisioning missions), leveAllowances (every 12h at 00:00/12:00 UTC), each with nextUtc and secondsUntil. Use for timed nodes, weather windows and 'when does X reset'.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_time_result|nil, error: string|nil)
function M.get_time(args, callback) end

---A compact overview like the header of Dalamud's troubleshooting pack: dalamudVersion, dalamudTrack, dalamudApiLevel, gameVersion, clientLanguage, dalamudUiLanguage, hostPlatform and isWine, pluginSafeMode, installed/loaded/thirdParty/dev/testing plugin counts, and lists of internal names that need attention: notLoaded, failedToLoad (state LoadError or DependencyResolutionFailed), outdated, orphaned, banned, decommissioned, updateAvailable. logErrorsLastHour counts error and fatal log entries of the last 60 minutes per plugin tag (untagged lines count as Dalamud), from the last 4 MiB of dalamud.log; logAvailable=false when the log could not be read. customRepositoryCount/enabledCustomRepositoryCount give the number of custom plugin repositories, never their URLs (list_plugin_repositories has those). failedToLoad, updateAvailable, pluginSafeMode and the repository counts come from Dalamud internals and are omitted when this Dalamud build does not expose them. Nothing here contains paths, addresses or tokens. Start here when the player says a plugin is broken, then read_plugin_log for that plugin.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_troubleshooting_summary_result|nil, error: string|nil)
function M.get_troubleshooting_summary(args, callback) end

---Returns how Dalamud draws plugin windows: globalScale (Dalamud's global UI scale, 1.0 = 100 %; not the game's HUD scale, which get_dalamud_info reports as globalUiScale), defaultFont (English description of the default font, e.g. "Game: Axis (12pt)"), defaultFontSizePx/defaultFontSizePt/defaultFontLineHeightPx, usesGameFont (true when the default font is one of the game's own fonts rather than a Dalamud or system font), styleName (the chosen Dalamud style/theme, e.g. "Dalamud Standard"; omitted when Dalamud reports none) and the UI-hide switches this plugin runs under. Public Dalamud API only. Use it when advising on window sizes or unreadable text in plugin windows.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_ui_info_result|nil, error: string|nil)
function M.get_ui_info(args, callback) end

---Reads XivWayfinder's saved stops, zero-based progress index and running state. Also returns its current walking/teleport instructions and automatic-teleport policy when supported. Check that policy before changing guidance: opted-in auto-Teleport may spend gil. Stops before index have been advanced past, not necessarily completed. Requires a compatible loaded XivWayfinder; no assembly dependency.
---@param args table<string, any>
---@param callback? fun(result: Xiv_get_wayfinder_journey_result|nil, error: string|nil)
function M.get_wayfinder_journey(args, callback) end

---Weather forecast for a zone computed with the game's own deterministic weather algorithm (weather changes every 8 Eorzea hours = 23m20s real time, at ET 00:00, 08:00 and 16:00). Returns territory, possibleWeather with chancePercent from the zone's WeatherRate, and forecast: count consecutive windows starting with the current one, each {weatherId, name, startUtc, endUtc, eorzeaStart, secondsUntilStart (negative for the current window), isCurrent}. territoryId defaults to the current zone (requires login); pass a TerritoryType id (see game data tools) to forecast any zone without being logged in. Instanced duties usually have fixed/scripted weather and are rejected. currentWeatherInGame is included when forecasting the zone the player is in.
---@param args Xiv_get_weather_forecast_args
---@param callback? fun(result: Xiv_get_weather_forecast_result|nil, error: string|nil)
function M.get_weather_forecast(args, callback) end

---Static details of one zone (territoryId, or zone = a name): name, region, internalName (the level path id such as s1f1), kind (city, field, inn, housing, duty, pvp, other) with the raw intendedUse id, expansion, the duty it hosts, isPvp, mountsAllowed, its maps (mapId, path like s1f1/00, sub-name for floors, sizeFactor where 100 = a 41x41 coordinate grid, offsets, isDefault), aetherytes and aethernet shards (isShard) with the map X/Y the game shows, the weather table (weatherRateId and each weather with chancePercent; empty when weather is fixed or scripted), and markers: the named labels drawn on the zone's maps (settlements, landmarks, exits to neighbouring zones) with map X/Y, icon and dataType (1 = link to another map, 3 = aetheryte, 4 = place tooltip, which aethernet shards use), paged with markerLimit/markerOffset as {total, truncated, results}. Coordinates are ready for set_map_flag. Nothing here depends on the character: use get_location for where the player is, list_aetherytes for unlocked teleports and find_weather_windows or get_weather_forecast for when a weather occurs.
---@param args Xiv_get_zone_info_args
---@param callback? fun(result: Xiv_get_zone_info_result|nil, error: string|nil)
function M.get_zone_info(args, callback) end

---What is going on in the zone the player is standing in, right now, in one call: territoryId, zone and region names, intendedUse (Town, Overworld, Dungeon, HousingOutdoor, ...), map, area/subArea place names, instance (the instance number when the zone is split into instances; omitted otherwise), current weather, the player's map coordinates, inSanctuary, inDuty + duty, inHousingDistrict + housing {area, ward, plot, room, inside}, isPvp, canFly, fates {active count, currentFateId, nearest topFates with level, state, progressPercent, timeRemainingSeconds, hasBonus, mapCoordinates, distance}, and the attuned aetherytes in this zone with teleport cost, plus the nearest aetheryte. A part that cannot be read is listed under unavailable instead of failing the call. This is the digest; use get_location, list_fates, list_aetherytes, get_weather_forecast or get_duty_state for the full detail of one part. Also served as resource ffxiv://zone/current.
---@param args Xiv_get_zone_live_args
---@param callback? fun(result: Xiv_get_zone_live_result|nil, error: string|nil)
function M.get_zone_live(args, callback) end

---Changes a GhosttyDalamud terminal panel. method is one of: window.open (params: run | match | wid, optional pin such as "here", "me 2 1.7", "target", "orbit 3.5", "hud X Y", "pet"), window.close {id}, window.focus {id}, window.hide {id, hidden}, window.toggle_pet {id}, window.place {id, pin}, terminal.new {profile, pin}, focus.cycle {dir}, agent.windows.refresh. params is a JSON object as text. The bridge validates and queues the change and answers {queued: true, request: N}; the outcome shows up in ghostty_query window.list under requests. This changes the player's screen, so it goes through the normal in-game approval.
---@param args Xiv_ghostty_command_args
---@param callback? fun(result: Xiv_ghostty_command_result|nil, error: string|nil)
function M.ghostty_command(args, callback) end

---Reads GhosttyDalamud's state over IPC. method is one of: window.list (every terminal panel with id, title, app, size, state, kind, anchor, hidden, focused, plus the last request results), agent.status, agent.windows, agent.apps, focus.get (what has the keyboard) or status (one-line text). Read-only: these verbs answer from a snapshot at most one frame old and change nothing, so no approval is needed. Fails when GhosttyDalamud is not loaded — check list_bridges. Use ghostty_command to open or focus a panel.
---@param args Xiv_ghostty_query_args
---@param callback? fun(result: Xiv_ghostty_query_result|nil, error: string|nil)
function M.ghostty_query(args, callback) end

---Starts an application on the player's computer through XivDesktop and shows its window as a panel in game. app is a desktop-file id from list_desktop_apps ("org.gnome.TextEditor", with or without ".desktop") or search text, in which case XivDesktop launches its BEST MATCH, so prefer an exact id. Only catalogued applications can be started, never an arbitrary command line. Success means the launch was handed over, not that a window appeared. Waits up to 2 seconds for a unique new live panel matching the resolved app; observed and panelId report the observation. Check list_desktop_windows when observed=false. Fails with XivDesktop's own reason (no match, GhosttyDalamud missing).
---@param args Xiv_launch_desktop_app_args
---@param callback? fun(result: Xiv_launch_desktop_app_result|nil, error: string|nil)
function M.launch_desktop_app(args, callback) end

---Ask the local Laya typed-decision model one or more typed questions about supplied state. Read-only: the result is advisory and never executes a game action.
---@param args Xiv_laya_query_args
---@param callback? fun(result: Xiv_laya_query_result|nil, error: string|nil)
function M.laya_query(args, callback) end

---Lists the game's loaded UI windows ("addons") with their internal names, which get_addon_text needs. Each entry: name (internal, e.g. Inventory, Character, _PartyList, Talk, SelectString), id, visible, ready, focused, x/y (screen pixels, top-left), width/height (scaled pixels), scale, depthLayer (higher draws on top), parentId (for child windows). By default only visible addons are returned, sorted by name. Names starting with '_' are HUD elements. Returns total matches and truncated when more exist than limit.
---@param args Xiv_list_addons_args
---@param callback? fun(result: Xiv_list_addons_result|nil, error: string|nil)
function M.list_addons(args, callback) end

---The player's teleport list (the in-game Teleport window): every attuned aetheryte plus housing destinations (own/FC house, shared estates, apartments). Each entry: aetheryteId, subIndex, name, territoryId, zone, region, gilCost (the current price, which already reflects favourites/free destination), isFavourite, isFreeDestination, isHomePoint, isInCurrentZone, housing flags with ward/plot, unlocked (always true: only attuned destinations appear). Filter with nameContains (matches aetheryte, zone or region name). Use to answer 'can I teleport to X' / 'what does it cost' before suggesting a teleport; aethernet shards inside cities are not teleport destinations and are not listed.
---@param args Xiv_list_aetherytes_args
---@param callback? fun(result: Xiv_list_aetherytes_result|nil, error: string|nil)
function M.list_aetherytes(args, callback) end

---Earlier benchmark runs, newest first: runId, mode, model, finishedAt, score, successRate, state. Use get_almanac_benchmark for one run's rows. NEEDS A NEWER Almanac: written against the proposed Almanac.v1.Call gate; fails with unavailable, naming the missing verb, until Almanac ships it.
---@param args Xiv_list_almanac_benchmarks_args
---@param callback? fun(result: Xiv_list_almanac_benchmarks_result|nil, error: string|nil)
function M.list_almanac_benchmarks(args, callback) end

---Almanac's conversations, newest first: id, title, turns, updatedAt and which is current. These are the player's private conversations with their assistant. NEEDS A NEWER Almanac: written against the proposed Almanac.v1.Call gate; fails with unavailable, naming the missing verb, until Almanac ships it.
---@param args Xiv_list_almanac_threads_args
---@param callback? fun(result: Xiv_list_almanac_threads_result|nil, error: string|nil)
function M.list_almanac_threads(args, callback) end

---Every other Dalamud plugin XivMcp can read through IPC, with installed, loaded, version, ipcAvailable, apiVersion and (when it cannot be used) unavailable explaining why — not installed, not loaded, or the plugin's IPC surface changed. verified=false means the gate names come from that plugin's published IPC documentation and have not been exercised against the real plugin by this project. Call this before any other bridge tool so you know what exists on this machine; read-only bridge data needs no approval, while anything that changes another plugin's state is an Action-tier tool.
---@param args table<string, any>
---@param callback? fun(result: Xiv_list_bridges_result|nil, error: string|nil)
function M.list_bridges(args, callback) end

---The applications XivDesktop can launch on the player's computer, filtered and paged here: id (the desktop-file id launch_desktop_app takes), name, generic name, categories, favourite, terminal (runs in a terminal), launchable and recent (0 = most recently launched). query matches id, name, generic name, keywords and categories, ignoring case. Returns total, matched and truncated. Read-only; nothing is launched. Fails with unavailable when XivDesktop is not loaded.
---@param args Xiv_list_desktop_apps_args
---@param callback? fun(result: Xiv_list_desktop_apps_result|nil, error: string|nil)
function M.list_desktop_apps(args, callback) end

---The desktop windows shown as panels in game, as XivDesktop tracks them: available (GhosttyDalamud's call gate is there), rev, workspace (current, 1-9), target (the window id actions without an id apply to) and windows[] with id, title, app, state (pending|live|ended), kind (pet|pin|full|tab), focused, workspace, hidden (on another workspace) and appId. ids are the same panel ids list_terminal_panels returns. Read-only.
---@param args table<string, any>
---@param callback? fun(result: Xiv_list_desktop_windows_result|nil, error: string|nil)
function M.list_desktop_windows(args, callback) end

---The event kinds currently in the buffer with how many of each, plus the current cursor and the buffer size. Use it to see what the stream is actually producing before filtering get_events by kind.
---@param args table<string, any>
---@param callback? fun(result: Xiv_list_event_kinds_result|nil, error: string|nil)
function M.list_event_kinds(args, callback) end

---FATEs currently known in the player's zone, nearest first. Each entry: id, name, objective, level and maxLevel (the level sync cap), state (Preparing|Running|Ending|Ended|Failed|...), progressPercent, timeRemainingSeconds, durationSeconds, startTimeUtc, hasBonus (EXP bonus), handInCount (for item turn-in FATEs), position, mapCoordinates, distance from the player, radius, playerInsideRadius, isOccupiedByPlayer (the player is currently participating, i.e. it is the client's current FATE) and isLevelSyncedByPlayer. Also returns currentFateId. Use for 'any FATEs nearby', 'which FATE should I do'.
---@param args Xiv_list_fates_args
---@param callback? fun(result: Xiv_list_fates_result|nil, error: string|nil)
function M.list_fates(args, callback) end

---Lists the character's saved gear sets. Each entry: id (the gear set number shown in the Gear Set list and used by /gearset change and equip_gearset, 1-100), name, classJobId, classJob (abbreviation, e.g. WHM) and classJobName, itemLevel (average item level saved with the set), glamourPlate (linked glamour plate number, omitted if none), mainHandMissing (the set's main-hand weapon is missing, so it cannot be fully equipped), isCurrent (the set currently equipped). Use before equip_gearset to pick the right set.
---@param args table<string, any>
---@param callback? fun(result: Xiv_list_gearsets_result|nil, error: string|nil)
function M.list_gearsets(args, callback) end

---What is on the player's hotbars for the current job, as the HUD shows them. bars: standard (hotbars 1-10, 12 slots), cross (cross hotbar sets 1-8, 16 slots), pet, petCross, or all; number picks one standard/cross bar. Each bar: kind, number, sharedAcrossJobs, slotCount, used, and slots {slot (1-based), kind (action, item, macro, gearset, emote, generalAction, craftAction, petAction, buddyAction, mainCommand, extraCommand, mount, companion, marker, fieldMarker, recipe, ...), id, name (resolved from game data; macro title or gear set name for those kinds), keybind (the hint drawn on the slot, e.g. '1' or 'c2'), iconId, shownAs* when the slot currently displays a different action than the one assigned, macroSet + macroIndex for macros (match list_macros)}. Empty slots are skipped unless includeEmpty=true. Strictly a listing: no tool presses a hotbar slot. Use for 'what is on my bars', 'where did I put Sprint', hotbar layout advice.
---@param args Xiv_list_hotbars_args
---@param callback? fun(result: Xiv_list_hotbars_result|nil, error: string|nil)
function M.list_hotbars(args, callback) end

---Lists the user's macros from the in-game User Macros window: set individual (this character) or shared (all characters on the account), 100 slots each. Each entry: index (0-99 slot number), name, iconId, lineCount and lines (the macro's text lines with trailing empty lines removed). By default empty slots are skipped. Read-only; use execute_command with the lines if the user wants to run one step manually.
---@param args Xiv_list_macros_args
---@param callback? fun(result: Xiv_list_macros_result|nil, error: string|nil)
function M.list_macros(args, callback) end

---Game objects loaded around the player (the client only knows objects within roughly 100 yalms, fewer in crowded areas), sorted nearest first; the local player is excluded. Filter by kind: all, player, battleNpc (any combat NPC incl. pets/chocobos), enemy (hostile battleNpc only), eventNpc (quest/vendor NPCs), treasure (coffers), aetheryte, gatheringPoint, eventObj (interactables), mount, companion (minions), retainer, areaObject, housing, cutscene, reactionEventObj, ornament, cardStand, followMount. Each row: kind, subKind, name, entityId, gameObjectId (string), baseId, objectIndex, distance, horizontalDistance, position, mapCoordinates, isTargetable, and for characters isDead, level, hpPercent, isHostile, inCombat, isCasting, ownerEntityId; players also get job and world. Returns total matches, offset, returned and truncated. Use get_target for full detail on one object.
---@param args Xiv_list_nearby_objects_args
---@param callback? fun(result: Xiv_list_nearby_objects_result|nil, error: string|nil)
function M.list_nearby_objects(args, callback) end

---Every custom objective in insertion order with steps, location, conditions and live status: ready (in the zone, within the radius, inside the Eorzea time window and weather), summary (the line the player sees, e.g. "Next window in 14 min"), windowOpen (time and weather match now, wherever the player is), inZone, nearSpot, distanceYalms, currentWeather, nextWindowStartUtc/EndUtc (from the game's weather algorithm; while open, End is when it closes) and problem (e.g. a weather the zone never has). Works at the title screen with location checks false.
---@param args Xiv_list_objectives_args
---@param callback? fun(result: Xiv_list_objectives_result|nil, error: string|nil)
function M.list_objectives(args, callback) end

---Lists the custom (third-party) plugin repositories configured in Dalamud's settings (Experimental tab): url and enabled for each, in the configured order; Dalamud's own main repository is not part of this list. URLs are scrubbed of embedded credentials and token/key query values (<redacted:kind>). The list is read from Dalamud's in-memory configuration (DalamudConfiguration.ThirdRepoList), which is not public plugin API: on a Dalamud build where it moved the tool fails with unavailable. Nothing is read from or written to Dalamud's config files. Use it to tell where a third-party plugin could have come from (compare list_plugins installedFromUrl); add_plugin_repository is the assisted way to add one.
---@param args Xiv_list_plugin_repositories_args
---@param callback? fun(result: Xiv_list_plugin_repositories_result|nil, error: string|nil)
function M.list_plugin_repositories(args, callback) end

---Lists the Dalamud plugins installed in this game client. Each entry: internalName, name, version, author, loaded (currently running), isDev (local dev plugin), isThirdParty (from a custom repository), isTesting, isOutdated, isBanned/isOrphaned/isDecommissioned (only when true), hasMainUi/hasConfigUi, apiLevel, installedFromUrl (the repository the plugin was installed from: a custom repository URL, scrubbed of credentials, or Dalamud's markers OFFICIAL / DEVPLUGIN), projectUrl (the manifest's source link), state (Dalamud's load state: Loaded, Unloaded, LoadError, UnloadError, Loading, Unloading, DependencyResolutionFailed) and updateAvailable. state and updateAvailable come from Dalamud's plugin manager, which is not public API: they are omitted when this Dalamud build does not expose them, and updateAvailable only reflects the repository data Dalamud last fetched (what its installer shows), not a fresh check. Use to check whether a plugin the user mentions is installed and enabled before suggesting its commands. Sorted by name; truncated=true when more match than limit.
---@param args Xiv_list_plugins_args
---@param callback? fun(result: Xiv_list_plugins_result|nil, error: string|nil)
function M.list_plugins(args, callback) end

---Every Duty Roulette in the game data (ContentRoulette): id, name, category, dutyType, description, requiredLevel, itemLevelRequired, itemLevelSync, partySize, rewardTomeA/B/C (the sheet's three tomestone reward amounts for the daily bonus; the sheet does not say which tomestone each is), roleBonus (the adventurer-in-need item and amount), inDutyFinder, pvp, and dutyCount = how many duties are flagged for it (only for roulettes that have a membership flag on duties). Static: it says nothing about today's bonus or what the character has unlocked; use get_roulette_status for that while the game is running, and get_duty_unlock for one duty's roulettes. Returns {total, offset, returned, truncated, results}.
---@param args Xiv_list_roulettes_args
---@param callback? fun(result: Xiv_list_roulettes_result|nil, error: string|nil)
function M.list_roulettes(args, callback) end

---Lists game Excel sheets that have typed column definitions (Lumina.Excel.Sheets), optionally filtered by nameContains, with row count, whether rows have subrows, and column names with types (string, uint8..int64, float, bool, RowRef<Sheet> links, arrays). Use it to discover sheet and column names for get_sheet_row and search_sheet when no dedicated tool exists. includeUntyped also lists raw sheet names without column names (their columns read as col0, col1, ...). Paged; columns are included only when includeColumns is true.
---@param args Xiv_list_sheets_args
---@param callback? fun(result: Xiv_list_sheets_result|nil, error: string|nil)
function M.list_sheets(args, callback) end

---Names of the groups the logged-in character belongs to, and nothing else: freeCompany {loaded, member, name, tag, rank (the company's rank 1-30), grandCompany}, linkshells and crossWorldLinkshells {loaded, count, groups [{slot 1-8, name}]}. No member lists and no data about other players. loaded=false means the client has not loaded that information yet (free company details load when the Free Company window is opened; the tag is still reported from the nameplate); it is not an error. notExposed lists what cannot be read (PvP team, fellowships, the character's own rank title). Use for 'which linkshell number is X' before suggesting a /linkshellN message, or 'what FC am I in'. Use get_party for the current party.
---@param args table<string, any>
---@param callback? fun(result: Xiv_list_social_groups_result|nil, error: string|nil)
function M.list_social_groups(args, callback) end

---Returns every entry on the in-game agent board (newest update first) with agent, status, state (running|done|failed|info), progress, detail, the MCP client that posted it and seconds since its last update (ageSeconds). Use it to see what other agents are doing or to resume your own entry. Entries expire after the player's configured idle time.
---@param args table<string, any>
---@param callback? fun(result: Xiv_list_status_result|nil, error: string|nil)
function M.list_status(args, callback) end

---Every GhosttyDalamud panel, oldest first: terminals (in the dropdown, floating, minimized or in the world), remote desktop windows, adopted plugin windows and the chat. Each has id (what every terminal panel tool takes), kind (terminal|window|adopted|chat), title, app, profile and running (terminals), view (tab|dropdown|min|pet|pin|hud|full|hidden), anchor/state/width/height (remote windows only), focused (has the keyboard), hidden and order (a pet's place from 1). Merged from panel.list and window.list, at most one frame old. Use get_terminal_layout for how to reproduce the arrangement, ghostty_query for the raw JSON. Fails with unavailable when GhosttyDalamud is not loaded.
---@param args Xiv_list_terminal_panels_args
---@param callback? fun(result: Xiv_list_terminal_panels_result|nil, error: string|nil)
function M.list_terminal_panels(args, callback) end

---The theme names set_terminal_theme accepts and the current one. NEEDS A NEWER GhosttyDalamud: today themes are listed only into the game's chat log by "/term theme", which IPC cannot read, so this fails with unavailable (naming the proposed theme.list verb) until GhosttyDalamud ships it.
---@param args table<string, any>
---@param callback? fun(result: Xiv_list_terminal_themes_result|nil, error: string|nil)
function M.list_terminal_themes(args, callback) end

---Lists your approval tickets, oldest first. state filters: open (pending or approved, the default), pending, final, all. Pass resumeToken to find the tickets you filed with it. sessionActiveUntil is set while the player has an approval session open for you (Action calls, and Chat calls if they allowed it, then run without asking).
---@param args Xiv_list_tickets_args
---@param callback? fun(result: Xiv_list_tickets_result|nil, error: string|nil)
function M.list_tickets(args, callback) end

---Every public world in the game with its data centre and region, from game data (no network call). Flags the character's current and home world when logged in. Use it to pick a valid scope for get_market_prices, or to check which data centre a world belongs to. Filter with nameContains (matches world, data centre or region) and page with limit/offset.
---@param args Xiv_list_worlds_args
---@param callback? fun(result: Xiv_list_worlds_result|nil, error: string|nil)
function M.list_worlds(args, callback) end

---Loads many objectives at once from a quest pack: pass the JSON text (json) or a file path on the player's machine (path; host paths such as /home/me/pack.json or ~/pack.json are mapped to Wine's Z: drive). Shape: {"quests": [{id, name, zone, territoryId, spot, map: {x, y}, eorzea_time, weather: [...], setup: [...], capture}]} (setup and capture become steps; or give steps directly), {"objectives": [...]} or a bare array. Entries with the same id replace existing ones, keeping progress when the steps are unchanged. Invalid entries are skipped and reported in errors.
---@param args Xiv_load_objective_pack_args
---@param callback? fun(result: Xiv_load_objective_pack_result|nil, error: string|nil)
function M.load_objective_pack(args, callback) end

---Opens one of Dalamud's own windows in front of the player: window='installer' (the plugin installer; tab is allPlugins, installedPlugins, updateablePlugins, changelogs or dalamudChangelogs) or window='settings' (Dalamud settings; tab is general, lookAndFeel, autoUpdates, serverInfoBar, badge, experimental or about), optionally with searchText typed into that window's search box. For automatic installation and updates use setup_plugins; this tool only opens the selected window. Returns opened (what Dalamud reported), window, tab and searchText. Fails with invalid_arguments for an unknown window or tab.
---@param args Xiv_open_dalamud_window_args
---@param callback? fun(result: Xiv_open_dalamud_window_result|nil, error: string|nil)
function M.open_dalamud_window(args, callback) end

---Opens one of the game's own windows so the player can look at it; it never clicks, selects, registers, crafts or buys anything inside the window. kind: map (id = Map row id, or territoryId = zone whose main map to show; neither = current map), journal (id = Quest row id to show that quest), recipe (Crafting Log; id = Recipe row id), recipeSearch (Crafting Log searched for an item; id = Item row id, required), gatheringLog (id = Item row id of a gatherable), teleport, character, armoury, inventory, dutyFinder (id = ContentFinderCondition row id to show that duty; it is not joined), achievements (id = Achievement row id), currency, gearsets, macros. Ids are checked against the game data first (not_found). Refused while in combat, casting, crafting, gathering, in a cutscene or event, or changing zones. If the window is already open it is brought to the front (alreadyOpen=true) instead of being toggled shut. The game decides what the window shows: a recipe or duty the character has not unlocked may open the window without the entry. Returns kind, id and the client function used. For a flag on the map use set_map_flag; for item data use the read tools (there is no standalone item window to open).
---@param args Xiv_open_game_window_args
---@param callback? fun(result: Xiv_open_game_window_result|nil, error: string|nil)
function M.open_game_window(args, callback) end

---Opens the main window or the settings window of an installed, loaded Dalamud plugin, exactly like the buttons in the plugin installer (IExposedPlugin.OpenMainUi / OpenConfigUi). plugin is the internal name from list_plugins (a display name works when it is unambiguous); which is 'main' or 'config'. Returns the plugin's internalName and which window was asked for; whether a window actually appeared is up to that plugin. Fails with not_found for an unknown plugin, unavailable when the plugin is not loaded or has no such window (list_plugins hasMainUi/hasConfigUi). It only opens a window; it clicks nothing inside it.
---@param args Xiv_open_plugin_ui_args
---@param callback? fun(result: Xiv_open_plugin_ui_result|nil, error: string|nil)
function M.open_plugin_ui(args, callback) end

---Opens a new GhosttyDalamud panel in the game world. Without run: a terminal (terminal.new) with the given profile (a name from the player's GhosttyDalamud profiles, or its place from 1; default profile when omitted). With run: the desktop agent STARTS THAT COMMAND on the player's computer and streams its window (window.open); a text program needs a terminal emulator in the command, e.g. "foot htop". run and profile exclude each other. pin places it as /term pin does: "pet" (default, floats beside the character), "here", "me 2 1.7", "target", "orbit 3.5", "hud 0.85 0.2". Returns request, completed and panelId (the new panel's id) when the outcome arrived. Common failures: "no player (log in first)", "the agent is not connected", "no such profile". run is shown to the player verbatim for approval; there is deliberately no tool that types text into an open shell. GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_open_terminal_args
---@param callback? fun(result: Xiv_open_terminal_result|nil, error: string|nil)
function M.open_terminal(args, callback) end

---Moves a pet panel within the lineup beside the character (panel.order): to is "left" or "right" (swap with that neighbour), "first", "last" or a place from 1. Only shown pets have a place; anything else fails with "only pets have a place in the order". GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_order_terminal_panel_args
---@param callback? fun(result: Xiv_order_terminal_panel_result|nil, error: string|nil)
function M.order_terminal_panel(args, callback) end

---Moves a panel (panel.place): pin is "pet", "here" (fixed where the character stands), "me 2 1.7", "target", "orbit 3.5", "hud [X Y [DIST]]" (docked to the screen, X/Y as 0..1 fractions from the top left), "hide" or "hide off". A terminal in the dropdown or minimized moves into the world; windows keep their size. id comes from list_terminal_panels. GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_place_terminal_panel_args
---@param callback? fun(result: Xiv_place_terminal_panel_result|nil, error: string|nil)
function M.place_terminal_panel(args, callback) end

---Creates or replaces (same id) a custom objective that the player sees in game like a tracked quest: title and current step under the Duty List, live 'ready now' / 'next window in N min' state, click to place the map flag. It is NOT a real Journal quest (those are server-side). Give a location with territoryId (TerritoryType row id, e.g. 137 Eastern La Noscea) plus map x/y as the game displays them; optional conditions: eorzeaTime (daily Eorzea window "HH:MM-HH:MM", may wrap midnight, e.g. "21:00-03:00"), weather (names such as "Clear Skies"; any listed one matches), radius (yalms from the spot, default 30). Re-posting with identical steps keeps the player's progress; changed steps reset it. Advance it with update_objective. Returns the stored objective with its live status.
---@param args Xiv_post_objective_args
---@param callback? fun(result: Xiv_post_objective_result|nil, error: string|nil)
function M.post_objective(args, callback) end

---Shows your progress inside the player's game: creates or replaces the board entry for `agent` (one entry per agent name, case-insensitive) in the XivMcp window and Umbra toolbar widget. Call it when you start a multi-step task (state running), update it as you go (optionally with progress 0..1), and finish with state done or failed so the player sees the outcome. Use info for a one-off note. Keep status to a short line; put longer context in detail. Returns the stored entry.
---@param args Xiv_post_status_args
---@param callback? fun(result: Xiv_post_status_result|nil, error: string|nil)
function M.post_status(args, callback) end

---Prints a line into the user's OWN chat log only (tagged [MCP]); nobody else can see it and nothing is sent to the server. Use it to leave the user a visible note, summary or reminder inside the game. Line breaks are turned into spaces; at most 1000 characters. Returns the printed text.
---@param args Xiv_print_echo_args
---@param callback? fun(result: Xiv_print_echo_result|nil, error: string|nil)
function M.print_echo(args, callback) end

---Returns chat lines the plugin has captured since it loaded (not older history), oldest first. Each entry: sequence (monotonic, use for paging/polling), timestamp, chatType (Dalamud XivChatType name such as Say, Shout, Party, FreeCompany, Ls1, CrossLinkShell1, TellIncoming, Echo, SystemMessage, NPCDialogue), chatTypeId, sender (plain text, omitted when none), message (plain text; item links/icons flattened), isHandled (a plugin suppressed it from the visible log). Without afterSequence you get the newest `limit` matching lines; to poll for new lines pass the previous response's nextAfterSequence. Filters: channels (XivChatType names, numeric ids, or groups: tell, party, alliance, fc, linkshell, ls1-ls8, cwls, cwls1-cwls8, novice, emote, echo, system, npc, pvpteam), contains (message substring), senderContains — all case-insensitive. Battle-log lines (damage, healing, buffs) are not captured. PRIVACY: private tells are hidden unless includeTells=true or channels names a tell type; hiddenTells reports how many matching tells were withheld. Only request tells when the user asked about their private messages.
---@param args Xiv_read_chat_args
---@param callback? fun(result: Xiv_read_chat_result|nil, error: string|nil)
function M.read_chat(args, callback) end

---Returns the newest matching entries of dalamud.log (Dalamud's and every plugin's log), oldest first so the newest is last. Each entry: time (ISO 8601 with offset), level (verbose|debug|information|warning|error|fatal), plugin (the [Tag] the line starts with: a plugin's internal name, or a Dalamud module such as PLUGINM; omitted for untagged Dalamud lines), message, and details (exception/stack-trace lines that followed, capped). Only the last tailMiB of the file is scanned (never the whole file), so matched counts that window; windowStartsMidFile=true means older entries exist beyond it. truncated=true when more entries matched than limit (the oldest matches are dropped). Every returned string is scrubbed: bearer/Authorization values, token=/key=/password= values, long hex/base64 secrets, e-mail addresses, IPv4/IPv6 addresses (a bare four-part number counts as one unless written as a version) become <redacted:kind>, and home directories become ~ with the OS user name removed. Character names are NOT scrubbed: this is the player's own log and the client already shows them. Use it to see why a plugin failed to load or what it logged around an error; use get_troubleshooting_summary first for the overview. Fails with unavailable when the log file cannot be found or read.
---@param args Xiv_read_plugin_log_args
---@param callback? fun(result: Xiv_read_plugin_log_result|nil, error: string|nil)
function M.read_plugin_log(args, callback) end

---Unloads and loads again one installed, currently loaded Dalamud plugin (Dalamud's LocalPlugin.ReloadAsync, what a dev plugin's automatic reload uses): the same files are loaded again, nothing is downloaded or updated, and the plugin's enabled state is unchanged. Use it when a plugin is stuck; the plugin loses whatever it kept only in memory. Returns internalName, state and loaded afterwards. Internal to Dalamud, not public API: fails with unavailable when this build does not expose it, in safe mode, while Dalamud is busy, when the plugin is not loaded (set_plugin_enabled loads it), or when the plugin throws while loading. Refused for this MCP server's own plugin (the connection would drop mid-call; the player can toggle it in /xlplugins).
---@param args Xiv_reload_plugin_args
---@param callback? fun(result: Xiv_reload_plugin_result|nil, error: string|nil)
function M.reload_plugin(args, callback) end

---Files an Action- or Chat-tier tool call (e.g. teleport, execute_command, send_chat) as an approval ticket and returns immediately with its id and state pending; nothing runs until the player approves it in the XivMcp window, which may be minutes or hours later (tickets survive game restarts and never time out into a denial unless you set expiresInSeconds). On approval the plugin runs the call with the normal validation and call timeout and stores the tool result on the ticket. If the player has an approval session open for you, the ticket is approved at once (state approved, then executed). Poll get_ticket / list_tickets, or subscribe to the ticket's uri (resources/subscribe) for notifications/resources/updated, then match resumeToken and continue the steps that depended on it. Use tools/call directly when the player is at the keyboard. At most 50 pending tickets per client. Arguments are shown to the player as sent.
---@param args Xiv_request_action_args
---@param callback? fun(result: Xiv_request_action_result|nil, error: string|nil)
function M.request_action(args, callback) end

---Starts XivDesktop's background scan of installed applications so a newly installed one appears in list_desktop_apps; get_desktop_status shows scanning and scannedAt. NEEDS A NEWER XivDesktop: written against the proposed XivDesktop.v1.Rescan gate; fails with unavailable, naming it, until it ships.
---@param args table<string, any>
---@param callback? fun(result: Xiv_rescan_desktop_apps_result|nil, error: string|nil)
function M.rescan_desktop_apps(args, callback) end

---Starts Almanac's model benchmark: mode mock (no model is called; checks the harness) or live (the model answers every task, which takes minutes and, with a paid remote model, costs money). model overrides the configured one; tasks limits the run to some task ids. Returns runId and total; follow it with get_almanac_benchmark. Results are stored locally only: nothing here, and no proposed verb, submits to a leaderboard. NEEDS A NEWER Almanac: written against the proposed Almanac.v1.Call gate; fails with unavailable, naming the missing verb, until Almanac ships it.
---@param args Xiv_run_almanac_benchmark_args
---@param callback? fun(result: Xiv_run_almanac_benchmark_result|nil, error: string|nil)
function M.run_almanac_benchmark(args, callback) end

---Starts GhosttyDalamud's own in-game checks ("/term selftest SUITES"): suites is "all", "list" or suite names separated by spaces. It opens and closes test panels and writes a JSON report into GhosttyDalamud's config folder (selftest/*.json), which its CI reads from disk. Posted as the chat command today, so nothing comes back here (via=post); get_terminal_selftest_report returns the report once GhosttyDalamud offers selftest.report. "leakwatch" is refused: it toggles a setting, it is not a suite.
---@param args Xiv_run_terminal_selftest_args
---@param callback? fun(result: Xiv_run_terminal_selftest_result|nil, error: string|nil)
function M.run_terminal_selftest(args, callback) end

---Searches actions players can learn (weaponskills, spells, abilities, role actions, gathering abilities, PvP actions; from the Action sheet — crafting actions such as Basic Synthesis live in the CraftAction sheet, see get_sheet_row) by name, ranked exact > prefix > word > substring; a numeric query matches the action id. classJob (abbreviation like DRG, SGE, WHM or a name) keeps actions that class/job can use, including role actions and its base class's actions. PvP actions are excluded unless includePvp is true. Returns {total, offset, returned, truncated, results:[{id, name, classJob, level, category, isRoleAction, isPvp}]} sorted by relevance (or by level when no query is given). Use get_action for description, cast/recast, range and cost.
---@param args Xiv_search_actions_args
---@param callback? fun(result: Xiv_search_actions_result|nil, error: string|nil)
function M.search_actions(args, callback) end

---XivDesktop's command-palette ranking for a query (at most 10): applications, open windows, actions, calculator results and commands, each with provider, title, subtitle, score, enabled/reason and the command running it would perform. Read-only: nothing is run. Use it to resolve "open my browser" to an app id before launch_desktop_app.
---@param args Xiv_search_desktop_palette_args
---@param callback? fun(result: Xiv_search_desktop_palette_result|nil, error: string|nil)
function M.search_desktop_palette(args, callback) end

---Searches duties from the Duty Finder data (ContentFinderCondition: dungeons, guildhests, trials, raids, alliance raids, PvP, deep dungeons, variant/criterion, etc.) by name (ranked exact > prefix > word > substring; numeric query matches the id). Filter by contentType (name such as "Dungeons", "Trials", "Raids", "Ultimate Raids" or its id) and required level range. Query may be omitted when a filter is set. Returns {total, offset, returned, truncated, results:[{id, name, type, level, itemLevelRequired, levelSync, itemLevelSync, partySize, highEnd, pvp}]}. Use get_duty for unlock quest, roulettes and composition.
---@param args Xiv_search_duties_args
---@param callback? fun(result: Xiv_search_duties_result|nil, error: string|nil)
function M.search_duties(args, callback) end

---Searches every item in the game data (not the player's inventory; use find_owned_items for that) by name in the client language, ranked exact match > prefix > word prefix > substring > all words present; a numeric query also matches the item id. Optional filters narrow results: itemUiCategory (category name like "Two-handed Axe", "Ingredient", "Materia", or its id), equipSlot (mainHand, offHand, head, body, hands, waist, legs, feet, ears, neck, wrists, ring, soulCrystal), classJob (abbreviation like WAR/BLM/CRP, matching items that job can equip), item level range, and isMarketable/isCraftable/isGatherable/isUntradable. Query may be omitted when filters are given (results are then ordered by item level, highest first). Returns {total, offset, returned, truncated, results:[{id, name, category, itemLevel, equipLevel, equipSlot, jobs, rarity, isMarketable, isCraftable, isGatherable, isUntradable, icon}]}. Use get_item with an id for full details.
---@param args Xiv_search_items_args
---@param callback? fun(result: Xiv_search_items_result|nil, error: string|nil)
function M.search_items(args, callback) end

---Searches quests by name (ranked exact > prefix > word > substring; a numeric query matches the quest id). Returns {total, offset, returned, truncated, results:[{id, name, level, genre, expansion}]}; genre is the journal genre (e.g. "Seventh Astral Era", "Weaver Quests"). Quest ids are Quest sheet row ids (65536+). Use get_quest for issuer, location, prerequisites and rewards, and get_quest_status to check whether the player completed them.
---@param args Xiv_search_quests_args
---@param callback? fun(result: Xiv_search_quests_result|nil, error: string|nil)
function M.search_quests(args, callback) end

---Searches crafting recipes by the crafted item's name (ranked exact > prefix > word > substring; numeric query matches the recipe id), optionally filtered by craftType (crafter name like "Weaving"/"Weaver", abbreviation like WVR, or craft type id 0-7) and recipe level range. Query may be omitted when a filter is set (results are then ordered by level, highest first). Returns {total, offset, returned, truncated, results:[{recipeId, itemId, itemName, craftType, level, stars, yield, isExpert, requiresSpecialist, masterBook}]}. Use get_recipe with recipeId for ingredients.
---@param args Xiv_search_recipes_args
---@param callback? fun(result: Xiv_search_recipes_result|nil, error: string|nil)
function M.search_recipes(args, callback) end

---Scans one column of any Excel sheet and returns matching rows as {rowId, subrowId, label, value}, where label is the row's Name/Singular when it has one. Text columns match case-insensitively by substring (match="exact" for whole value); numeric and bool columns match the number/true/false exactly, or a range "min..max"; RowRef columns match the linked row id. Column names come from list_sheets (untyped sheets use col0, col1, ...). Paged with total and truncated. Use get_sheet_row to read a full match.
---@param args Xiv_search_sheet_args
---@param callback? fun(result: Xiv_search_sheet_result|nil, error: string|nil)
function M.search_sheet(args, callback) end

---Searches zones (TerritoryType rows that have a place name) by name, ranked exact > prefix > word > substring; a numeric query matches the territory id. Filter by kind: city, field, inn, housing, duty, pvp or other (coarse, from TerritoryIntendedUse and the zone's Duty Finder entry) and by region name. Query may be omitted when a filter is set. Returns {total, offset, returned, truncated, results:[{territoryId, name, region, kind, intendedUse, expansion, duty, hasWeather}]}. The same name can appear several times: instanced and quest copies of a zone are separate territories; the town or field copy is normally the lowest id with kind city/field. Use get_zone_info for maps, aetherytes, weather and markers, and search_duties for duties by name.
---@param args Xiv_search_zones_args
---@param callback? fun(result: Xiv_search_zones_result|nil, error: string|nil)
function M.search_zones(args, callback) end

---Open the illustrated Journal on an accepted quest, clearing its UI search/filter to reveal the selection. Does not track the quest, change an objective or start Wayfinder. The Journal checks the quest is still accepted when applying the request. Use get_quest_journal for IDs; poll get_hud_request.
---@param args Xiv_select_hud_quest_args
---@param callback? fun(result: Xiv_select_hud_quest_result|nil, error: string|nil)
function M.select_hud_quest(args, callback) end

---Sends one line of text that OTHER PLAYERS WILL SEE, on the chosen channel, exactly as if the user typed it into the chat box. Only use when the user explicitly asked you to say something, and send exactly the words they approved. channel: say (nearby), yell (wider area), shout (whole zone), party, alliance, freeCompany, linkshell1-8, crossLinkshell1-8, novice (Novice Network), pvpTeam, or tell (private message; requires tellTarget "Firstname Lastname@World", or without @World for the user's own world). The message must be a single line, must not start with '/', and the full line including the channel command must fit in 500 UTF-8 bytes; control characters are removed. Rate limited to 1 message per 2 seconds and 10 per minute. Returns the exact line submitted. The game does not confirm delivery: if the channel is unavailable (not in a party/FC, linkshell slot empty, recipient offline) an error line appears in chat — check with read_chat channels ["system"].
---@param args Xiv_send_chat_args
---@param callback? fun(result: Xiv_send_chat_result|nil, error: string|nil)
function M.send_chat(args, callback) end

---Sets the user's focus target (the secondary tracked target shown in the Focus Target bar), or clears it with clear=true. Select the object with exactly one of entityId, gameObjectId (string) or name (nearest targetable match), same rules as set_target. Returns the focused object (or cleared=true).
---@param args Xiv_set_focus_target_args
---@param callback? fun(result: Xiv_set_focus_target_result|nil, error: string|nil)
function M.set_focus_target(args, callback) end

---Open the illustrated Character record on Equipment, Attributes, ClassesAndJobs or GearSets. This selects a UI page only; it never equips gear. Read get_character_sheet for game data. Poll get_hud_request then inspect module status.
---@param args Xiv_set_hud_character_page_args
---@param callback? fun(result: Xiv_set_hud_character_page_result|nil, error: string|nil)
function M.set_hud_character_page(args, callback) end

---Explicitly enable XivHud's reversible native HUD suppression or restore the game HUD. Preserves the saved native layout. Does not open Journal/Character or acquire controller input. Returns a queued requestId; poll get_hud_request and read get_hud_family_status to confirm applied visibility. Off is the recovery operation.
---@param args Xiv_set_hud_enabled_args
---@param callback? fun(result: Xiv_set_hud_enabled_result|nil, error: string|nil)
function M.set_hud_enabled(args, callback) end

---Places the user's map flag marker (the one shown on the map/minimap and inserted by <flag> in chat) and by default opens the map window on it. Local only; nothing is sent to other players. Give EITHER map coordinates x/y exactly as the game displays them (e.g. x=11.2, y=9.7 — the numbers in quest guides and hunt trains) OR world coordinates worldX/worldZ (from position data of other tools; world Y/height is not needed). territoryId defaults to the current zone and mapId to the current map (or the territory's main map); pass mapId alone for another zone's map. Returns territoryId, mapId, placeName, the map coordinates and the world coordinates actually used.
---@param args Xiv_set_map_flag_args
---@param callback? fun(result: Xiv_set_map_flag_result|nil, error: string|nil)
function M.set_map_flag(args, callback) end

---Enables (loads) or disables (unloads) an INSTALLED Dalamud plugin and records the choice the way the plugin installer's toggle does, so it persists across restarts: disabling unloads the plugin and then marks it not wanted in Dalamud's default plugin collection; enabling marks it wanted and then loads it. plugin is the internal name from list_plugins. Returns internalName, enabled (what was asked), changed (false when it already was in that state), state and loaded afterwards. There is no public Dalamud API for this: it calls the same internal methods the installer calls, and fails with unavailable when this Dalamud build does not expose them, when Dalamud itself would grey the toggle out (safe mode, a banned/outdated/orphaned plugin, a load in progress, a plugin managed by a non-default collection), or when the plugin throws while loading (the message says why; read_plugin_log has the rest). Refused: disabling this MCP server's own plugin (the connection would drop mid-call; the player can do it in /xlplugins). It never installs or updates anything: an outdated plugin stays outdated, and a plugin that is not installed is not_found; setup_plugins handles installation and updates. Disabling is the destructive direction: whatever the plugin was doing stops.
---@param args Xiv_set_plugin_enabled_args
---@param callback? fun(result: Xiv_set_plugin_enabled_result|nil, error: string|nil)
function M.set_plugin_enabled(args, callback) end

---Sets the user's current target, like clicking an object. Choose the object with exactly one of: entityId (number from object/party tools), gameObjectId (64-bit id as a decimal or 0x-hex string), or name (case-insensitive; exact name match preferred, otherwise substring; the nearest targetable match wins). Only targetable objects in the local object table (roughly within 100 yalms) can be targeted. Returns the chosen object's entityId, gameObjectId, name, objectKind, distance (yalms from the player), matchedBy and, for name searches, how many objects matched. This only selects a target; it never attacks or interacts.
---@param args Xiv_set_target_args
---@param callback? fun(result: Xiv_set_target_result|nil, error: string|nil)
function M.set_target(args, callback) end

---Hides or shows a world panel (window.hide): hidden panels are neither drawn nor streamed, lose the keyboard and sleep; hidden=false shows it again where its anchor puts it. Nothing is closed. Only world panels (pet, pin, hud): a terminal in the dropdown is refused by GhosttyDalamud. GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_set_terminal_panel_hidden_args
---@param callback? fun(result: Xiv_set_terminal_panel_hidden_result|nil, error: string|nil)
function M.set_terminal_panel_hidden(args, callback) end

---Switches the colours of the terminals and the glass around them to a named theme and saves it, as "/term theme NAME" does (names may contain spaces, e.g. "Gruvbox Light"). Posted as that chat command today: a misspelt name fails silently in the game's chat log and the result says via=post. With a GhosttyDalamud that offers theme.set the outcome is reported; list_terminal_themes lists the names once theme.list exists.
---@param args Xiv_set_terminal_theme_args
---@param callback? fun(result: Xiv_set_terminal_theme_result|nil, error: string|nil)
function M.set_terminal_theme(args, callback) end

---Automatically register/enable the selected HTTPS repository, enable testing when requested packages require it, install or update exact named plugins and their declared same-repository dependencies, enable them in the default collection and verify loaded versions. No installer/settings UI, clipboard or manual clicks. This downloads code that runs inside the game and may unload an older plugin during update. Existing plugin settings are preserved. Preflights the complete set before changes, then delegates to Dalamud's installer and eligibility checks. Returns an operation id immediately: queued is not success. Poll get_plugin_setup_status for verified complete or failed with partial results. One setup runs at a time; identical in-flight requests reuse the operation. History is bounded to 32 operations until reload. Missing unpublished packages, dev/duplicate installations, source/collection conflicts, incompatible or banned plugins and self replacement are explicit failures. A native operation already started may finish during MCP shutdown; inspect installed state before retrying.
---@param args Xiv_setup_plugins_args
---@param callback? fun(result: Xiv_setup_plugins_result|nil, error: string|nil)
function M.setup_plugins(args, callback) end

---Uploads one screenshot or clip from GhosttyDalamud's capture folder to its online gallery and returns the link (result.url). path is a file path from get_terminal_capture_status, or "last" for the most recent capture. This sends an image of the player's screen to a server, so the player is shown exactly what is uploaded. NEEDS A NEWER GhosttyDalamud: written against the proposed gallery.share verb; fails with unavailable until it ships ("/term share" is deliberately not posted blind, since nothing could report what was uploaded). GhosttyDalamud queues the change and runs it at the end of its next frame; this waits at most 2 seconds for the outcome (completed=true) and otherwise returns the request id for get_terminal_request. A change GhosttyDalamud ran and refused fails with its own reason.
---@param args Xiv_share_terminal_capture_args
---@param callback? fun(result: Xiv_share_terminal_capture_result|nil, error: string|nil)
function M.share_terminal_capture(args, callback) end

---Ask the Journal's existing native map handoff to show an accepted quest, closing the illustrated Journal. No route or movement is started. Poll get_hud_request; applied means the handoff was invoked, not that a map marker was verified.
---@param args Xiv_show_hud_quest_on_map_args
---@param callback? fun(result: Xiv_show_hud_quest_on_map_result|nil, error: string|nil)
function M.show_hud_quest_on_map(args, callback) end

---Shows a Dalamud overlay notification card (bottom-right corner, with title, text and a coloured icon for the type) visible only to the user; works on the title screen too. Better than a toast for longer or lasting messages such as "Your retainer ventures are done" or a task summary. type: info, success, warning or error. durationSeconds 1-600 (default 8; hovering keeps it open). Content up to 2000 characters, line breaks allowed.
---@param args Xiv_show_notification_args
---@param callback? fun(result: Xiv_show_notification_result|nil, error: string|nil)
function M.show_notification(args, callback) end

---Shows a short, transient on-screen message using the game's own toast styles, visible only to the user: normal (small banner near the top of the screen), quest (large centred quest-style text with a chime), error (red text like "Target is not in range."). Use for brief alerts the user should notice without reading chat. Single line, at most 200 characters (longer text is cut). Nothing is sent to other players.
---@param args Xiv_show_toast_args
---@param callback? fun(result: Xiv_show_toast_result|nil, error: string|nil)
function M.show_toast(args, callback) end

---Switches XivDesktop's current workspace (1-9): window panels assigned to other workspaces are hidden, this one's are shown. Nothing is closed. The current workspace is in list_desktop_windows.
---@param args Xiv_switch_desktop_workspace_args
---@param callback? fun(result: Xiv_switch_desktop_workspace_result|nil, error: string|nil)
function M.switch_desktop_workspace(args, callback) end

---Captures what is on the player's screen right now and returns it as a PNG image the model can look at, plus a text summary. The capture is a copy of the game's own render surface taken inside the client; no file is written and nothing leaves the machine. maxDimension downscales the longer side (64-4096, default 1024) — keep it small unless fine UI text has to be readable. hideUi=true hides the game's HUD for the capture and restores it afterwards (adds about 0.3 s). includeOverlays=false captures the frame before Dalamud/plugin windows are drawn, so only the game is visible. addon captures just one game window's rectangle (internal addon name from list_addons, e.g. "ItemDetail", "Talk", "_PartyList"); the addon must be loaded and visible, and addonPadding adds pixels around it. The result carries width/height, sourceWidth/sourceHeight, bytes and captureMs (how long the capture took). Fails when the game has not drawn a frame yet (e.g. still loading) or when the named addon is not on screen. Use get_addon_text instead when you only need the text of a window — it is far cheaper than an image.
---@param args Xiv_take_screenshot_args
---@param callback? fun(result: any|nil, error: string|nil)
function M.take_screenshot(args, callback) end

---Targets one member of the user's own party, like clicking their row in the party list. Choose with exactly one of: name (case-insensitive; the full name, optionally "Firstname Lastname@World" to tell apart members with the same name, otherwise a unique part of the name) or slot (1-8, the row in the on-screen party list from the top; 1 is the user). One named member per call: there is no lowest-HP, next-member, role or other filter, and the call never uses an action. Alliance members outside the party are not included (use set_target). Fails with not_found when nobody matches or the slot is empty, invalid_arguments when the name matches several members (the message lists them), and unavailable when the member is in another zone or too far away to be targeted. Returns slot, name, world, entityId, distance (yalms) and the party as the tool saw it.
---@param args Xiv_target_party_member_args
---@param callback? fun(result: Xiv_target_party_member_result|nil, error: string|nil)
function M.target_party_member(args, callback) end

---Starts the Teleport spell to one of the character's attuned aetherytes (or free-company/private estate and apartment entries), exactly like choosing it in the Teleport window. Costs gil (reported as gilCost) and takes a ~5 second cast that can be interrupted. Select with aetheryteId (Aetheryte row id) or name (aetheryte or zone name, case-insensitive; exact match preferred, otherwise a unique substring, e.g. "Limsa Lominsa Lower Decks", "Tuliyollal", "Kugane"). Only attuned destinations work. Refused in combat, in a duty, while casting, flying or diving, in cutscenes/events, crafting, gathering, while dead, changing zones or in PvP. Returns the destination, its territory, gilCost and started=true when the cast began; the arrival itself happens after the cast and loading screen.
---@param args Xiv_teleport_args
---@param callback? fun(result: Xiv_teleport_result|nil, error: string|nil)
function M.teleport(args, callback) end

---Reports progress on an objective posted with post_objective or loaded from a pack: advance=true marks the current step done (after the last step the objective completes), step=N makes step N (0-based) current with every earlier step done, complete=true completes it (the player sees the game's quest-complete toast), complete=false reopens it, note sets a short line shown under the step (empty string clears it). Returns the objective with its live status.
---@param args Xiv_update_objective_args
---@param callback? fun(result: Xiv_update_objective_result|nil, error: string|nil)
function M.update_objective(args, callback) end

---Writes one slot of the User Macros window, replacing whatever is in it: set individual (this character) or shared (all characters), index 0-99 as in list_macros, title (at most 20 characters), optional iconId (an icon from the macro icon picker; omitted keeps the slot's icon, or the default icon for an empty slot) and 1-15 lines of at most 180 UTF-8 bytes each. The player runs the macro; this tool never does. Every line follows execute_command's rules: lines that log out, close the game or change Dalamud, action and movement commands (/ac /action /automove /follow ...) and xiv-mcp's own commands are refused (error code refused), and lines other players would see (/say /party ..., or plain text without a command) need the Chat permission tier. The whole lines array must fit the approval prompt (500 characters as JSON), so very long macros are rejected rather than approved unseen. Returns the slot as written and previous (title, iconId, lines, and restorable: whether write_macro would accept those lines again) so the old content can be put back. Hotbar slots that point at the macro are refreshed; the macro file is saved by the game as after an edit in the window.
---@param args Xiv_write_macro_args
---@param callback? fun(result: Xiv_write_macro_result|nil, error: string|nil)
function M.write_macro(args, callback) end
return M
