package Alertomat::Service::SMTP;

use 5.020;
use Moo;
use Types::Standard qw(Str Int Object);
use Type::Params qw(compile);
use Type::Utils qw(class_type);
use Email::Stuffer;
use Email::Sender::Transport::SMTP;

has from => ( is => 'ro', isa => Str, required => 1 );

has host          => ( is => 'ro', isa => Str );
has port          => ( is => 'ro', isa => Int );
has ssl           => ( is => 'ro', isa => Str );
has sasl_username => ( is => 'ro', isa => Str );
has sasl_password => ( is => 'ro', isa => Str );

sub send {
  state $check = compile(Object, class_type('Alertomat::Alert'), Str);
  my ($self, $alert, $to) = $check->(@_);

  Email::Stuffer->from($self->from)
                ->to($to)
                ->subject($alert->summary)            # XXX pretty
                ->text_body($alert->as_debug_string)  # XXX pretty
                ->transport(SMTP =>
                              ($self->host          ? (host          => $self->host)          : ()),
                              ($self->port          ? (port          => $self->port)          : ()),
                              ($self->ssl           ? (ssl           => $self->ssl)           : ()),
                              ($self->sasl_username ? (sasl_username => $self->sasl_username) : ()),
                              ($self->sasl_password ? (sasl_password => $self->sasl_password) : ()),
                           )
                ->send_or_die; # XXX actually handle errors
}

1;
