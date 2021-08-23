-- parsing the inifile
-- -- dump for debug
--
local sname = "Prismo"
local wiki_tab_1="Server"
local wiki_tab_2="Rules"
local wiki_tab_3="Commands"
local wiki_tab_4="News"

-- parse the text file and do this
local sal = "Manually override this message or create a file in /<worldname>/wiki"
local wiki_tab_text_1=sal .. "/server.txt"
local wiki_tab_text_2=sal .. "/rules.txt"
local wiki_tab_text_3=sal .. "/commands.txt"
local wiki_tab_text_4=sal .. "/news.txt"

local curr_tab = 1
local curr_tab_text = ""

local fname = {}
fname[1] = "server.txt"
fname[2] = "rules.txt"
fname[3] = "commands.txt"
fname[4] = "news.txt"

-- sets the wikitext
local function set_wikitext(opt,text)
    if opt == 1 then wiki_tab_text_1 = text end
    if opt == 2 then wiki_tab_text_2 = text end
    if opt == 3 then wiki_tab_text_3 = text end
    if opt == 4 then wiki_tab_text_4 = text end
end
-- gets wikitext
local function get_wikitext(fnumber)
local text = ""
    if fnumber==1 then text=wiki_tab_text_1 end
    if fnumber==2 then text=wiki_tab_text_2 end
    if fnumber==3 then text=wiki_tab_text_3 end
    if fnumber==4 then text=wiki_tab_text_4 end
return text;
end
-- ops 1 : read
-- ops 2 : write
function wikiparser(opt,ops,pname)
    local file_path = minetest.get_worldpath().."/wiki/"..fname[opt]
    local f = io.open(file_path,"r+")
    if f then
        if ops == 2 then
            -- find a way to write the file
            -- we know which tab is open
            f:write(curr_tab_text)
            print(pname.." successfully wrote "..fname[opt]..":\n"..curr_tab_text)
            f:close()
        end
    end
    f = io.open(file_path)
    if f then set_wikitext(opt,f:read"*a"); f:close() end
end
-- mode : 0 viewer mode
-- mode : 1 editor mode
-- note : mode and ops var is intertwined "it just works!"
local function get_wikiformspec(player,fnumber,mode)
    curr_tab = fnumber
    local pname = player:get_player_name()
    local privs = minetest.get_player_privs(pname)

    wikiparser(fnumber,mode,pname)
    if mode == 2 then
        mode = 0
    end
    local wiki_fs = "size[8.01,8.78]"..
            "button[-0.06,-0.15;2.05,0.91;tab1;".. wiki_tab_1 .. "]"..
            "button[1.86,-0.15;2.21,0.91;tab2;".. wiki_tab_2 .."]"..
            "button[3.94,-0.15;2.13,0.91;tab3;".. wiki_tab_3 .. "]"..
            "button[5.94,-0.15;2.13,0.91;tab4;".. wiki_tab_4 .."]"..
            "button_exit[5.94,8.43;2.13,0.74;close;Close]"..
            "label[0.02,8.52;".. sname .. " Guide]"
    if privs.wikieditor then
         if mode == 0 then
            wiki_fs = wiki_fs .. "button[4.57,8.43;1.5,0.74;edit;Edit]"
         elseif mode == 1 then
            wiki_fs = wiki_fs .. "button[4.57,8.43;1.5,0.74;save;Save]"..
            "button[3.25,8.43;1.5,0.74;cancel;Cancel]"
         end
    end
    local text = get_wikitext(fnumber)
    wiki_fs = wiki_fs.."textarea[0.24,0.8;8.12,8.85;info;;".. minetest.formspec_escape(text) .."]"
    minetest.show_formspec(pname,"wiki",wiki_fs)
end
-- on pressing buttons
minetest.register_on_player_receive_fields(function(player,formname, fields)
    if formname=="wiki" then
        curr_tab_text = fields.info
        if fields.tab1 then get_wikiformspec(player,1,0) end
        if fields.tab2 then get_wikiformspec(player,2,0) end
        if fields.tab3 then get_wikiformspec(player,3,0) end
        if fields.tab4 then get_wikiformspec(player,4,0) end
        if fields.edit then get_wikiformspec(player,curr_tab,1) end
        if fields.cancel then get_wikiformspec(player,curr_tab,0) end
        if fields.save then get_wikiformspec(player,curr_tab,2)  end
    end
end)

-- register a new priv called wikieditor
minetest.register_privilege("wikieditor", {
	description = "allows editing server wiki",
	give_to_singleplayer = false
})

-- command to display server news at any time
minetest.register_chatcommand("wiki", {
    params = "",
	description = "Shows server wiki formspec to player",
	func = function (name,param)
        get_wikiformspec(minetest.get_player_by_name(name),1,0)
        return true
	end
})
print("[OK] : Wiki Mod")
