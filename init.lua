-- Minetest 0.4.10+ mod: chat_anticurse
-- punish player for cursing by disconnecting them
--
--  Created in 2015 by Andrey. 
--  This mod is Free and Open Source Software, released under the LGPL 2.1 or later.
-- 
-- See README.txt for more information.

chat_anticurse = {}

-- List of curse words. Put spaces before and after word to prevent the
-- Scunthorpe problem: https://en.wikipedia.org/wiki/Scunthorpe_problem
local curse_words = {
	-- English
	" ass ",
	" dick ",
	" penis ",
	" pussy ",
	" horny ",
	" bitch ",
	" bitche ",
	" sex ",
	" cunt ", 
	" fuck ",
	" arsehole ",
	" cum ",
	
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
}

-- Returns true if a curse word is found
function chat_anticurse.is_curse_found(name, message)

	-- Is nil when minetest loads i guess?
	if not message then
		return false
	end

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

minetest.register_on_chat_message(
function(name, message) 
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
