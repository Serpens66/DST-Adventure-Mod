name = "DS Coop Adventure"
description = "[BETA]\n\nPlay Adventure. Choose Adventure as game mode!" 
author = "Serpens"
forumthread = ""

version = "0.8.1"
api_version = 10

dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = -5


-- game mode, use Wilderness, since it is simular to what I want and mode check does not work in modworldgenmain... ?!
game_modes =
{
	{
		name = "adventure",
		label = "Adventure",
		description = "Play DS Adventure with your friends!",
        settings =
		{
            mod_game_mode = true,
            spawn_mode = "fixed",
            resource_renewal = true,
            ghost_sanity_drain = true,
            ghost_enabled = true,
            portal_rez = true, -- there is no portal except in world 0 and 7
            reset_time = { time = 120, loadingtime = 180 },
            invalid_recipes = { }, -- "lifeinjector", "resurrectionstatue", "reviver"
		}
	}
}

configuration_options = 
{
	{
		name = "difficulty",
		label = "Difficulty",
		hover = "Dont change this for a running game.",
		options = 
		{
			{description = "DS", data = 0, hover="Only necessary changes. It will be the same like the DS adventure for the most parts."},
            {description = "Easy", data = 1, hover="More starting items, an easy adventure."},
            {description = "Medium", data = 2, hover="Moderate starting items, a normal adventure."},
            {description = "Hard", data = 3, hover="Few starting items, a hard adventure."},
        },
		default = 2,
    },
    {
		name = "min_players",
		label = "Min Players",
		hover = "Min amount of players that have to be near teleportato to activate the worldjump.",
		options =	{
						{description = "More Half", data = "half", hover = "Default. More than half of all currently active players."},
                        {description = "All", data = "all", hover = "All currently active players."},
                        {description = "1", data = 1, hover = "\n"},
                        {description = "2", data = 2, hover = "\n"},
                        {description = "3", data = 3, hover = "\n"},
                        {description = "4", data = 4, hover = "\n"},
                        {description = "5", data = 5, hover = "\n"},
                        {description = "6", data = 6, hover = "\n"},
                        {description = "7", data = 7, hover = "\n"},
                        {description = "8", data = 8, hover = "\n"},
                        {description = "9", data = 9, hover = "\n"},
                        {description = "10", data = 10, hover = "\n"},
                        {description = "11", data = 11, hover = "\n"},
                        {description = "12", data = 12, hover = "\n"},
                        {description = "13", data = 13, hover = "\n"},
                        {description = "14", data = 14, hover = "\n"},
                        {description = "15", data = 15, hover = "\n"},
                        {description = "16", data = 16, hover = "\n"},
					},
		default = "half",
	},
    {
		name = "inventorysavenumber",
		label = "Transfer items?",
			hover = "How much of your inventory should be transfered\nRecipes and Age are always transfered",
		options =	{
						{description = "Everything", data = "all", hover = "All items and also everything equipped."},
                        {description = "0", data = 0, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "1", data = 1, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "2", data = 2, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "3", data = 3, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "4", data = 4, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "5", data = 5, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "6", data = 6, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "7", data = 7, hover = "Only the first x items are transfered\nno equipped stuff"},
                        {description = "8", data = 8, hover = "Only the first x items are transfered\nno equipped stuff"},
					},
		default = 4,
	},
    {
		name = "guards",
		label = "Guards",
		hover = "How many enemies should guard the teleportato parts?\nDont change this for a running game.",
		options = 
		{
			{description = "None", data = 0, hover="\n"},
            {description = "Few", data = 0.5, hover="\n"},
            {description = "Moderate", data = 1, hover="Default"},
            {description = "Many", data = 2, hover="\n"},
        },
		default = 0.5,
    },
    {
		name = "blueprintonly",
		label = "Blueprint Mode",
		hover = "No Researchlabs.\nInstead you have to find blueprints to get important recipes.\nDont change this for a running game.",
		options = 
		{
			{description = "Off", data = false, hover="\n"},
            {description = "On", data = true, hover="\n"},
        },
		default = false,
	},
    {
		name = "findblueprints",
		label = "FindBluePrints",
		hover = "Chance to find blueprints while working/slow-picking something\nOnly needed if BlueprintMode active.",
		options = 
		{
            {description = "None", data = 0, hover="\n"},
            {description = "Very Low", data = 0.003, hover="\n"},
            {description = "Low", data = 0.006, hover="\n"},
            {description = "Medium", data = 0.015, hover="Default"},
            {description = "High", data = 0.08, hover="\n"},
            {description = "Very High", data = 0.15, hover="\n"},
            {description = "Insane High", data = 0.9, hover="\n"},
        },
		default = 0.015,
    },
}
