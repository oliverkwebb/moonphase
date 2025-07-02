# moonphase - Werewolf Early Warning System

A collection of snippets that get the phase of the moon, currently, the implementations are:

Systems Level Languages:
* C/C++
* Rust
* Zig
* Nim

Scripting Languages:
* Arturo
* Lua
* Janet
* JavaScript
* Python
* Raku
* Ruby

DSLs:
* awk
* [bc](https://en.wikipedia.org/wiki/Bc_(programming_language))

These functions take a time as an input (usually in unix epoch seconds or the languages official way of doing time),
and return the "age" of the moon in radians, such that `(1-cos(x))/2` returns the illuminated fraction of the moons
surface, this indirection is needed because across a full cycle, the same illuminated percent appears more than once,
the first and third quarter are a good example.

All implementations contain test cases showing how to get the illuminated fraction and percent using the code.

When the age of the moon is converted into a range between `[0,1]`. You can then get the age
of the moon in days by multiplying it by ~29.5.

You can also get the "index" of the phase, required for the phase name and emoji, with
the illuminated fraction and the angle. As an example, here's [some rust code](https://github.com/oliverkwebb/deskephem/blob/main/src/value.rs#L70)
for a different tool using the same algorithm:

```rust
fn phaseidx(ilumfrac: f64, ang: time::Angle) -> usize {
    match (ilumfrac, ang.degrees() > 90.0) {
        (0.00..0.04, _) => 0,
        (0.96..1.00, _) => 4,
        (0.46..0.54, true) => 6,
        (0.46..0.54, false) => 2,
        (0.54..0.96, true) => 5,
        (0.54..0.96, false) => 3,
        (_, true) => 7,
        (_, false) => 1,
    }
}
```

(Note that your angle has to be converted to a positive angle with `a-360.0*(floor(a/360))` or some similar modulo [(not remainder)](https://www.man7.org/linux/man-pages/man3/fmod.3.html) operation)

All these snippets are based off the algorithm in `moontool`, a GUI program made in the 80s
by John Walker, which based its algorithms off the book *Practical Astronomy With Your Calculator*.

---

# Rules for submission of [Favorite Language Here]

These rules may be bent for microlanguages and DSLs.

## The Copy and Paste Rule

Your function must be self-contained, such that someone could copy-paste
it into their code and not get an error. It also must not effect the
environment outside it if at all possible (no `#define` or mutating globals).
It must be as "pure" and self-contained as the language will allow.

