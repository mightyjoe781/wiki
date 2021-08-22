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

function wikiparser(opt)
    local file_path = minetest.get_worldpath().. "/wiki"
    if opt == 1 then
        local f1 = io.open(file_path.."/server.txt")
        if f1 then
            wiki_tab_text_1=f1:read("*a")
            f1:close()
        end
    end

    if opt == 2 then
        local f2 = io.open(file_path.."/rules.txt")
        if f2 then
            wiki_tab_text_2=f2:read("*a")
            f2:close()
        end
    end

    if opt == 3 then
        local f3 = io.open(file_path.."/commands.txt")
        if f3 then
            wiki_tab_text_3=f3:read("*a")
            f3:close()
        end
    end
    if opt == 4 then
        local f4 = io.open(file_path.."/news.txt")
        if f4 then
            wiki_tab_text_4=f4:read("*a")
            f4:close()
        end
    end
end
local function get_wikitext(text_to_show)
local text = ""
if text_to_show==1 then text=wiki_tab_text_1 end
if text_to_show==2 then text=wiki_tab_text_2 end
if text_to_show==3 then text=wiki_tab_text_3 end
if text_to_show==4 then text=wiki_tab_text_4 end
return text;
end
local function get_wikiformspec(player,text_to_show)
    local wiki_fs = "size[8.01,8.78]"..
            "button[-0.06,-0.15;2.05,0.91;tab1;".. wiki_tab_1 .. "]"..
            "button[1.86,-0.15;2.21,0.91;tab2;".. wiki_tab_2 .."]"..
            "button[3.94,-0.15;2.13,0.91;tab3;".. wiki_tab_3 .. "]"..
            "button[5.94,-0.15;2.13,0.91;tab4;".. wiki_tab_4 .."]"..
            "button_exit[5.94,8.43;2.13,0.74;close;Close]"..
            "label[0.02,8.52;".. sname .. " Guide]"
    -- singlelineparser() -- update the tabs values based on single line ini
    wikiparser(text_to_show)
    local text = get_wikitext(text_to_show)
    wiki_fs = wiki_fs.."textarea[0.24,0.8;8.12,8.85;info;;".. minetest.formspec_escape(text) .."]"
    minetest.show_formspec(player:get_player_name(),"wiki",wiki_fs)
end
-- on pressing buttons
minetest.register_on_player_receive_fields(function(player,formname, fields)
    if formname=="wiki" then
        if fields.tab1 then get_wikiformspec(player,1) end
        if fields.tab2 then get_wikiformspec(player,2) end
        if fields.tab3 then get_wikiformspec(player,3) end
        if fields.tab4 then get_wikiformspec(player,4) end
    end
end)

-- command to display server news at any time
minetest.register_chatcommand("wiki", {
    params = "",
	description = "Shows server wiki formspec to player",
	func = function (name,param)
        get_wikiformspec(minetest.get_player_by_name(name),1)
        return true
	end
})
print("[OK] : Wiki Mod")
