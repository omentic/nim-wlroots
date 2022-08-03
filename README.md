# nim-wlroots

Work-in-progress Nim bindings for wlroots.

This aims to wrap the entire (very large) wlroots library for use with the Nim programming language. These bindings are currently very low-level and not particularly idiomatic, being ported directly from C, but are in the process of being tested and cleaned up.

They are currently based off of and bind the entirety of wlroots 0.15.1.

## Todo

- [ ] Complete a minimal implementation of tinywl
- [ ] Write other tests
- [ ] Replace various `ptr T` parameters with ptr types
- [ ] Look into how other bindings ([zig-wlroots](https://github.com/swaywm/zig-wlroots), [go-wlroots](https://github.com/swaywm/go-wlroots), [wlroots-rs](https://github.com/swaywm/wlroots-rs)) work for idiomatic tweaks to make
