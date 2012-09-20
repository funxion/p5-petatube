package YouTubeVideo;

use strict;
use warnings;
use Furl;
use JSON;
use List::MoreUtils qw/uniq/;

sub fetch_by_url {
    my ($url) = @_;

    my $furl = Furl->new;
    my $res = $furl->get($url);
    my $status = $res->status;
    die $res->status_line unless $res->is_success;
    my @ids = ($res->content =~ m{http://www\.youtube\.com/watch\?v=([a-zA-Z0-9\-_]+)(?:&|")?}sg);
    push @ids, ($res->content =~ m{http://www\.youtube\.com/v/([a-zA-Z0-9\-_]+)(?:&|")?}sg);

    # TODO YouTube内でのfetch

    return { ids => [ uniq @ids ], status => $status };
}

sub fetch_by_id {
    my ($id) = @_;

    my $furl = Furl->new;
    my $res = $furl->get('http://gdata.youtube.com/feeds/api/videos/' . $id . '?alt=json');
    my $status = $res->status;
    die $res->status_line unless $res->is_success;
    return decode_json($res->content);
}

1;
