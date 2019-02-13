#!perl -w

# Get WD items as listed in files.tdv and save to Turtle files
# If you get seemingly random riot errors, see https://phabricator.wikimedia.org/T216006: WD sometimes cuts off the RDF

open(my $files, "<", "files.tsv") or die "can't open files.tsv: $!\n";
while (<$files>) {
  my ($item,$file) = split;
  print STDERR "$item.nt -> $file.ttl\n";
  open (my $triples, "-|", "curl -s -L https://www.wikidata.org/entity/$item.nt") or die "can't pipe from curl: $!\n";
  open (my $riot, "|-", "cat prefixes.ttl - | riot --formatted ttl -syntax ttl - > $file.ttl") or die "can't pipe to riot: $!\n";
  while (<$triples>) {
    # print STDERR;
    print $riot $_ unless                          # filter out:
      m{"\@} && !m{"\@en }                         # non-EN prop names
      || m{schema.org/description} && !m{entity/Q} # property descriptions
      || m{_:genid}                                # owl:Restriction
  }
  close $riot;
}
