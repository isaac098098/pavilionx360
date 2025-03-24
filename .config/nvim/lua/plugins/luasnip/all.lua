-- Visual placeholder
-- taken from https://ejmastnak.com/

local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return{

-- Delimiters

-- s(
    -- {trig = "(", descr = "Parentheses", snippetType = "autosnippet", wordTrig = false},
    -- {
        -- t("("), d(1,get_visual), t(")")
    -- }
-- ),
-- 
-- s(
    -- {trig = "[", descr = "Square brackets", snippetType = "autosnippet", wordTrig = false},
    -- {
        -- t("["), d(1,get_visual), t("]")
    -- }
-- ),
-- 
-- s(
    -- {trig = "{", descr = "Curly brackets", snippetType = "autosnippet", wordTrig = false},
    -- {
        -- t("{"), d(1,get_visual), t("}") }
-- ),
-- 
-- s(
    -- {trig = "\"", descr = "Double quotes", snippetType = "autosnippet", wordTrig = false},
    -- {
        -- t("\""), d(1,get_visual), t("\"")
    -- }
-- ),

}
