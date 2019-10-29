# Moppu
Lisp Game Jam Autumn 2019 Entry

## Requirements

- x86_64 Windows, GNU/Linux or macOS
- OpenGL 2.1 or 3.3+
- x86_64 SBCL or CCL
- Quicklisp

## How to install SBCL or CCL
- Go to http://www.sbcl.org or https://ccl.clozure.com and download the tool.
- After sbcl is installed you can call it with the command `sbcl` from command line.
- After ccl is installed run the exe in the folder and you are ready to go.

## How to install Quicklisp
- Go to https://www.quicklisp.org ad download ´quicklisp.lisp´
- While sbcl or ccl is running enter the command (load "c:/somewhere/path_to_where_you_downloaded_quicklisp.lisp")
- Quicklisp will be installed into your user folder.
- Run the command `(load "~/quicklisp/setup.lisp")` to start setup.
- Run the command `(ql:add-to-init-file)` to load quick lisp automatically when you run sbcl or ccl.

## How to Run
To run from REPL, clone project into ~/quicklisp/local-projects/ and run the following commands.

```
(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.testing.txt")

(ql:register-local-projects)

(ql:quickload :moppu) (moppu::run)
```

## Play the Builds
You can download the game for Windows, Mac and Linux from here.
https://github.com/borodust/moppu/releases

## Controls
| Control  | Keyboard |
|---------|---------|
| Walk  | Arrow Keys |
| Jump | Space |
