const test = require("node:test");
const assert = require("node:assert");
const app = require("./server");

test("application exports an Express app", () => {
  assert.strictEqual(typeof app, "function");
});