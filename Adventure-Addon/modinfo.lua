name = "Adventure Mode"
description = "[BETA]\nRequires my Teleportato mod!\n\nOvercome challenging worlds, loaded one after the other in the stlye of the Dont Starve adventure!\n\nModsettings from this and teleportato mod work together, so don't forget to adjust both to your liking." 
author = "Serpens"
forumthread = ""

version = "0.93"
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
		hover = "You also can set this to DS! Dont change this for a running game.",
		options = 
		{
			{description = "DS", data = 0, hover="Only necessary changes. It will be the same like the DS adventure for the most parts."},
            {description = "Easy", data = 1, hover="More starting items, an easy adventure."},
            {description = "Medium", data = 2, hover="Moderate starting items, a normal adventure."},
            {description = "Hard", data = 3, hover="Few starting items, a hard adventure."}, -- many code is dependent on these values 0-3, so do not change or add these values without adjusting all the code!
        },
		default = 2,
    },
    {
		name = "sandboxpreconfigured",
		label = "Custom Maxwells Door",
		hover = "Should the level -Maxwells Door- which is the first level, depend on your worldsettings or preconfigured?",
		options = 
		{
            {description = "worldsettings", data = false, hover="Generate your custom worldsettings and place the portal somewhere."},
            {description = "preconfigured", data = true, hover="A small swamp world, you will quickly find the portal and start adventure."},
        },                   
		default = true,
    },
    {
		name = "repickcharacter",
		label = "Repick character?",
		hover = "Currently not working, only effect is that at chapter 2 and onwards you wont get characters starting items",
		options = 
		{
            {description = "repick", data = true, hover="will get starting items of chosen character everytime"},
            {description = "no repick", data = false, hover="wont get starting items of chosen character for chapter 2 and onwards"},
        },                   
		default = false,
    },
    {
		name = "null_option",
		label = "WORLDS",
		hover = "Select which worlds should be acitve, a minimum of 7 are needed in total:",
		options =	{
						{description = "\n", data = 0, hover = "\n"},
					},
		default = 0,
	},
    {
		name = "maxwellsdoor",
		label = "Maxwells Door",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
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
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But if not enough worlds are active,\nrandom ones will load, even it they are disabled."},
            {description = "2", data = "2", hover="\n"},
            {description = "3", data = "3", hover="\n"},
            {description = "4", data = "4", hover="\n"},
            {description = "5", data = "5", hover="\n"},
            {description = "2,3,4", data = "2,3,4", hover="Randomly between 2 and 4"},
            {description = "2,3", data = "2,3", hover="\n"},
            {description = "2,4", data = "2,4", hover="\n"},
            {description = "2,5", data = "2,5", hover="\n"},
            {description = "3,4", data = "3,4", hover="\n"},
            {description = "3,5", data = "3,5", hover="\n"},
            {description = "4,5", data = "4,5", hover="\n"},
            {description = "2,3,4,5", data = "2,3,4,5", hover="\n"},
            {description = "3,4,5", data = "3,4,5", hover="\n"},
            {description = "2,4,5", data = "2,4,5", hover="\n"},
            {description = "2,3,5", data = "2,3,5", hover="\n"},
        },                   
		default = "2,3,4",
    },
    {
		name = "kingofwinter",
		label = "King of Winter",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
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
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
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
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
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
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
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
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
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
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But you have to enable another\ending world, otherwise a random ending world is loaded"},
            {description = "7", data = "7", hover="Load this world as ending map"},
        },                   
		default = "7",
    },
}
