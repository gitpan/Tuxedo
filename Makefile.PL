use ExtUtils::MakeMaker;

my $os = $^O;

my %opts = (
    NAME         => 'Tuxedo',
    VERSION_FROM => 'Tuxedo.pm',
    'C'          => [ 'TuxedoConstants.c' ],
    'OBJECT'     => 'TuxedoConstants.o Tuxedo.o',
    'INC'        => "-I $ENV{TUXDIR}/include"
);

# --- How shall we link with Tuxedo?
if ( $os eq 'MSWin32' )
{
    $opts{LIBS} = [ "-L$ENV{TUXDIR}/lib -llibtux -llibbuft -llibfml -llibfml32 -llibengine -lwsock32 -lkernel32 -ladvapi32 -luser32 -lgdi32 -lcomdlg32 -lwinspool" ];
    $opts{DEFINE} = "-D__TURBOC__";
}

# -- unix variants..tested on solaris
else
{
    $buildclient_cmd = `buildclient -v 2>/dev/null`;
    @buildclient_options = split( / /, $buildclient_cmd ); 
    @lib_options = grep /-[LlR]/, @buildclient_options;
    $libs = join " ", @lib_options;
    $libs =~ s/\${TUXDIR}/$ENV{TUXDIR}/;
    #print "libs = $libs\n";
    $opts{LIBS} = [ "$libs" ];
}

WriteMakefile( %opts );


