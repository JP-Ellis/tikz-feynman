# General Settings
################################################################################
# Set to use PDFLatex and change the viewer
# $pdflatex = 'pdflatex';
$pdf_mode = 1;
$postscript_mode = 0;
$dvi_mode = 0;
$pdf_previewer = 'xdg-open %S';

# Increase the max repeats (for makeglossaries)
$max_repeat = 9;

# Add auxlock to the cleanup list
push @generated_exts, 'auxlock', 'synctex.gz';

# Support for PGF/TikZ Externalization
################################################################################
# Add a few files to cleanup
push @generated_exts, 'figlist', 'ist', 'makefile', 'unq';
# On the initial run, %tikzexternalflag is set to an empty list (when
# it reads this .latexmkrc).
#
# %tikzexternalflag is then set after successfully running make.

our %tikzexternalflag = ();

$pdflatex = 'internal tikzpdflatex -shell-escape -synctex=1 %O %S %B';

sub tikzpdflatex {
    our %externalflag;
    my $n = scalar(@_);
    my @args = @_[0 .. $n - 2];
    my $base = $_[$n - 1];

    system 'lualatex', @args;
    # Exit with error on failure
    if ($? != 0) {
        return $?
    }
    if ( !defined $externalflag->{$base} ) {
        $externalflag->{$base} = 1;
        if ( -e "$base.makefile" ) {
            system ("$make -j8 -f $base.makefile");
        }
    }
    return $?;
}
