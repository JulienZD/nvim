local M = {}

local cache = {} -- root_dir -> boolean

local function find_package_json(start)
  local found = vim.fs.find('package.json', {
    upward = true,
    stop = vim.uv.os_homedir(),
    path = start,
    type = 'file',
  })
  return found[1]
end

function M.uses_tsgo(root)
  root = root or vim.fn.getcwd()

  local pkg_path = find_package_json(root)
  if not pkg_path then
    return false
  end

  local pkg_root = vim.fs.dirname(pkg_path)
  if cache[pkg_root] ~= nil then
    return cache[pkg_root]
  end

  local result = false
  local ok, content = pcall(vim.fn.readfile, pkg_path)
  if ok then
    local decoded_ok, pkg = pcall(vim.json.decode, table.concat(content, '\n'))
    if decoded_ok and type(pkg) == 'table' then
      local function has(t)
        return type(t) == 'table' and t['@typescript/native-preview'] ~= nil
      end
      result = has(pkg.devDependencies) or has(pkg.dependencies)
    end
  end

  cache[pkg_root] = result
  return result
end

function M.invalidate()
  cache = {}
end

return M
