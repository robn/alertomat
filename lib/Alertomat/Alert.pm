package Alertomat::Alert;
  
use 5.020;
use Moo;
use Types::Standard qw(Enum ArrayRef Str);

has severity => ( is => 'ro', isa => Enum[qw(info warn crit)], required => 1 );
has tags     => ( is => 'ro', isa => ArrayRef[Str],            default => sub { [] } );
has summary  => ( is => 'ro', isa => Str,                      required => 1 );
has notes    => ( is => 'ro', isa => Str);

has as_debug_string => ( is => 'lazy', isa => Str );
sub _build_as_debug_string {
  my ($self) = @_;
  join '', (
    "alert: ", $self->summary, "\n",
    "severity: ", $self->severity, "\n",
    @{$self->tags} ? ("tags: @{$self->tags}\n") : (),
    $self->notes ? ("notes: ", $self->notes, "\n") : "",
  );
}

1;
