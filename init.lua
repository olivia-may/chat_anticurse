-- Minetest 0.4.10+ mod: chat_anticurse
-- punish player for cursing by disconnecting them
--
--  Created in 2015 by Andrey.
--  Updated in 2024 by Olivia May.
--  Some words from NoNameDude
--  This mod is Free and Open Source Software, released under the LGPL 2.1 or later.
--
-- See README.txt for more information.

chat_anticurse = {}

local v1 = "i"
local v2 = "a"
local v3 = "u"
local v4 = "e"
local v5 = "o"

-- List of curse words. Put spaces before and after word to prevent the
-- Scunthorpe problem: https://en.wikipedia.org/wiki/Scunthorpe_problem
-- Some words don't have spaces because they shouldn't be in any words.
local curse_words = {
	-- English
	" " .. v2 .. "ss ",
	" d" .. v1 .. "ck ",
	" p" .. v4 .. "n" .. v1 .. "s ",
	"t" .. v4 .. "st" .. v1 .. "cl" .. v4 .. "",
	" p" .. v3 .. "ssy ",
	" h" .. v5 .. "rny ",
	" b" .. v1 .. "tch ",
	" b" .. v1 .. "tch" .. v4 .. " ",
	" " .. v4 .. "s" .. v4 .. "x ",
	" c" .. v3 .. "nt ",
	" f" .. v3 .. "ck ",
	"" .. v2 .. "rs" .. v4 .. "h" .. v5 .. "l" .. v4 .. "",
	" c" .. v3 .. "m ",
	" sh" .. v1 .. "t ",
	"sh" .. v1 .. "tst" .. v5 .. "rm",
	"sh" .. v1 .. "tst" .. v2 .. "" .. v1 .. "n",
	" c" .. v5 .. "ck ",
	"n" .. v1 .. "gg" .. v4 .. "r",
	"f" .. v2 .. "gg" .. v5 .. "t",
	" f" .. v2 .. "g ",
	" wh" .. v5 .. "r" .. v4 .. " ",
	" " .. v1 .. "nc" .. v4 .. "l ",
	" c" .. v3 .. "ck ",
	" f" .. v3 .. "ck" .. v4 .. "r ",
	" f" .. v3 .. "ck" .. v1 .. "ng ",
	"m" .. v5 .. "th" .. v4 .. "rf" .. v3 .. "ck",
	" v" .. v2 .. "g" .. v1 .. "n" .. v2 .. " ",
	" v" .. v2 .. "g ",
	" v" .. v3 .. "lv" .. v2 .. " ",
	" cl" .. v1 .. "t ",
	" p" .. v4 .. "n" .. v1 .. "l" .. v4 .. " ",
	" " .. v2 .. "" .. v3 .. "t" .. v1 .. "st ",
	"m" .. v2 .. "st" .. v3 .. "rb" .. v2 .. "t",
	"" .. v1 .. "nt" .. v4 .. "rc" .. v5 .. "" .. v3 .. "rs" .. v4 .. "",
	"" .. v2 .. "ssh" .. v5 .. "l" .. v4 .. "",
	"" .. v2 .. "sswh" .. v1 .. "p" .. v4 .. "",
	"" .. v2 .. "ssw" .. v1 .. "p" .. v4 .. "",
	"c" .. v5 .. "cks" .. v3 .. "ck" .. v4 .. "r",
	"b" .. v1 .. "tch" .. v2 .. "ss",
	"t" .. v1 .. "tt" .. v1 .. "" .. v4 .. "s",
	" t" .. v1 .. "ts ",
	"d" .. v4 .. "g" .. v4 .. "n" .. v4 .. "r" .. v2 .. "t" .. v4 .. "",
	"b" .. v2 .. "st" .. v2 .. "rd",
	" p" .. v5 .. "rn ",

	-- Russian
	" еба ",
	" бля ",
	" жоп ",
	" хyй ",
	" член ",
	" пизд ",
	" возбуд ",
	" возбyж ",
	" сперм ",
	" бляд ",
	" блять ",
	" сокс ",
	" сука ",
	" мля ",
	" блин ",
	" твою мать ",
	" твою же мать ",
	" дибил ",
	" аут ",
	" аутист ",
	" манда ",
	" ебать ",
	" ебало закрой ",
	" заебал ",
	" отвали ",
	" заткнись ",
	" мудак ",
	" хуй ",
	" охуел? ",
	" это пиздец ",
	" пизда ",
	" сволочь ",
	" жопа ",
	" гавно ",
	" лох ",
	" гандон ",
	" ублюдок ",
	" срать ",
	" мне насрать ",
	" мне похуй ",
	" черт ",
	" трахнуть ",
	" трахнул ",
	" дегенерат ",
	" хрен ",
	" хуй ",
	" дерьмо ",
	" пошел к чорту ",
	" мне плевать ",
	" херня ",
	" хрень ",
	" один хрен ",
	" ни хрена ",
	" ну его нахрен ",
	" иди нахер ",
	" нахрен ",
	" пошёл ",
	" нахер ",
	" нахрен ",

	-- German
	" " .. v2 .. "rschl" .. v5 .. "ch ",
	" " .. v2 .. "rsch ",
	" schw" .. v2 .. "nz ",
	" w" .. v1 .. "chs" .. v4 .. "r ",
	" schl" .. v2 .. "mp" .. v4 .. " ",
	" h" .. v3 .. "rr" .. v4 .. " ",
	" f" .. v1 .. "ck d" .. v1 .. "ch ",
	" m" .. v3 .. "tt" .. v4 .. "rf" .. v1 .. "ck" .. v4 .. "r ",
	" h" .. v3 .. "r" .. v4 .. "ns" .. v5 .. "hn ",
	" m" .. v2 .. "st" .. v3 .. "b" .. v1 .. "r" .. v4 .. "n ",
	" sch" .. v4 .. "" .. v1 .. "d" .. v4 .. " ",
	" g" .. v4 .. "schl" .. v4 .. "chtsv" .. v4 .. "rk" .. v4 .. "hr ",
	" f" .. v5 .. "tz" .. v4 .. " ",
	" m" .. v1 .. "ssg" .. v4 .. "b" .. v3 .. "rt ",
	" m" .. v1 .. "ssg" .. v4 .. "b" .. v3 .. "rt ",
	" v" .. v5 .. "ll" .. v1 .. "d" .. v1 .. "" .. v5 .. "t ",
	" brüst" .. v4 .. " ",
	" t" .. v1 .. "tt" .. v4 .. "n ",
	" sch" .. v4 .. "" .. v1 .. "ß" .. v4 .. " ",
}

-- Returns true if a curse word is found
function chat_anticurse.is_curse_found(name, message)

	local checkingmessage=string.lower( name.." "..message .." " )
	local is_curse_found = false

	for i=1, #curse_words do
		if string.find(
			checkingmessage, curse_words[i],
			1, true) ~= nil then

			is_curse_found = true
			break
		end
	end

	if is_curse_found then
		minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
		minetest.chat_send_all("Player <"..name.."> warned for cursing" )
		minetest.log("action", "Player "..name.." warned for cursing. Chat:"..message)
	end

	return is_curse_found
end

minetest.register_on_chat_message(function(name, message)
	return chat_anticurse.is_curse_found(name, message)
end)

if minetest.chatcommands["me"] then

	local old_command = minetest.chatcommands["me"].func

	minetest.chatcommands["me"].func = function(name, param)

		if chat_anticurse.is_curse_found(name, param) then
			return nil
		end

		return old_command(name, param)
	end
end

if minetest.chatcommands["msg"] then

	local old_command = minetest.chatcommands["msg"].func

	minetest.chatcommands["msg"].func = function(name, param)

		if chat_anticurse.is_curse_found(name, param) then
			return nil
		end

		return old_command(name, param)
	end
end
