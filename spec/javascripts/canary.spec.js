var td = require("testdouble");

describe("Javascript testing", function() {
  it("work as expected", function() {
    var mockFunction = td.function();
    td.when(mockFunction(42)).thenReturn("Function Called!");
    expect(mockFunction(42)).toBe("Function Called!");
  });
});
