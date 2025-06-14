---@diagnostic disable: undefined-field
--luacheck: globals table
local Stats = require 'utils.math.stats'
local Geometry = require 'utils.math.geometry'
local random = math.random
local floor = math.floor
local remove = table.remove
local tonumber = tonumber
local pairs = pairs
local table_size = table_size

---Searches a table to remove a specific element without an index
---@param t table #table to search
---@param element any #table element to search for
function table.remove_element(t, element)
    for k, v in pairs(t) do
        if v == element then
            remove(t, k)
            break
        end
    end
end

---Removes an item from an array in O(1) time.
---The catch is that fast_remove doesn't guarantee to maintain the order of items in the array.
---@param tbl table #arrayed table
---@param index number #Must be >= 0. The case where index > #tbl is handled.
function table.fast_remove(tbl, index)
    local count = #tbl
    if index > count then
        return
    elseif index < count then
        tbl[index] = tbl[count]
    end

    tbl[count] = nil
end

---Adds the contents of table t2 to table t1
---@param t1 table #table to insert into
---@param t2 table #table to insert from
function table.add_all(t1, t2)
    for k, v in pairs(t2) do
        if tonumber(k) then
            t1[#t1 + 1] = v
        else
            t1[k] = v
        end
    end
end

---Checks if a table contains an element
---@param t table
---@param e any #table element
---@return any #the index of the element or nil
function table.index_of(t, e)
    for k, v in pairs(t) do
        if v == e then
            return k
        end
    end
    return nil
end

---Checks if the arrayed portion of a table contains an element
---@param t table
---@param e any #table element
---@return number|nil #the index of the element or nil
function table.index_of_in_array(t, e)
    for i = 1, #t do
        if t[i] == e then
            return i
        end
    end
    return nil
end

local index_of = table.index_of
---Checks if a table contains an element
---@param t table
---@param e any #table element
---@return boolean #boolean indicating success
---@diagnostic disable-next-line: duplicate-set-field access-global-from-locals
function table.contains(t, e)
    return index_of(t, e) and true or false
end

local index_of_in_array = table.index_of_in_array
---Checks if the arrayed portion of a table contains an element
---@param t table
---@param e any #table element
---@return boolean #boolean indicating success
function table.array_contains(t, e)
    return index_of_in_array(t, e) and true or false
end

---Adds an element into a specific index position while shuffling the rest down
---@param t table #table to add into
---@param index number #index of the position in the table to add to
---@param element any #element to add to the table
function table.set(t, index, element)
    local i = 1
    for k in pairs(t) do
        if i == index then
            t[k] = element
            return nil
        end
        i = i + 1
    end
    error('Index out of bounds', 2)
end

---Returns an array of keys for a table.
---@param tbl table
function table.keys(tbl)
    local n = 1
    local keys = {}

    for k in pairs(tbl) do
        keys[n] = k
        n = n + 1
    end

    return keys
end

---Chooses a random entry from a table.
---Because this uses math.random, it cannot be used outside of events
---@param t table
---@param key boolean #boolean to indicate whether to return the key or value
---@return any #a random element of table t
function table.get_random_dictionary_entry(t, key)
    local target_index = random(1, table_size(t))
    local count = 1
    for k, v in pairs(t) do
        if target_index == count then
            if key then
                return k
            else
                return v
            end
        end
        count = count + 1
    end
end

---Chooses a random entry from a weighted table.
---Because this uses math.random, it cannot be used outside of events
---@param weighted_table table #table of tables with items and their weights
---@param item_index number|nil #number of the index of items, defaults to 1
---@param weight_index number|nil #number of the index of the weights, defaults to 2
---@return any # any table element
-- @see features.chat_triggers::hodor
function table.get_random_weighted(weighted_table, item_index, weight_index)
    local total_weight = 0
    item_index = item_index or 1
    weight_index = weight_index or 2

    for _, w in pairs(weighted_table) do
        total_weight = total_weight + w[weight_index]
    end

    local index = random() * total_weight
    local weight_sum = 0
    for _, w in pairs(weighted_table) do
        weight_sum = weight_sum + w[weight_index]
        if weight_sum >= index then
            return w[item_index]
        end
    end
end

---Creates a fisher-yates shuffle of a sequential number-indexed table.
---Because this uses math.random, it cannot be used outside of events if no rng is supplied
---from: http://www.sdknews.com/cross-platform/corona/tutorial-how-to-shuffle-table-items
---@param t table #table to shuffle
---@param rng number|nil
function table.shuffle_table(t, rng)
    local rand = rng or random
    local iterations = #t
    if iterations == 0 then
        error('Not a sequential table')
        return
    end
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

---Shuffles a table of objects with a position, leaving objects closer to position to be earlier in the table (one time semi-sort)
---@param tbl table #table to shuffle, all elements in it have to be table objects that have position key
---@param position MapPosition|{x:double,y:double}
function table.shuffle_by_distance(tbl, position)
    local function pos(obj)
        if obj and obj.valid and obj.position then
            return obj.position
        end
        error('entry was not valid or does not have position!', 2)
    end
    local size = #tbl
    for i = size, 1, -1 do
        local rand = random(size)
        if Geometry.is_closer(pos(tbl[i]), pos(tbl[rand]), position) and i > rand then
            tbl[i], tbl[rand] = tbl[rand], tbl[i]
        end
    end
end

--- pairs() iterator but sorted by specified function
---@param t table
---@param order function # example: function(t,a,b) return t[b] > t[a] end
---@return function # usage: for k, v in spairs(table, function()) do ...
function table.spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function (a, b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function ()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--- Clears all existing entries in a table
---@param t table to clear
---@param array boolean to indicate whether the table is an array or not
function table.clear_table(t, array)
    if array then
        for i = 1, #t do
            t[i] = nil
        end
    else
        for i in pairs(t) do
            t[i] = nil
        end
    end
end

--[[
  Returns the index where t[index] == target.
  If there is no such index, returns a negative value such that bit32.bnot(value) is
  the index that the value should be inserted to keep the list ordered.
  t must be a list in ascending order for the return value to be valid.

  Usage example:
  local t = {1,3,5,7,9}
  local x = 5
  local index = table.binary_search(t, x)
  if index < 0 then
    game.print("value not found, smallest index where t[index] > x is: " .. bit32.bnot(index))
  else
    game.print("value found at index: " .. index)
  end
]]
function table.binary_search(t, target)
    --For some reason bit32.bnot doesn't return negative numbers so I'm using ~x = -1 - x instead.

    local lower = 1
    local upper = #t

    if upper == 0 then
        return -2 -- ~1
    end

    repeat
        local mid = floor((lower + upper) * 0.5)
        local value = t[mid]
        if value == target then
            return mid
        elseif value < target then
            lower = mid + 1
        else
            upper = mid - 1
        end
    until lower > upper

    return -1 - lower -- ~lower
end

-- add table-related functions that exist in base factorio/util to the 'table' table
require 'util'

--- Similar to serpent.block, returns a string with a pretty representation of a table.
-- Notice: This method is not appropriate for saving/restoring tables. It is meant to be used by the programmer mainly while debugging a program.
-- @param table <table> the table to serialize
-- @param options <table> options are depth, newline, indent, process
-- depth sets the maximum depth that will be printed out. When the max depth is reached, inspect will stop parsing tables and just return {...}
-- process is a function which allow altering the passed object before transforming it into a string.
-- A typical way to use it would be to remove certain values so that they don't appear at all.
-- return <string> the prettied table
table.inspect = require 'utils.inspect'

--- Takes a table and returns the number of entries in the table. (Slower than #table, faster than iterating via pairs)
table.size = table_size

--- Creates a deepcopy of a table. Metatables and LuaObjects inside the table are shallow copies.
-- Shallow copies meaning it copies the reference to the object instead of the object itself.
-- @param object <table> the object to copy
-- @return <table> the copied object
table.deep_copy = table.deepcopy

--- Merges multiple tables. Tables later in the list will overwrite entries from tables earlier in the list.
-- Ex. merge({{1, 2, 3}, {[2] = 0}, {[3] = 0}}) will return {1, 0, 0}
-- @param tables <table> takes a table of tables to merge
-- @return <table> a merged table
table.merge = util.merge

--- Determines if two tables are structurally equal.
-- Notice: tables that are LuaObjects or contain LuaObjects won't be compared correctly, use == operator for LuaObjects
-- @param tbl1 <table>
-- @param tbl2 <table>
-- @return <boolean>
table.equals = table.compare

--- Gets the median value out of a table.
-- @param tbl1 <table>
-- @return <int>
table.mean = Stats.mean

return table
