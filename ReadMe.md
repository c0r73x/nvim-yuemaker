
## YueMaker

A fork of `svermeulen/nvim-moonmaker` for yuescript

### Options

- `g:yuemaker_compile_on_load` (default `1`): compile every out-of-date yue
  file on the runtimepath when the plugin loads. This scans all of them, so
  set it to `0` if the files are compiled another way; `:YueCompile` still
  works.
- `g:YueCompiler` (default `yue`): command used to compile a file.
- `g:YueMakerDeleteOrphanedLuaFiles`: delete lua files that have no matching
  yue file without asking.
