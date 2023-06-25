--------------------------------------------------------------------------------
-- Module
--------------------------------------------------------------------------------
-- Name of the (La)TeX module
module = "tikz-feynman"

--------------------------------------------------------------------------------
-- Documentation
--------------------------------------------------------------------------------
-- Documentation root directory
docfiledir = "docs"
-- Files which are part of the documentation but should not be typeset.
docfiles = {
  "CHANGELOG.md",
  "description.html",
  "*.bib",
}
-- Documentation files to typeset
typesetfiles = {"*.tex"}
-- Executable for compiling to docs
typesetexe = "lualatex"

--------------------------------------------------------------------------------
-- Testing
--------------------------------------------------------------------------------
testfiledir = "tests"
checkengines = {"luatex"}

--------------------------------------------------------------------------------
-- Packaging
--------------------------------------------------------------------------------
-- Whether to flatten source structure
flatten = false
-- Pack a TDS-style zip file
packtdszip = true
-- List of ready-to-use source location
tdsdirs = {
  tex = "tex/",
}

-- CTAN upload
uploadconfig = {
  -- Required
  announcement_file = "CHANGELOG.md",
  author = "Joshua P. Ellis",
  ctanPath = "/graphics/tikz-feynman/base",
  email = "tikz-feynman@jpellis.me",
  license = { "gpl3", "lppl1.3c" },
  pkg = "tikz-feynman",
  summary = "Feynman diagrams with TikZ",
  uploader = "github-actions",
  -- Optional
  bugtracker = "https://github.com/JP-Ellis/tikz-feynman/issues",
  description = [[
    TikZ-Feynman is a LaTeX package allowing Feynman diagrams to be easily
    generated within LaTeX with minimal user instructions and without the need
    of external programs. It builds upon the Tik>Z package and leverages the
    graph placement algorithms from TikZ in order to automate the placement of
    many vertices. TikZ-Feynman still allows fine-tuned placement of vertices so
    that even complex diagrams can still be generated with ease.
  ]],
  development = "https://github.com/JP-Ellis/tikz-feynman",
  home = "https://jpellis.me/projects/tikz-feynman",
  repository = "https://github.com/JP-Ellis/tikz-feynman",
  support = {
    "https://github.com/JP-Ellis/tikz-feynman",
    "https://tex.stackexchange.com/questions/tagged/tikz-feynman"
  },
  update = true,
}

function tag_hook(tagname, tagdate)
  local revision = options["--revision"] or tagname
  local major = string.match(tagname, "^v(%d+)")
  local minor = string.match(tagname, "^v%d+.(%d+)")
  local patch = string.match(tagname, "^v%d+.%d+.(%d+)")

  local revisiondate = options["--revision-date"] or tagdate
  local revisionfiletext = [[
\def\tikzfeynman@date{%s}
\def\tikzfeynman@version@major{%s}
\def\tikzfeynman@version@minor{%s}
\def\tikzfeynman@version@patch{%s}
]]
  local file = io.open("tex/generic/tikz-feynman/tikz-feynman.revision.tex", "w")
  file:write(string.format(revisionfiletext, revisiondate, major, minor, patch))
  file:close()
  return 0
end

target_list = target_list or { }
target_list.revisionfile = {
  desc = "Create revision data file",
  func = revisionfile
}
