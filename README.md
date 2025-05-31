# moonphase - Werewolf Early Warning System

This repo is a collection of snippets of code that get the phase of the moon, currently, the implementations are:

* Rust
* JavaScript
* C/C++
* Lua
* Zig

These functions take a time as an input (usually in unix epoch seconds or the languages official way of doing time),
and return the "age" of the moon in radians, such that `(1-cos(x))/2` returns the illuminated fraction of the moons
surface, this indirection is needed because across a full cycle, the same illuminated percent appears more than once,
the first and third quarter are a good example.

All these snippets are based off the algorithm in `moontool`, a GUI program made in the 80s
by John Walker, which took its algorithms from the book *Practical Astronomy With Your Calculator*.

This project contains directories for each language, to run the test suite for any language,
go inside that languages folder and run `make`.

---

# Rules for submission of [Favorite Language Here]

## The Copy and Paste Rule

Your function must be self-contained, such that someone could copy-paste
it into their code and not get an error. It also must not effect the
environment outside it if at all possible (no `#define` or mutating globals).
It must be as "pure" and self-contained as the language will allow.
