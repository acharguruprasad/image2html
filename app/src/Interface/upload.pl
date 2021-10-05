#!/opt/lampp/bin/perl

use strict;
use warnings;
use JSON;
use CGI;

use constant ROOT_DIR => '../../examples';
use constant HTML_DIR => '../generated_html';

my $cgi = new CGI;
print $cgi->header();

    my $filename  = $cgi->param('upload');
    my $UPLOAD_FH = $cgi->upload('upload');
    my $action = $cgi->param('action');
   
  if($action eq 'upload'){
    my $file = join('/', ROOT_DIR, $filename);
    
    open (UPLOADFILE, ">$file") or die "failed to open file $!";
      binmode UPLOADFILE;
      while ( <$UPLOAD_FH> ) {
        print UPLOADFILE;
      }
    close UPLOADFILE;
    print "{\"success\":1, \"action\":\"$action\"}";

    }elsif($action eq 'generate_html'){
	   my $filename = $cgi->param('filename');
    (my $html_filename = $filename) =~ s/(.*)\.(.*)/$1.html/g;

  my $result =1;

#eval{$result=`python3 /opt/lampp/htdocs/image2html/app/src/convert_single_image.py --output_folder /opt/lampp/htdocs/image2html/app/src/generated_html  --model_json_file /opt/lampp/htdocs/image2html/app/bin/model_json.json  --model_weights_file /opt/lampp/htdocs/image2html/app/bin/weights.h5 --png_path /opt/lampp/htdocs/image2html/app/examples/$filename`};
#print to_json({ success => 1, result => $result, error=>$@});


    my $Htmlfilepath = join('/', HTML_DIR, $html_filename);
    open(READFILE, $Htmlfilepath) or die "File '$Htmlfilepath' can't be opened";
    
    
    my $html;
    $html .= $_ while (<READFILE>);
close READFILE;
   # my $result =  { success => 1, data => $html, filename => $filename};
   print to_json({ success => 1, data => $html, filename => $Htmlfilepath, result => $result});
    #print "{\"success\":1,\"data\":\"$html\"}";

     }

