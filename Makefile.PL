use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'TUXEDO',
    'VERSION_FROM' => 'TUXEDO.pm',
    'C' => ['TuxedoConstants.c'],
    'OBJECT' => 'TuxedoConstants.o TUXEDO.o'
);

package MY;

sub c_o
{
	".c\$(OBJ_EXT):\n\tbuildclient -w -o \$@ -f \"\$(CCCDLFLAGS) -I\$(PERL_INC) \$(DEFINE) -c \$*.c\"";
}

sub dynamic_lib
{
	my $text;
	$text .= "ARMAYBE = :\n";
	$text .= "OTHERLDFLAGS =\n";
	$text .= "INST_DYNAMIC_DEP =\n";
	$text .= "\n";
	$text .= "\$(INST_DYNAMIC): \$(OBJECT) \$(MYEXTLIB) \$(BOOTSTRAP) \$(INST_ARCHAUTODIR)/.exists \$(EXPORT_LIST) \$(PERL_ARCHIVE) \$(INST_DYNAMIC_DEP)\n";
	$text .= "\tbuildclient -w -o \$@ -f \"\$(LDDLFLAGS) \$(LDFROM) \$(OTHERLDFLAGS) \$(MYEXTLIB) \$(PERL_ARCHIVE) \$(LDLOADLIBS) \$(EXPORT_LIST)\"\n";
	$text .= "\t\$(CHMOD) \$(PERM_RWX) \$@\n";
	$text;
}
