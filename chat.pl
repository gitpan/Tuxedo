#!/usr/bin/perl -Iblib/arch -Iblib/lib

use TUXEDO;
use tpadm;
use Sx;
use ExtUtils::Installed;

my $inst = ExtUtils::Installed->new();
my @modules = $inst->modules();

printf ( "My installed modules:\n" . "@modules" . "\n" );

connectToTuxedo();
$clientid = getMyClientId();
printf( "My client id is $clientid.\n" );
$count = 0;
while ( $count < 10 )
{
	@chatclients = getChatClientIds();
	printf( "current chat clients:\n" . "@chatclients" . "\n" );
	sleep( 6 );
	$count++;
}

tpterm();

sub connectToTuxedo
{
	my $password = "00000031". "\377" . "0" . "\377" . "utp_tester1" . 
                       "\377"  . "utputp1" . "\377";
	my $buffer = tpalloc( "TPINIT", "", TPINITNEED( length($password) ) );
	if ( $buffer == undef ) {
	    die "tpalloc failed: " . tpstrerror(tperrno) . "\n";
	}

	$buffer->usrname( "utp_tester1" );
	$buffer->cltname( "perltxchat" );
	$buffer->flags( TPMULTICONTEXTS );
	$buffer->passwd( "SVTuxedo" );
	$buffer->data( $password );

	tuxputenv( "WSNADDR=//kultarr:9210" );

	my $rval = tpinit( $buffer );
	if ( $rval == -1 ) {
	    die "tpinit failed: " . tpstrerror(tperrno) . "\n";
	}
}

sub getMyClientId
{
	$fml32 = tpalloc( "FML32", 0, 1024 );
	Fappend32( $fml32, TA_CLASS, "T_CLIENT", 0 );
	Fappend32( $fml32, TA_OPERATION, "GET", 0 );
	Fappend32( $fml32, TA_FLAGS, MIB_SELF, 0 );
	Findex32( $fml32, 0 );
	$rval = tpcall( ".TMIB", $fml32, 0, $fml32, $len, 0 );
	if ( $rval == -1 ) {
	    die ( "tpcall failed: " . tpstrerror(tperrno) . "\n" );
	}
	$rval = Fget32( $fml32, TA_CLIENTID, 0, $ta_clientid, $len );
	$ta_clientid;
}

sub getChatClientIds
{
	$fml32 = tpalloc( "FML32", 0, 1024 );
	Fappend32( $fml32, TA_CLASS, "T_CLIENT", 0 );
	Fappend32( $fml32, TA_OPERATION, "GET", 0 );
	Fappend32( $fml32, TA_CLTNAME, "perltxchat", 0 );
	Findex32( $fml32, 0 );
	$rval = tpcall( ".TMIB", $fml32, 0, $fml32, $len, 0 );
	if ( $rval == -1 ) {
	    die ( "tpcall failed: " . tpstrerror(tperrno) . "\n" );
	}
	$rval = Fget32( $fml32, TA_OCCURS, 0, $TA_OCCURS, $len );
	$index = 0;
	@chatclients = ();
	while ( $index < $TA_OCCURS ) {
		$rval = Fget32( $fml32, 
                                TA_CLIENTID, 
                                $index, 
                                $ta_clientid, 
                                $len 
                                );
		push @chatclients, $ta_clientid;
		$index++;
	}

	@chatclients;
}
