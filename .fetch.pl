# C 2005, 2008, 2014-2016 SPINLOCK Solutions 
use IO::Socket;
sub http_get {
  my( $host, $file, $out, $force)= @_;

  # Support for using this function to download files from mirrors which
  # include a subdirectory. In such cases, the subdir must become a part
  # of path, not hostname.
  if( $host=~ s#(/.*)##) { $file= $1. $file; }

  print STDERR "Downloading http://$host$file, size: ";
  my $socket = IO::Socket::INET->new(
    PeerAddr => $host,
    PeerPort => 'http(80)',
    Proto => 'tcp',)
  or die("Can't create IO::Socket::INET object ($!); exiting.");
  $socket->autoflush( 1);
  binmode $socket;

  print($socket "GET $file HTTP/1.0\r\nHost: $host\r\nUser-Agent: Mozilla/5.0 (iports)\r\n\r\n");
  my $line;
  my $len= 0;

  while( defined( $line= <$socket>)) {
    if( $len and $line=~ /^\s*$/) { last}
    elsif( $line=~ /^content-length:\s*(\d+)\s*$/i) {
      $len= $1;
      my $len_fmt= sprintf '%.2f', $len/ 1e6;
      print STDERR "$len_fmt MB\n";

      if( !$force and -e "$out" and (stat("$out"))[7]== $len) {
        print STDERR "  ($file already downloaded to $out; skipping.)\n";
        goto NEXT_FILE
      }

      open OUT, "> $out" or die "Can't wropen '$out' ($!); exiting.\n";
      binmode OUT;
    }
  }
  if( !$len) { die "Error downloading $_; exiting.\n"; }

  my $data;
  my $downloaded= 0;
  my $chunk= 0;
  my $len_fmt= '0.00';
  while( defined( $data= <$socket>)) {
    my $len= length($data);
    $chunk+= $len;
    $downloaded+= $len;
    if( $chunk>= 1024* 128) {
      $chunk= 0;
      $len_fmt= sprintf '%.2f', $downloaded/ 1e6;
    }
    print OUT $data
  }
  $len_fmt= sprintf '%.2f', $downloaded/ 1e6;

  close OUT or warn "Can't wrclose '$out' ($!); ignoring and continuing.\n";

  NEXT_FILE:
  close $socket;
}

http_get("$ARGV[0]", "$ARGV[1]", "$ARGV[2]", 1);
