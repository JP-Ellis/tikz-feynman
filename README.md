[Ti*k*Z-Feynman](http://jp-ellis.github.io/tikz-feynman)
=======================================================

This package provides a set of pre-defined styles in order to draw Feynman
diagrams using [Ti*k*Z](https://www.ctan.org/pkg/pgf) more easily and
consistently.  The set of styles defined here were originally inspired by
[this answer](http://tex.stackexchange.com/a/87395/26980) on
[tex.stackexchange.com](http://tex.stackexchange.com), so due credit must
go to Jake.

If you have any suggestions or have found any bugs, please feel free create a
new issue or pull request here on Github.

<!-- Installation -->
<!-- ------------ -->

<!-- This package is *not* currently offered on [CTAN](https://www.ctan.org) as it is -->
<!-- just a personal project of mine; however, if enough people find it useful, I -->
<!-- will look into making it available through CTAN. -->

<!-- In order to use this as it is, simply download `tikz-feynman.sty` and place it -->
<!-- in the same directory as your TeX file and include it using the usual -->
<!-- `\usepackage{tikz-feynman}`.  Alternatively, it is also possible to install -->
<!-- `tikz-feynman` system-wide by placing it inside TeX's search path (which will -->
<!-- vary based on your operating system). -->

<!-- In v3.0.0 of Ti*k*Z, there is a bug in the Lua component of the graphdrawing -->
<!-- library which prevents it from handling coordinate nodes properly.  This bug -->
<!-- does not seem to affect the usual Ti*k*Z drawing library.  If you wish to use -->
<!-- the `\graph` command with any of the options that require Lua, you will need to -->
<!-- apply the following patch: -->

<!-- ```diff -->
<!-- --- a/generic/pgf/graphdrawing/lua/pgf/gd/interface/InterfaceToDisplay.lua -->
<!-- +++ b/generic/pgf/graphdrawing/lua/pgf/gd/interface/InterfaceToDisplay.lua -->
<!-- @@ -263,6 +263,13 @@ end -->
 
<!--  function InterfaceToDisplay.createVertex(name, shape, path, height, binding_infos, anchors) -->
 
<!-- +  -- The path should never be empty, so we create a trivial path in the provided -->
<!-- +  -- path is empty.  This occurs with the `coordinate` shape for example. -->
<!-- +  if #path == 0 then -->
<!-- +    path:appendMoveto(0, 0) -->
<!-- +    path:appendClosepath() -->
<!-- +  end -->
<!-- + -->
<!--    -- Setup -->
<!--    local scope = InterfaceCore.topScope() -->
<!--    local binding = InterfaceCore.binding -->
<!-- ``` -->

<!-- Usage and Documentation -->
<!-- ----------------------- -->

<!-- Please see [tikz-feynman.pdf](https://jp-ellis.github.io/tikz-feynman/tikz-feynman.pdf). -->
