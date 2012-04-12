#class XBuildModuleParser
package XBuildModuleParser;

use strict;
use diagnostics;
use XBuild::Utils;
use File::Basename;

#constructor
sub new {
  my ($class) = @_;
  my $self = 
    {
     module_path_       => undef,
     source_files_      => undef,
     lib_source_files_  => undef,
     header_files_      => undef,
     main_entry_files_  => undef,
     test_entry_files_  => undef,
     app_entry_files_   => undef,
     commands_          => undef,
     source_directory_  => undef,
     header_directory_  => undef,
    };

  bless $self, $class;
  return $self;
}

our($module_path_, @source_files_, @header_files_, @commands_, @lib_source_files_,
    @main_entry_files_, @_unit_test_files, $source_directory_, $header_directory_, @test_entry_files_, @app_entry_files_,
   );


sub classifymain_entry_files_ {
  if (@main_entry_files_ <= 0) {
    print "there is no main entry file \n";
    return;
  }

  foreach my $f (@main_entry_files_) {
    my $bkname = $f;
    my $basename = basename $f;
    (my $filename = $basename) =~ s/\.[^.]+$//;
    if ($filename =~ /^test/ ||
        $filename =~ /^t_/ ) {
      push @test_entry_files_, $f;
    }
    else {
      push @app_entry_files_, $f;
    }
  }
}


sub parse_all_files {
  my ($self) = @_;

  foreach my $file (@source_files_, @header_files_) {
    my $dst_dir = ($file =~ /\.cp{0,2}$/) ? $source_directory_ : $header_directory_;
    my $cmd = sprintf("mv %18s%18s", $file, $dst_dir);
    if (Utils::has_main_entry($file)) {
      push @main_entry_files_, $file;
    } else {
      push @lib_source_files_, $file;
      push @commands_, $cmd;
    }
  }

  splice @commands_, 0, 0, "mkdir $header_directory_" unless (@header_files_ <= 0) || (-d $header_directory_);
  splice @commands_, 0, 0, "mkdir $source_directory_" unless defined(@lib_source_files_) || (-d $source_directory_);

  # print "~~~~~~~~~~~~~~~~ commands: \n";
  # Utils::print_array @commands_;
  # print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
  # print "main entry files: \n";
  # Utils::print_array @main_entry_files_;

}


sub parse {
  my ($self, $path) = @_;

  print "source_directory_:\t$source_directory_ \n";
  print "header_directory_:\t$header_directory_ \n";

  $module_path_ = $path if defined($path);
  print "module_path_:$module_path_ \n";

  $self->parse_all_files;
  $self->classifymain_entry_files_;

}

sub set_directories {
  my ($self, $src, $inc) = @_;

  $source_directory_ = $src if defined($src);
  $header_directory_ = $inc if defined($inc);
}

sub set_source_files {
  my ($self, $files) = @_;

  foreach my $f (@$files) {
    push(@source_files_, $f);
    # print "pushed $f \n";
  }
  # print "++++++++++++++++ \n";
  # Utils::print_array @source_files_;
  # print "++++++++++++++++ \n";
}

sub set_header_files {
  my ($self, $files) = @_;
  foreach my $f (@$files) {
    push(@header_files_, $f);
  }
}


sub dprint {
  my ($self) = @_;

#  Utils::print_array @source_files_;
  print "src files:\t@source_files_ \n" if  @source_files_ > 0;
  print "hdr files:\t@header_files_ \n" if @header_files_ > 0;
  print "test_entry_files_:\t@test_entry_files_ \n" if @test_entry_files_ > 0;
  print "main_entry_files_:\t@main_entry_files_ \n" if @main_entry_files_ > 0;
  print "app_entry_files_:\t@app_entry_files_ \n" if @app_entry_files_ > 0;
  print "lib_source_files_:\t@lib_source_files_ \n";
}


1;
