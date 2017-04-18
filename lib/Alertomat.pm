package Alertomat;

# ABSTRACT: alert broker

use 5.020;
use Moo;
use Types::Standard qw(HashRef);
use Type::Utils qw(class_type);
use Plack::Builder;
use Alertomat::Dispatcher;
use Alertomat::App::Alert;

has config => ( is => 'ro', isa => HashRef, required => 1 );

has dispatcher => ( is => 'lazy', isa => class_type('Alertomat::Dispatcher') );
sub _build_dispatcher { Alertomat::Dispatcher->new(config => shift->config) }

sub to_app {
  my ($self) = @_;

  builder {
    mount '/alert' => Alertomat::App::Alert->new(ctx => $self)->to_app,
  }
}

1;
