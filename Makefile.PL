use ExtUtils::MakeMaker;
use ExtUtils::Embed;
use Config;

my $os = $^O;

# get the ldopts used to build perl
chop(my $ldopts = ldopts);

#get the library paths from the ldopts.
@ldopts_elements = split( / /, $ldopts);
@tmp = grep /^-L/, @ldopts_elements;
my $libpaths = join " ", @tmp;

#get the DynaLoader archive for linking with AIX
@tmp = grep /DynaLoader/, @ldopts_elements;
my $dynaloader_lib = join " ", @tmp;
printf( "dynaloader_lib = $dynaloader_lib\n" );

# can get rid of the libpaths from the ldopts now
$ldopts =~ s/\s-L\S*//g;

my %opts = (
    NAME         => 'Tuxedo',
    VERSION_FROM => 'Tuxedo.pm',
    'C'          => [ 'TuxedoConstants.c' ],
    'OBJECT'     => 'TuxedoConstants.o Tuxedo.o',
    'INC'        => "-I $ENV{TUXDIR}/include",
    'DL_FUNCS'   => { "\$(NAME)" => ["boot_\$(NAME)" ] },
    'FUNCLIST'   => [ "PERL", "tpsvrinit", "tpsvrdone" ],
    'clean'      => { FILES => "ULOG.* ubbconfig TUXCONFIG *.tar.gz stderr stdout" }
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
    $opts{LIBS} = [ $libs ];
    $opts{LDDLFLAGS} = $Config{lddlflags} . " " . $dynaloader_lib;
}

WriteMakefile( %opts );


sub MY::postamble 
{
    my $string = <<EOS;

###########################################################
# PERLSVR - perl interpretor tuxedo server
###########################################################
PERL_EMBED_LIBS=$ldopts

BUILDSERVER = CC="$Config{cc} $libpaths"; export CC; \$(TUXDIR)/bin/buildserver

PERL_TARGET=PERLSVR\$(EXE_EXT)

\$(PERL_TARGET): \$(INST_DYNAMIC)
	\$(BUILDSERVER) -o \$@ -s ":PERL" -f "\$(INST_DYNAMIC)" -f "\$(PERL_EMBED_LIBS)"

pure_all :: \$(PERL_TARGET)

clean ::
	rm -f \$(PERL_TARGET) 

EOS

    return $string;
}
