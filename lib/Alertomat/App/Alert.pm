package Alertomat::App::Alert;

use 5.020;
use Moo;
use Type::Utils qw(class_type);
use Plack::Request;
use Cpanel::JSON::XS;
use Alertomat::Alert;

has ctx => ( is => 'ro', isa => class_type('Alertomat'), required => 1 );

sub to_app {
  my ($self) = @_;
  return sub { return $self->app(@_) };
}

sub app {
  my ($self, $env) = @_;

  my $req = Plack::Request->new($env);

  if ($req->method ne 'POST') {
    return $req->new_response(405)->finalize;
  }
  if ($req->content_type ne 'application/json' || 0+$req->content_length == 0) {
    return $req->new_response(400)->finalize;
  }

  my $data = eval { decode_json($req->content) };
  if (!$data || ref $data ne 'HASH') {
    return $req->new_response(400)->finalize;
  }

  my $alert = eval { Alertomat::Alert->new(%$data) };
  if (my $err = $@) {
    return $req->new_response(400, [ 'Content-type' => 'text/plain' ], [ $err =~ s/ at .+//smr ])->finalize;
  }

  $self->ctx->dispatcher->dispatch($alert);

  my $res = $req->new_response(200);
  $res->finalize;
}

1;
