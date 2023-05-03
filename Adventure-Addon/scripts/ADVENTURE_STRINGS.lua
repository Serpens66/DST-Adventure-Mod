-- if devs of DST removed some of the STRINGS, use the following english ones:

-- some strings within my files are hardcoded, eg in adventure_portal.lua in teleportato mod or in maxwellintro.lua

local STRINGS = GLOBAL.STRINGS

if STRINGS.UI==nil then
    STRINGS.UI = {}
end
if STRINGS.NAMES==nil then
    STRINGS.NAMES = {}
end
if STRINGS.UI.UNLOCKMAXWELL==nil then
    STRINGS.UI.UNLOCKMAXWELL =  {
                                    TITLE = "Take pity?",
                                    BODY1 = "The key looks like it will fit. You can free ",
                                    BODY2 =", but I doubt %s captors will be pleased...",
                                    YES = "Yes",
                                    NO = "No",
                                }
end
if STRINGS.NAMES.MAXWELLLIGHT==nil then
    STRINGS.NAMES.MAXWELLLIGHT = "Maxwell's Light"
end
if STRINGS.MAXWELL_ADVENTURETHRONE==nil then
    STRINGS.MAXWELL_ADVENTURETHRONE = {
                                        LEVEL_6 =
                                        {
                                            INTRO =
                                            {
                                                ONE = "Is this how it ends?",
                                            },
                                            HIT =
                                            {
                                                ONE = "The throne won't allow that. I've tried.",
                                            },
                                            NOUNLOCK =
                                            {
                                                ONE = "Ah, I am a fool. I had dared to hope.",
                                            },
                                            PHONOGRAPHON =
                                            {
                                                ONE = "I guess I deserve that.",
                                            },
                                            PHONOGRAPHOFF =
                                            {
                                                ONE = "Thank you. I have been listening to that song for an eternity.",
                                            },
                                        },
                                    }
end
if STRINGS.MAXWELL_ADVENTUREINTROS==nil then
    STRINGS.MAXWELL_ADVENTUREINTROS = {
                                    LEVEL_1 =
                                    {
                                        ONE = "Oh, you found my portal did you?",
                                        TWO = "You'd think you would have learned your lesson by now.",
                                        --THREE = "Strange machinery hasn't exactly been kind to you in the past.",
                                        THREE = "Hmm. Let's try something a little more challenging, shall we?",
                                        --FIVE = "Let's see if you're as enthusiastic when it's fourty below.",
                                    },
                                    LEVEL_2 =
                                    {
                                        ONE = "Well would you look at that, you survived.",
                                        TWO = "One down, four to go!",
                                        --TWO = "Now don't get a big head, you aren't the first.",
                                        --THREE = "Let's see what you're really made of.",
                                        --FOUR = "And by that I mean to say,",
                                        --FIVE = "I will enjoy inspecting your entrails once the Deerclops is done with you.",
                                    },
                                    LEVEL_3 =
                                    {
                                        ONE = "What? You're still here?",
                                        TWO = "Impressive. But you should probably stop while you're ahead.",
                                        --TWO = "Must I do everything myself?",
                                        --THREE = "HOUNDS! DISPOSE OF THIS PEST!",
                                    },
                                    LEVEL_4 =
                                    {
                                        ONE = "Say, pal.",
                                        TWO = "You're really pushing your luck.",
                                        THREE = "Turn back now, or I may have to resort to drastic measures.",
                                    },
                                    TWOLANDS =
                                    {
                                        ONE = "Say, pal.",
                                        TWO = "Let's make a deal. You can stay here. Settle down, even.",
                                        THREE = "I'll give you food, gold, pigs, whatever you need.",
                                        FOUR = "All I want in return is a truce.",
                                    },
                                    LEVEL_5 =
                                    {
                                        ONE = "You insolent, pitiful, insignificant ant!",
                                        TWO = "Do not arouse the wrath of the Great Maxwell!",
                                        THREE = "You will regret coming any further...",
                                    },
                                    LEVEL_6 =
                                    {
                                        ONE = "Well, this is it.",
                                        TWO = "You found me. Now, what are you going to do?",
                                        TELEPORTFAIL = "Don't you think I've tried that?",
                                        TELEPORTFAIL2 = "This is the end of the line. We have no escape.",
                                        COMBATFAIL =
                                        {
                                            "Where would be the sport in that?",
                                            "Who do you think allowed you to make that?",
                                        },
                                        CONVERSATION =
                                        {
                                            "Is this what you were expecting?",
                                            "Forgive me if I don't get up.",
                                            "You've been an interesting plaything, but I've grown tired of this game.",
                                            "Or maybe They've grown tired of me.",
                                            "Heh. Took them long enough.",
                                            "They'll show you terrible, beautiful things.",
                                            "It will change you, like it did me.",
                                            "It's best not to fight it.",
                                            "There wasn't much here when I showed up.",
                                            "Just dust. And the void. And Them.",
                                            "I've learned so much since then. I've built so much.",
                                            "But even a King is bound to the board.",                
                                            "You can't change the rules of the game.",
                                            "I don't know what they want. They... they just watch.",
                                            "Unless you get too close. Then...",
                                            "Well, there's a reason I stay so dapper.",
                                            "What year is it out there? Time moves differently here.",
                                            "Go on, stay a while. Keep us company.",
                                            "Or put the key in the box. It's your decision.",
                                            "Either way, you're just delaying the inevitable.",
                                            "Reality is like that, sometimes.",
                                            "I think I've said enough.",
                                            "..."
                                        }
                                    },
                                }
end
if STRINGS.MAXWELL_ADVENTURE_HEAD==nil then
    STRINGS.MAXWELL_ADVENTURE_HEAD = {
                                        LEVEL_4 =
                                        {
                                            ONE = "Fine. Just remember that you chose this.",
                                        },
                                        LEVEL_6 =
                                        {
                                            ONE = "We're not so different, you and I.",
                                            TWO =
                                            {
                                                ONE = "That's why I brought you here.",
                                                TWO = "That's why I brought all of them here.",
                                            },
                                            THREE =
                                            {
                                                ONE = "Oh, did you think you were the first?",
                                                TWO = "HA!",
                                            },
                                            FOUR =
                                            {
                                                ONE = "It's just that...",
                                                TWO = "I've become accustomed to winning.",
                                            },
                                        },
                                    }
end
if STRINGS.MAXWELL_SANDBOXINTROS==nil then
    STRINGS.MAXWELL_SANDBOXINTROS = {
                                        ONE = "Say pal, you don't look so good.",
                                        TWO = "You'd better find something to eat before night comes!",       
                                    }
end
if STRINGS.UI.ENDGAME==nil then
    STRINGS.UI.ENDGAME = {
                            TITLE = "The End.",
                            BODY1 = "And so the cycle continues. Will ",
                            BODY2 = " ever escape?\n Perhaps %s, too, will tire of this wretched place, and use %s new powers to tempt the unsuspecting.\n\nThe mysterious beings that control this realm still lurk in the shadows, and new challenges will soon be revealed.\n\nUntil then,\n- The Don't Starve Team -",
                            YES = "For Science!",
                        }
end