# Moppu
Lisp Game Jam Autumn 2019 Entry

## Requirements
Quicklisp

OpenGL 2.1 or 3.3+

x86_64 Windows, GNU/Linux or macOS

x86_64 SBCL or CCL

## How to Run
To run from REPL, clone project into ~/quicklisp/local-projects/ and run the following commands.

```
(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.testing.txt")

(ql:register-local-projects)

(ql:quickload :moppu) (moppu::run)
```

## Play the Builds
You can download the game for Windows, Mac and Linux from here.
https://github.com/borodust/moppu/releases/tag/v1.0.0

## Controls
| Control  | Keyboard |
|---------|---------|
| Walk  | Arrow Keys |
| Jump | Space |
