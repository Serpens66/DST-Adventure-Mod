name = "A DS Coop Adventure"
description = "[BETA]\n\nPlay Adventure, Addon to the teleportato mod (base mod required!)" 
author = "Serpens"
forumthread = ""

version = "0.8.2"
api_version = 10

dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 9000 -- load before the teleportato mod



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
		name = "null_option",
		label = "WORLDS",
		hover = "Select which worlds should be acitve:",
		options =	{
						{description = "\n", data = 0, hover = "\n"},
					},
		default = 0,
	},
    {
		name = "maxwellsdoor",
		label = "Maxwells Door",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But you have to enable another\starting world, otherwise a random starting world is loaded"},
            {description = "1", data = "1", hover="Load this world as starting map"},
        },                   
		default = "1",
    },
    {
		name = "acoldreception",
		label = "A Cold Reception",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But if not enough worlds are active,\nrandom ones will load, even it they are disabled."},
            {description = "2", data = "2", hover="\n"},
            {description = "3", data = "3", hover="\n"},
            {description = "4", data = "4", hover="\n"},
            {description = "5", data = "5", hover="\n"},
            {description = "2,3,4,5", data = "2,3,4,5", hover="Randomly between 2 and 5"},
            {description = "2,3", data = "2,3", hover="\n"},
            {description = "2,4", data = "2,4", hover="\n"},
            {description = "2,5", data = "2,5", hover="\n"},
            {description = "3,4", data = "3,4", hover="\n"},
            {description = "3,5", data = "3,5", hover="\n"},
            {description = "4,5", data = "4,5", hover="\n"},
            {description = "2,3,4", data = "2,3,4", hover="\n"},
            {description = "3,4,5", data = "3,4,5", hover="\n"},
            {description = "2,4,5", data = "2,4,5", hover="\n"},
            {description = "2,3,5", data = "2,3,5", hover="\n"},
        },                   
		default = "2,3,4,5",
    },
    {
		name = "kingofwinter",
		label = "King of Winter",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But if not enough worlds are active,\nrandom ones will load, even it they are disabled."},
            {description = "2", data = "2", hover="\n"},
            {description = "3", data = "3", hover="\n"},
            {description = "4", data = "4", hover="\n"},
            {description = "5", data = "5", hover="\n"},
            {description = "2,3,4,5", data = "2,3,4,5", hover="Randomly between 2 and 5"},
            {description = "2,3", data = "2,3", hover="\n"},
            {description = "2,4", data = "2,4", hover="\n"},
            {description = "2,5", data = "2,5", hover="\n"},
            {description = "3,4", data = "3,4", hover="\n"},
            {description = "3,5", data = "3,5", hover="\n"},
            {description = "4,5", data = "4,5", hover="\n"},
            {description = "2,3,4", data = "2,3,4", hover="\n"},
            {description = "3,4,5", data = "3,4,5", hover="\n"},
            {description = "2,4,5", data = "2,4,5", hover="\n"},
            {description = "2,3,5", data = "2,3,5", hover="\n"},
        },                   
		default = "2,3,4,5",
    },
    {
		name = "thegameisafoot",
		label = "The Game is Afoot",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But if not enough worlds are active,\nrandom ones will load, even it they are disabled."},
            {description = "2", data = "2", hover="\n"},
            {description = "3", data = "3", hover="\n"},
            {description = "4", data = "4", hover="\n"},
            {description = "5", data = "5", hover="\n"},
            {description = "2,3,4,5", data = "2,3,4,5", hover="Randomly between 2 and 5"},
            {description = "2,3", data = "2,3", hover="\n"},
            {description = "2,4", data = "2,4", hover="\n"},
            {description = "2,5", data = "2,5", hover="\n"},
            {description = "3,4", data = "3,4", hover="\n"},
            {description = "3,5", data = "3,5", hover="\n"},
            {description = "4,5", data = "4,5", hover="\n"},
            {description = "2,3,4", data = "2,3,4", hover="\n"},
            {description = "3,4,5", data = "3,4,5", hover="\n"},
            {description = "2,4,5", data = "2,4,5", hover="\n"},
            {description = "2,3,5", data = "2,3,5", hover="\n"},
        },                   
		default = "2,3,4,5",
    },
    {
		name = "archipelago",
		label = "Archipelago",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But if not enough worlds are active,\nrandom ones will load, even it they are disabled."},
            {description = "2", data = "2", hover="\n"},
            {description = "3", data = "3", hover="\n"},
            {description = "4", data = "4", hover="\n"},
            {description = "5", data = "5", hover="\n"},
            {description = "2,3,4,5", data = "2,3,4,5", hover="Randomly between 2 and 5"},
            {description = "2,3", data = "2,3", hover="\n"},
            {description = "2,4", data = "2,4", hover="\n"},
            {description = "2,5", data = "2,5", hover="\n"},
            {description = "3,4", data = "3,4", hover="\n"},
            {description = "3,5", data = "3,5", hover="\n"},
            {description = "4,5", data = "4,5", hover="\n"},
            {description = "2,3,4", data = "2,3,4", hover="\n"},
            {description = "3,4,5", data = "3,4,5", hover="\n"},
            {description = "2,4,5", data = "2,4,5", hover="\n"},
            {description = "2,3,5", data = "2,3,5", hover="\n"},
        },                   
		default = "2,3,4,5",
    },
    {
		name = "twoworlds",
		label = "Two Worlds",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But if not enough worlds are active,\nrandom ones will load, even it they are disabled."},
            {description = "4", data = "4", hover="\n"},
            {description = "5", data = "5", hover="\n"},
            {description = "4,5", data = "4,5", hover="Randomly between 4 and 5"},
        },                   
		default = "4,5",
    },
    {
		name = "darkness",
		label = "Darkness",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But you have to enable another\6th world, otherwise a random 6th world is loaded"},
            {description = "6", data = "6", hover="Load this world as 6th map"},
        },                   
		default = "6",
    },
    {
		name = "maxwellhome",
		label = "MaxwellHome",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.\nthere are more mods out there which adds new worlds.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But you have to enable another\ending world, otherwise a random ending world is loaded"},
            {description = "7", data = "7", hover="Load this world as ending map"},
        },                   
		default = "7",
    },
}
