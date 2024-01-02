name = "Adventure Mode"
description = "Requires my Teleportato mod!\n\nOvercome challenging worlds, loaded one after the other in the stlye of the Dont Starve adventure!\n\nModsettings from this and teleportato mod work together, so don't forget to adjust both to your liking.\nThis mod overwrites the Ancient Station, Thulecite, StatsSave, NewWorld and regenerate-stats setting from teleportato mod, so these settings wont do anything over there.\n\n If you want, you can change season/daylength and other worldsettings after worldgeneration in the games settingsscreen." 
author = "Serpens"
forumthread = ""

version = "0.994"
api_version = 10

dst_compatible = true

client_only_mod = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 9000 -- load before the teleportato mod

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {"adventure","adventure mode","adventurejump","worldgen"}

mod_dependencies = 
{
    {
        workshop = "workshop-756229217", -- dependent on my teleportato mod. this will automatically load it, when enabling adventure mod.
    }
}

configuration_options = 
{
	{
		name = "experimentalcode",
		label = "Testcode",
		hover = "Enable if you want to test new features that could include bugs. (currently none)",
		options = 
		{
            {description = "disabled", data = false, hover=""},
            {description = "enabled", data = true, hover=""},
        },                   
		default = false,
    },
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
            {description = "worldsettings", data = false, hover="Generate your custom worldsettings and place the portal somewhere. (variateworld from teleportato mod wont work)"},
            {description = "preconfigured", data = true, hover="A small swamp world, you will quickly find the portal and start adventure."},
        },                   
		default = true,
    },
    {
		name = "repickcharacter",
		label = "Repick character?",
		hover = "Repick character after worldjump? If disabled, you also wont receive character-startitems for chapter 2 and onwards.",
		options = 
		{
            {description = "no repick", data = false, hover="Always same character and no startitems for chapter 2 and onwards"},
            {description = "repick", data = true, hover="Able to repick character and get startitems every time."},
        },                   
		default = false,
    },
    {
		name = "withocean",
		label = "Ocean?",
		hover = "Worlds with or without ocean? (wormholes will only spawn on island worlds)",
		options = 
		{
            {description = "only wormholes", data = "wormholes", hover="boats are disabled, use wormholes just like in DS"},
            {description = "only ocean", data = "ocean", hover="with ocean, without wormholes, so you have to use boats."},
            {description = "ocean and wormholes", data = "oceanwormholes", hover="with ocean and wormholes, so you can also use boats."},
        },                   
		default = "oceanwormholes",
    },
    {
		name = "null_option",
		label = "Customize",
		hover = "Customize some worldsettings",
		options =	{
						{description = "\n", data = 0, hover = "\n"},
					},
		default = 0,
	},
    {
		name = "worldsizeacoldreception",
		label = "Worldsize ACR",
		hover = "Worldsize for A Cold Reception.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "small", data = "small", hover="wont work on PS4"},
            {description = "medium", data = "medium", hover=""},
            {description = "large", data = "default", hover=""},
            {description = "huge", data = "huge", hover="wont work on PS4"},
        },                   
		default = false,
    },
    {
		name = "startseasonacoldreception",
		label = "Startseason ACR",
		hover = "Startseason in A Cold Reception. 10 days long if season is set to noseason.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "autumn", data = "default", hover=""},
            {description = "winter", data = "winter", hover=""},
            {description = "spring", data = "spring", hover=""},
            {description = "summer", data = "summer", hover=""},
            {description = "autumnorspring", data = "autumn|spring", hover=""},
            {description = "winterorsummer", data = "winter|summer", hover=""},
            {description = "random", data = "autumn|winter|spring|summer", hover=""},
        },                   
		default = false,
    },
    {
		name = "autumnacoldreception",
		label = "Autumn ACR",
		hover = "Autumn in A Cold Reception.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "winteracoldreception",
		label = "Winter ACR",
		hover = "Winter in A Cold Reception.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "springacoldreception",
		label = "Spring ACR",
		hover = "Spring in A Cold Reception.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "summeracoldreception",
		label = "Summer ACR",
		hover = "Summer in A Cold Reception.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "dayacoldreception",
		label = "Day ACR",
		hover = "Daylength in A Cold Reception.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "normal", data = "default", hover=""},
            {description = "longday", data = "longday", hover=""},
            {description = "longdusk", data = "longdusk", hover=""},
            {description = "longnight", data = "longnight", hover=""},
            {description = "noday", data = "noday", hover=""},
            {description = "nodusk", data = "nodusk", hover=""},
            {description = "nonight", data = "nonight", hover=""},
            {description = "onlyday", data = "onlyday", hover=""},
            {description = "onlydusk", data = "onlydusk", hover=""},
            {description = "onlynight", data = "onlynight", hover=""},
            
        },                   
		default = false,
    },
    {
		name = "worldsizekingofwinter",
		label = "Worldsize KoW",
		hover = "Worldsize for King of Winter.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "small", data = "small", hover="wont work on PS4"},
            {description = "medium", data = "medium", hover=""},
            {description = "large", data = "default", hover=""},
            {description = "huge", data = "huge", hover="wont work on PS4"},
        },                   
		default = false,
    },
    {
		name = "startseasonkingofwinter",
		label = "Startseason KoW",
		hover = "Startseason in King of Winter. 10 days long if season is set to noseason.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "autumn", data = "default", hover=""},
            {description = "winter", data = "winter", hover=""},
            {description = "spring", data = "spring", hover=""},
            {description = "summer", data = "summer", hover=""},
            {description = "autumnorspring", data = "autumn|spring", hover=""},
            {description = "winterorsummer", data = "winter|summer", hover=""},
            {description = "random", data = "autumn|winter|spring|summer", hover=""},
        },                   
		default = false,
    },
    {
		name = "autumnkingofwinter",
		label = "Autumn KoW",
		hover = "Autumn in King of Winter.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "winterkingofwinter",
		label = "Winter KoW",
		hover = "Winter in King of Winter.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "springkingofwinter",
		label = "Spring KoW",
		hover = "Spring in King of Winter.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "summerkingofwinter",
		label = "Summer KoW",
		hover = "Summer in King of Winter.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "daykingofwinter",
		label = "Day KoW",
		hover = "Daylength in King of Winter.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "normal", data = "default", hover=""},
            {description = "longday", data = "longday", hover=""},
            {description = "longdusk", data = "longdusk", hover=""},
            {description = "longnight", data = "longnight", hover=""},
            {description = "noday", data = "noday", hover=""},
            {description = "nodusk", data = "nodusk", hover=""},
            {description = "nonight", data = "nonight", hover=""},
            {description = "onlyday", data = "onlyday", hover=""},
            {description = "onlydusk", data = "onlydusk", hover=""},
            {description = "onlynight", data = "onlynight", hover=""},
            
        },                   
		default = false,
    },
    {
		name = "worldsizethegameisafoot",
		label = "Worldsize TGiA",
		hover = "Worldsize for The Game is Afoot.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "small", data = "small", hover="wont work on PS4"},
            {description = "medium", data = "medium", hover=""},
            {description = "large", data = "default", hover=""},
            {description = "huge", data = "huge", hover="wont work on PS4"},
        },                   
		default = false,
    },
    {
		name = "startseasonthegameisafoot",
		label = "Startseason TGiA",
		hover = "Startseason in The Game is Afoot. 10 days long if season is set to noseason.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "autumn", data = "default", hover=""},
            {description = "winter", data = "winter", hover=""},
            {description = "spring", data = "spring", hover=""},
            {description = "summer", data = "summer", hover=""},
            {description = "autumnorspring", data = "autumn|spring", hover=""},
            {description = "winterorsummer", data = "winter|summer", hover=""},
            {description = "random", data = "autumn|winter|spring|summer", hover=""},
        },                   
		default = false,
    },
    {
		name = "autumnthegameisafoot",
		label = "Autumn TGiA",
		hover = "Autumn in The Game is Afoot.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "winterthegameisafoot",
		label = "Winter TGiA",
		hover = "Winter in The Game is Afoot.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "springthegameisafoot",
		label = "Spring TGiA",
		hover = "Spring in The Game is Afoot.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "summerthegameisafoot",
		label = "Summer TGiA",
		hover = "Summer in The Game is Afoot.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "daythegameisafoot",
		label = "Day TGiA",
		hover = "Daylength in The Game is Afoot.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "normal", data = "default", hover=""},
            {description = "longday", data = "longday", hover=""},
            {description = "longdusk", data = "longdusk", hover=""},
            {description = "longnight", data = "longnight", hover=""},
            {description = "noday", data = "noday", hover=""},
            {description = "nodusk", data = "nodusk", hover=""},
            {description = "nonight", data = "nonight", hover=""},
            {description = "onlyday", data = "onlyday", hover=""},
            {description = "onlydusk", data = "onlydusk", hover=""},
            {description = "onlynight", data = "onlynight", hover=""},
            
        },                   
		default = false,
    },
    {
		name = "worldsizearchipelago",
		label = "Worldsize Arch.",
		hover = "Worldsize for Archipelago.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "small", data = "small", hover="wont work on PS4"},
            {description = "medium", data = "medium", hover=""},
            {description = "large", data = "default", hover=""},
            {description = "huge", data = "huge", hover="wont work on PS4"},
        },                   
		default = false,
    },
    {
		name = "startseasonarchipelago",
		label = "Startseason Arch.",
		hover = "Startseason in Archipelago. 10 days long if season is set to noseason.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "autumn", data = "default", hover=""},
            {description = "winter", data = "winter", hover=""},
            {description = "spring", data = "spring", hover=""},
            {description = "summer", data = "summer", hover=""},
            {description = "autumnorspring", data = "autumn|spring", hover=""},
            {description = "winterorsummer", data = "winter|summer", hover=""},
            {description = "random", data = "autumn|winter|spring|summer", hover=""},
        },                   
		default = false,
    },
    {
		name = "autumnarchipelago",
		label = "Autumn Arch.",
		hover = "Autumn in Archipelago.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "winterarchipelago",
		label = "Winter Arch.",
		hover = "Winter in Archipelago.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "springarchipelago",
		label = "Spring Arch.",
		hover = "Spring in Archipelago.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "summerarchipelago",
		label = "Summer Arch.",
		hover = "Summer in Archipelago.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "dayarchipelago",
		label = "Day Arch.",
		hover = "Daylength in Archipelago.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "normal", data = "default", hover=""},
            {description = "longday", data = "longday", hover=""},
            {description = "longdusk", data = "longdusk", hover=""},
            {description = "longnight", data = "longnight", hover=""},
            {description = "noday", data = "noday", hover=""},
            {description = "nodusk", data = "nodusk", hover=""},
            {description = "nonight", data = "nonight", hover=""},
            {description = "onlyday", data = "onlyday", hover=""},
            {description = "onlydusk", data = "onlydusk", hover=""},
            {description = "onlynight", data = "onlynight", hover=""},
            
        },                   
		default = false,
    },
    {
		name = "worldsizetwoworlds",
		label = "Worldsize Two W.",
		hover = "Worldsize for Two Worlds.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "small", data = "small", hover="wont work on PS4"},
            {description = "medium", data = "medium", hover=""},
            {description = "large", data = "default", hover=""},
            {description = "huge", data = "huge", hover="wont work on PS4"},
        },                   
		default = false,
    },
    {
		name = "startseasontwoworlds",
		label = "Startseason Two W.",
		hover = "Startseason in Two Worlds. 10 days long if season is set to noseason.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "autumn", data = "default", hover=""},
            {description = "winter", data = "winter", hover=""},
            {description = "spring", data = "spring", hover=""},
            {description = "summer", data = "summer", hover=""},
            {description = "autumnorspring", data = "autumn|spring", hover=""},
            {description = "winterorsummer", data = "winter|summer", hover=""},
            {description = "random", data = "autumn|winter|spring|summer", hover=""},
        },                   
		default = false,
    },
    {
		name = "autumntwoworlds",
		label = "Autumn Two W.",
		hover = "Autumn in Two Worlds.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "wintertwoworlds",
		label = "Winter Two W.",
		hover = "Winter in Two Worlds.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "springtwoworlds",
		label = "Spring Two W.",
		hover = "Spring in Two Worlds.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "summertwoworlds",
		label = "Summer Two W.",
		hover = "Summer in Two Worlds.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "daytwoworlds",
		label = "Day Two W.",
		hover = "Daylength in Two Worlds.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "normal", data = "default", hover=""},
            {description = "longday", data = "longday", hover=""},
            {description = "longdusk", data = "longdusk", hover=""},
            {description = "longnight", data = "longnight", hover=""},
            {description = "noday", data = "noday", hover=""},
            {description = "nodusk", data = "nodusk", hover=""},
            {description = "nonight", data = "nonight", hover=""},
            {description = "onlyday", data = "onlyday", hover=""},
            {description = "onlydusk", data = "onlydusk", hover=""},
            {description = "onlynight", data = "onlynight", hover=""},
            
        },                   
		default = false,
    },
    {
		name = "worldsizedarkness",
		label = "Worldsize Dark.",
		hover = "Worldsize for Darkness.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "small", data = "small", hover="wont work on PS4"},
            {description = "medium", data = "medium", hover=""},
            {description = "large", data = "default", hover=""},
            {description = "huge", data = "huge", hover="wont work on PS4"},
        },                   
		default = false,
    },
    {
		name = "startseasondarkness",
		label = "Startseason Dark.",
		hover = "Startseason in Darkness. 10 days long if season is set to noseason.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "autumn", data = "default", hover=""},
            {description = "winter", data = "winter", hover=""},
            {description = "spring", data = "spring", hover=""},
            {description = "summer", data = "summer", hover=""},
            {description = "autumnorspring", data = "autumn|spring", hover=""},
            {description = "winterorsummer", data = "winter|summer", hover=""},
            {description = "random", data = "autumn|winter|spring|summer", hover=""},
        },                   
		default = false,
    },
    {
		name = "autumndarkness",
		label = "Autumn Dark.",
		hover = "Autumn in Darkness.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "winterdarkness",
		label = "Winter Dark.",
		hover = "Winter in Darkness.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "springdarkness",
		label = "Spring Dark.",
		hover = "Spring in Darkness.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "summerdarkness",
		label = "Summer Dark.",
		hover = "Summer in Darkness.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "none", data = "noseason", hover=""},
            {description = "veryshortseason", data = "veryshortseason", hover=""},
            {description = "shortseason", data = "shortseason", hover=""},
            {description = "medium", data = "default", hover=""},
            {description = "longseason", data = "longseason", hover=""},
            {description = "verylongseason", data = "verylongseason", hover=""},
            {description = "random", data = "random", hover=""},
        },                   
		default = false,
    },
    {
		name = "daydarkness",
		label = "Day Dark.",
		hover = "Daylength in Darkness.",
		options = 
		{
            {description = "Default", data = false, hover="the default of this mod"},
            {description = "normal", data = "default", hover=""},
            {description = "longday", data = "longday", hover=""},
            {description = "longdusk", data = "longdusk", hover=""},
            {description = "longnight", data = "longnight", hover=""},
            {description = "noday", data = "noday", hover=""},
            {description = "nodusk", data = "nodusk", hover=""},
            {description = "nonight", data = "nonight", hover=""},
            {description = "onlyday", data = "onlyday", hover=""},
            {description = "onlydusk", data = "onlydusk", hover=""},
            {description = "onlynight", data = "onlynight", hover=""},
            
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
		name = "checkmate",
		label = "Checkmate",
		hover = "Enable/Disable the default adventure worlds\nfor some you can also set the position when they will started.",
		options = 
		{
            {description = "off", data = "", hover="Dont load this world. But you have to enable another\ending world, otherwise a random ending world is loaded"},
            {description = "7", data = "7", hover="Load this world as ending map"},
        },                   
		default = "7",
    },
}
