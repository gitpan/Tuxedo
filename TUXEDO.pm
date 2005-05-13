package TUXEDO;

use TPINIT_PTR;
use FBFR32_PTR;
use strict;
use Carp;
use Config;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
    BADFLDID
    FLD_CARRAY
    FLD_CHAR
    FLD_DOUBLE
    FLD_FLOAT
    FLD_FML32
    FLD_LONG
    FLD_PTR
    FLD_SHORT
    FLD_STRING
    FLD_VIEW32
    TP_CMT_COMPLETE
    TP_CMT_LOGGED
    TPABSOLUTE
    TPACK
    TPAPPAUTH
    TPCONV
    TPCONVCLTID
    TPCONVMAXSTR
    TPCONVTRANID
    TPCONVXID
    TPEABORT
    TPEBADDESC
    TPEBLOCK
    TPEDIAGNOSTIC
    TPEEVENT
    TPEHAZARD
    TPEHEURISTIC
    TPEINVAL
    TPEITYPE
    TPELIMIT
    TPEMATCH
    TPEMIB
    TPENOENT
    TPEOS
    TPEOTYPE
    TPEPERM
    TPEPROTO
    TPERELEASE
    TPERMERR
    TPESVCERR
    TPESVCFAIL
    TPESYSTEM
    TPETIME
    TPETRAN
    TPEXIT
    TPFAIL
    TPGETANY
    TPGETANY	
    TPGOTSIG
    TPINITNEED	
    TPMULTICONTEXTS
    TPNOAUTH
    TPNOBLOCK
    TPNOCHANGE
    TPNOREPLY
    TPNOTIME
    TPNOTRAN
    TPRECVONLY
    TPSA_FASTPATH
    TPSA_PROTECTED
    TPSENDONLY
    TPSIGRSTRT
    TPSUCCESS
    TPSYSAUTH
    TPTOSTRING
    TPTRAN
    TPU_DIP
    TPU_IGN
    TPU_MASK
    TPU_SIG
    TPU_THREAD

    TPQCORRID
    TPQFAILUREQ
    TPQBEFOREMSGID
    TPQGETBYMSGIDOLD
    TPQMSGID
    TPQPRIORITY
    TPQTOP
    TPQWAIT
    TPQREPLYQ
    TPQTIME_ABS
    TPQTIME_REL
    TPQGETBYCORRIDOLD
    TPQPEEK
    TPQDELIVERYQOS
    TPQREPLYQOS
    TPQEXPTIME_ABS
    TPQEXPTIME_REL
    TPQEXPTIME_NONE
    TPQGETBYMSGID
    TPQGETBYCORRID
    TPQQOSDEFAULTPERSIST
    TPQQOSPERSISTENT
    TPQQOSNONPERSISTENT

    TPKEY_SIGNATURE
    TPKEY_DECRYPT
    TPKEY_ENCRYPT
    TPKEY_VERIFICATION
    TPKEY_AUTOSIGN
    TPKEY_AUTOENCRYPT
    TPKEY_REMOVE
    TPKEY_REMOVEALL
    TPKEY_VERIFY
    TPEX_STRING
    TPSEAL_OK
    TPSEAL_PENDING
    TPSEAL_EXPIRED_CERT
    TPSEAL_REVOKED_CERT
    TPSEAL_TAMPERED_CERT
    TPSEAL_UNKNOWN
    TPSIGN_OK
    TPSIGN_PENDING
    TPSIGN_EXPIRED
    TPSIGN_EXPIRED_CERT
    TPSIGN_POSTDATED
    TPSIGN_REVOKED_CERT
    TPSIGN_TAMPERED_CERT
    TPSIGN_TAMPERED_MESSAGE
    TPSIGN_UNKNOWN

    tpabort
    tpacall
    tpalloc	
    tpbegin	
    tpbroadcast	
    tpcall
    tpcancel
    tpchkauth
    tpchkunsol
    tpclose
    tpcommit
    tpconnect
    tpconvert
    tpdequeue
    tpdiscon
    tpenqueue	
    tperrordetail	
    tperrno	
    tpexport	
    tpfree	
    tpgetctxt
    tpgetlev
    tpgetrply
    tpgprio
    tpimport
    tpinit
    tpnotify
    tpopen
    tppost
    tprealloc
    tprecv
    tpresume
    tpscmt
    tpsend
    tpsetctxt
    tpsetunsol	
    tpsprio
    tpstrerror	
    tpstrerrordetail
    tpsubscribe
    tpsuspend
    tpterm
    tptypes	
    tpunsubscribe	
    tuxgetenv
    tuxputenv
    tx_begin
    tx_close
    tx_commit
    tx_info
    tx_open
    tx_rollback
    tx_set_commit_return
    tx_set_transaction_control
    tx_set_transaction_timeout
    Usignal
    userlog
    handlePerlSignals

    Fadd32
    Fappend32
    Ferror32
    Fget32
    Findex32
    Fmkfldid32
    Fprint32
    Fstrerror32

    MIB_ALLFLAGS
    MIB_LOCAL
    MIB_PREIMAGE
    MIB_SELF
    MIBATT_KEYFIELD
    MIBATT_LOCAL
    MIBATT_NEWONLY
    MIBATT_REGEXKEY
    MIBATT_REQUIRED
    MIBATT_RUNTIME
    MIBATT_SETKEY
    QMIB_FORCECLOSE
    QMIB_FORCEDELETE
    QMIB_FORCEPURGE
    TAEAPP
    TAECONFIG
    TAEINVAL
    TAEOS
    TAEPERM
    TAEPREIMAGE
    TAEPROTO
    TAEREQUIRED
    TAESUPPORT
    TAESYSTEM
    TAEUNIQ
    TAOK
    TAPARTIAL
    TAUPDATED
    TMIB_ADMONLY
    TMIB_APPONLY
    TMIB_CONFIG
    TMIB_GLOBAL
    TMIB_NOTIFY

    SIGABRT
    SIGALRM
    SIGBUS
    SIGCHLD
    SIGCLD
    SIGEMT
    SIGFPE
    SIGHUP
    SIGILL
    SIGINT
    SIGIO
    SIGIOT
    SIGKILL
    SIGPIPE
    SIGPOLL
    SIGPWR
    SIGQUIT
    SIGSEGV
    SIGSYS
    SIGTERM
    SIGTRAP
    SIGURG
    SIGUSR1
    SIGUSR2
    SIGWINCH
);
$VERSION = '2.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
		croak "Your vendor has not defined TUXEDO macro $constname";
	}
    }
    no strict 'refs';
    if ( $] >= 6.00561 )
    {
        *$AUTOLOAD = sub () { $val };
    }    
    else
    {
        *$AUTOLOAD = sub { $val };
    }
    goto &$AUTOLOAD;
}

bootstrap TUXEDO $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

TUXEDO - Perl extension for blah blah blah

=head1 SYNOPSIS

  use TUXEDO;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for TUXEDO was created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head1 Exported constants
    
    TPU_SIG

=head1 AUTHOR

A. U. Thor, a.u.thor@a.galaxy.far.far.away

=head1 SEE ALSO

perl(1).

=cut
