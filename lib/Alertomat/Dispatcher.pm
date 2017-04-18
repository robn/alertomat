package Alertomat::Dispatcher;

use 5.020;
use Moo;
use Type::Params qw(compile);
use Types::Standard qw(Object HashRef);
use Type::Utils qw(class_type);

has config => ( is => 'ro', isa => HashRef, required => 1 );

sub dispatch {
  state $check = compile(Object, class_type('Alertomat::Alert'));
  my ($self, $alert) = $check->(@_);

  # XXX service config will be real service objects but y'know

  for my $service (values %{$self->config->{service}}) {
    my $handler = "Alertomat::Service::" . $service->{handler}; # XXX my god
    eval "use $handler"; # XXX also my god
    die $@ if $@;
    $handler->new(%$service)->send($alert, q{robn@fastmail.fm}); # XXX to from alert routing
  }
}

1;
