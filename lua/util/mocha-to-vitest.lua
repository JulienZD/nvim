local M = {}

-- %s/ fails if the search isn't found, so we use pcall to catch errors and ignore them
local function safe_sub(cmd)
  local ok, err = pcall(function()
    vim.cmd(cmd)
  end)
  if not ok then
    vim.notify('Substitution failed:\n' .. cmd .. '\n' .. err, vim.log.levels.WARN)
  end
end

function M.mocha_to_vitest()
  -- GENERAL MOCHA TO VITEST CONVERSIONS
  safe_sub [[
    %s/import .* from 'chai';/import { beforeAll, afterAll, afterEach, beforeEach, it, describe, expect, vi, MockInstance } from 'vitest';/g
  ]]

  safe_sub [[
    %s/before(/beforeAll(/g
  ]]

  safe_sub [[
    %s/after(/afterAll(/g
  ]]

  -- SINON TO VITEST CONVERSIONS

  -- sinon.stub(module, 'method’) to vi.spyOn(module, 'method').mockImplementation(vi.fn())
  safe_sub [[
    %s/sinon.stub(\(.*\), \(.*\));/vi.spyOn(\1, \2).mockImplementation(vi.fn());/g
  ]]

  -- `sinon.spy(module, ‘method’)` to `vi.spyOn(module, 'method’)`
  safe_sub [[
    %s/sinon.spy(\(.*\), \(.*\));/vi.spyOn(\1, \2);/g
  ]]

  -- `sinon.stub()` to `vi.fn()`
  safe_sub [[
    %s/sinon.stub();/vi.fn();/g
  ]]

  safe_sub [[
    %s/SinonStub/MockInstance/g
  ]]

  -- Promise assertion conversions

  safe_sub [[
    %s/expect(\(.*\)).to.eventually.be.rejectedWith(\(.*\), \(.*\))/expectErrorWithMessage(\1, \2, \3)/g
  ]]

  safe_sub [[
    %s/expect(\(.*\)).*rejectedWith(\(.*\), \(.*\))/expectErrorWithMessage(\1, \2, \3)/g
  ]]

  -- Multi-line rejection (e.g. expect(promise).to.eventually.be.rejectedWith(Error,\n'Message'))
  safe_sub [[
    %s/expect(\(.*\)).to.eventually.be.rejectedWith(\n\s*\(.*\),\n\s*\(.*\)\n\s*)/expectErrorWithMessage(\1, \2, \3)/g
  ]]

  safe_sub [[
    %s/).to.eventually.be.rejectedWith(\(\w*\))\([,;]\)/).rejects.toThrow(\1)\2/g
  ]]

  safe_sub [[
    %s/).to.eventually.be.rejectedWith(\(.*\))\([,;]\)/).rejects.toThrow(\1)\2/g
  ]]

  safe_sub [[
    %s/).to.eventually.be.fulfilled\([,;]\)/).resolves.toBeDefined()\1/g
  ]]

  -- Re-order any expectErrorWithMessage calls that have 4 arguments. The second should be moved to the fourth, as this
  -- is the debug message we can pass to expect()

  -- Multi-line case
  safe_sub [[
    %s/expectErrorWithMessage(\n\s*\([^,]*\),\n\s*\([^,]*\),\n\s*\([^,]*\),\n\s*\([^)]*\)\n\s*)/expectErrorWithMessage(\r\1,\r\3,\r\4,\r\2,\r)/g
  ]]

  -- Single-line case
  safe_sub [[
    %s/expectErrorWithMessage(\([^,]*\), \([^,]*\), \([^,]*\), \([^)]*\))/expectErrorWithMessage(\1, \3, \4, \2)/g
  ]]

  -- Regular expect conversions

  safe_sub [[
    %s/.to.deepEqualInAnyOrder(/.toIncludeSameMembers(/g
  ]]

  safe_sub [[
    %s/.to.equal(/.toBe(/g
  ]]

  safe_sub [[
    %s/.to.include(/.toContain(/g
  ]]

  safe_sub [[
    %s/.to.be.\(null\|undefined\)/.toBe(\1)/g
  ]]

  safe_sub [[
    %s/.toBe(null)/.toBeNull()/g
  ]]

  safe_sub [[
    %s/.toBe(undefined)/.toBeUndefined()/g
  ]]

  safe_sub [[
    %s/.to.be.ok/.toBeTruthy()/g
  ]]

  -- Manually convert this, as the jest-codemods converts this to expect(Object.keys(arr)).toHaveLength(0) which is redundant
  safe_sub [[
    %s/.to.be.empty/.toHaveLength(0)/g
  ]]

  -- Miscellaneous conversions
  safe_sub [[
    %s/import app from \'.*src\/app\'/import app from '\~\/app'
  ]]

  -- JEST CODEMOD
  -- exec the following
  -- jscodeshift --parser=ts -t node_modules/jest-codemods/dist/transformers/chai-should.js <target-test-file>

end

return M
