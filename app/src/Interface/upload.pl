#!/usr/bin/perl -w

use strict;
use warnings;
use JSON;
use Data::Dumper;
use CGI;

use constant ROOT_DIR => '/home1/tqvivekv/public_html/backup/Interface/Img';

my $cgi = new CGI;
print $cgi->header();

my $action = $cgi->param('action');

my %actions = (
    upload        => sub { upload_image($cgi) },
    generate_html => sub { generate_html($cgi) },
    save          => sub { save_html() },
);

my $result   = $actions{$action}();
my $response = eval{ JSON::to_json( $result ||  {} )  };

print $response;

sub upload_image {
    my $cgi = shift;
    
    my $filename  = $cgi->param('upload');
    my $UPLOAD_FH = $cgi->upload('upload');
    
    my $file = join('/', ROOT_DIR, $filename);
    
    open (UPLOADFILE, ">$file") or die "failed to open file $!";
      binmode UPLOADFILE;
      while ( <$UPLOAD_FH> ) {
        print UPLOADFILE;
      }
    close UPLOADFILE;
    
    return { success => 1, filename => $file };
}

sub generate_html {
    my $cgi = shift;
    
    my $filename = $cgi->param('filename');
    my $full_path = join('/', ROOT_DIR, $filename);
    
    ############# command to convert into html ################################
    # python convert_single_image.py --png_path ../examples/drawn_example1.png \
    #  --output_folder ./generated_html \
    #  --model_json_file ../bin/model_json.json \
    #  --model_weights_file ../bin/weights.h5
    ###########################################################################
      
    my $html = <<HTML;
<html>
<Title>Test Sample</Title>
<h1>Test Header</h1>
</html>
HTML
    
    return { success => 1, data => $html };
}
 